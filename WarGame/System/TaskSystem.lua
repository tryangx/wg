--
-- How to add new task( proposal )
--	1. add codes in Task_Create()
--  2. add data in DefaultTaskSteps, DefaultTaskContribution
--  3. add handler in _prepareTask, _executeTask, _finishTask, _workOnTask
--    2.a if task should be canceled, please add handler in _movingTask
--
local DEFAULT_TASK_INIT_DURATION = 0

local DEFAULT_TASK_DURATION      = 25

local _removeTask

local _moveWatcher = {}

local _combatTasks = {}

--all moving corps need to register this
local _interceptTasks = {}

---------------------------------------------------
-- Task Content Function

local function Task_Debug( task, content )	
	if Asset_Get( task, TaskAssetID.TYPE ) == TaskType.REINFORCE_CORPS then
		InputUtil_Pause( task:ToString( "DEBUG" ), content )
	end	
end

local function Task_Contribute( task, type )
	if not type then
		error( "no type for contribute" )
		return 0
	end
	local taskType = Asset_Get( task, TaskAssetID.TYPE )
	local datas = Scenario_GetData( "TASK_CONTRIBUTION_DATA" )
	local contribution = datas[taskType][type] or 0
	return contribution
end

local function Task_DoDefault( task )	
	local progress = Random_GetInt_Sync( 5, 10 )
	task:DoTask( progress )
	return Task_Contribute( task, "work" )
end

local function Task_SetCorpsStatus( corps, task )
	Asset_SetDictItem( corps, CorpsAssetID.STATUSES, CorpsStatus.IN_TASK, task )

	local chara = Asset_Get( corps, CorpsAssetID.LEADER )
	if chara then
		Asset_SetDictItem( chara, CharaAssetID.STATUSES, CharaStatus.IN_TASK, task )
	end
	Asset_Foreach( corps, CorpsAssetID.OFFICER_LIST, function ( chara )
		Asset_SetDictItem( chara, CharaAssetID.STATUSES, CharaStatus.IN_TASK, task )
	end)
end

local function Task_Remove( task )
	local actor = Asset_Get( task, TaskAssetID.ACTOR )
	local actorType = Asset_Get( task, TaskAssetID.ACTOR_TYPE )
	if actorType == TaskActorType.CHARA then
		Asset_SetDictItem( actor, CharaAssetID.STATUSES, CharaStatus.IN_TASK, nil )	
	elseif actorType == TaskActorType.CORPS then
		Task_SetCorpsStatus( actor, nil )
	end

	local type = Asset_Get( task, TaskAssetID.TYPE )	
	if type == TaskType.ESTABLISH_CORPS then
		local corps = Asset_GetDictItem( task, TaskAssetID.PARAMS, "corps" )
		Task_SetCorpsStatus( corps, nil )
	end

	local plan = Asset_GetDictItem( task, TaskAssetID.PARAMS, "plan" )
	if plan then
		local city = Asset_Get( task, TaskAssetID.LOCATION )
		Asset_SetDictItem( city, CityAssetID.PLANS, plan, nil )
		--Log_Write( "task",  "remove plan", task:ToString( "PLAN" ) )
	end

	_interceptTasks[actor] = nil
	Entity_Remove( task )
end

--actor was removed
function Task_Terminate( task )
	Task_Remove( task )

	Stat_Add( "Task@Terminate", task:ToString(), StatType.LIST )
end

local function Task_Resume( task )

end

local function Task_Failed( task )
	Log_Write( "task", task:ToString() .. " Failed" )
	local actor = Asset_Get( task, TaskAssetID.ACTOR )
	Message_Post( MessageType.STOP_MOVING, { actor = actor } )

	Asset_Set( task, TaskAssetID.RESULT, TaskResult.FAILED )
	task:FinishStep()
	task:Update()

	local type = Asset_Get( task, TaskAssetID.TYPE )
	if type == TaskType.INTERCEPT then
		--InputUtil_Pause( "Intercept failed", task:ToString() )
	elseif type == TaskType.HARASS_CITY then
		--InputUtil_Pause( "Harass failed", task:ToString() )
	end

	Stat_Add( "Task@Failed", task:ToString(), StatType.LIST )
end

local function Task_Success( task )	
	Log_Write( "task",  task:ToString() .. " succeed" )
	local actor = Asset_Get( task, TaskAssetID.ACTOR )
	Message_Post( MessageType.STOP_MOVING, { actor = actor } )

	local type = Asset_Get( task, TaskAssetID.TYPE )
	if type == TaskType.HARASS_CITY then
		--destroy city
		local dest = Asset_Get( task, TaskAssetID.DESTINATION )
		if dest then
			if Asset_Get( actor, CorpsAssetID.GROUP ) ~= Asset_Get( dest, CityAssetID.GROUP ) then
				City_Pillage( dest )
			end
		end
	elseif type == TaskType.INTERCEPT then
		--InputUtil_Pause( "Intercept Succeed " .. task:ToString() )
	end

	Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
	task:FinishStep()
	task:Update()

	Stat_Add( "Task@Success", 1, StatType.TIMES )

	--InputUtil_Pause( task:ToString(), "success" )
end

--reserved
local function carryfood()
	local actorType = Asset_Get( task, TaskAssetID.ACTOR_TYPE )
	if actorType == TaskActorType.CORPS then
		--corps carry food		
		local corps = Asset_Get( task, TaskAssetID.ACTOR )
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		if Supply_CorpsCarryFood( corps, city ) == false or Supply_CorpsCarryMaterial( corps, city ) == false then
			--cancel task
			Asset_Set( task, TaskAssetID.DURATION, 0 )
			return true
		end
	end
end

local function Task_GiveupWhenDestNotUs( taks )
	InputUtil_Pause( "check dis")

	local curGroup  = Asset_Get( task, TaskAssetID.GROUP )
	if not curGroup then
		return false
	end
	
	local dest = Asset_Get( task, TaskAssetID.DESTINATION )
	if not dest then
		return false
	end

	local destGroup = Asset_Get( dest, CityAssetID.GROUP )
	if curGroup == destGroup then
		return false
	end

	Task_Failed( task )
	InputUtil_Pause( "give up" )
end

local _movingTask = 
{
	TRANSPORT      = Task_GiveupWhenDestNotUs,

	DISPATCH_CORPS = Task_GiveupWhenDestNotUs,
	DISPATCH_CHARA = Task_GiveupWhenDestNotUs,
}

local _prepareTask = 
{
	HARASS_CITY     = function ( task )
		Intel_Post( IntelType.HARASS_CITY, Asset_Get( task, TaskAssetID.LOCATION ), { actor = Asset_Get( task, TaskAssetID.ACTOR ) } )
		Asset_Set( task, TaskAssetID.DURATION, 10 )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
		_interceptTasks[Asset_Get( task, TaskAssetID.ACTOR)] = task
	end,
	ATTACK_CITY     = function ( task )
		Intel_Post( IntelType.ATTACK_CITY, Asset_Get( task, TaskAssetID.LOCATION ), { actor = Asset_Get( task, TaskAssetID.ACTOR ) } )
		Asset_Set( task, TaskAssetID.DURATION, 10 )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
		_interceptTasks[Asset_Get( task, TaskAssetID.ACTOR )] = task		
	end,
	INTERCEPT       = function ( task )
		Stat_Add( "Intercept@" .. Asset_Get( task, TaskAssetID.GROUP ).name, 1, StatType.TIMES )
		Asset_Set( task, TaskAssetID.DURATION, 10 )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
		_interceptTasks[Asset_Get( task, TaskAssetID.ACTOR)] = task
	end,
	DISPATCH_CORPS  = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, 10 )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
		_interceptTasks[Asset_Get( task, TaskAssetID.ACTOR)] = task
	end,

	ESTABLISH_CORPS = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, 20 )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
	end,

	TRANSPORT       = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, 5 )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )

		--take the food / material / money
		local loc = Asset_Get( task, TaskAssetID.LOCATION )
		local transFood, transMoney, transMat = loc:GetTransCapacity()
		local food  = Asset_Get( loc, CityAssetID.FOOD )
		local mat   = Asset_Get( loc, CityAssetID.MATERIAL )
		local money = Asset_Get( loc, CityAssetID.MONEY )
		local reqFood, reqMoney = loc:GetReqProperty()
		--print( loc:ToString( "SUPPLY" ) )
		transFood  = math.min( transFood, food - reqFood )
		transMat   = math.min( transMat, math.ceil( mat * 0.5 ) )
		transMoney = math.min( transMoney,  money - reqMoney )
		Asset_SetDictItem( task, TaskAssetID.PARAMS, "food",     transFood )
		Asset_SetDictItem( task, TaskAssetID.PARAMS, "material", transMat )
		Asset_SetDictItem( task, TaskAssetID.PARAMS, "money",    transMoney )
		Asset_Set( loc, CityAssetID.FOOD, food - transFood )
		Asset_Set( loc, CityAssetID.MATERIAL, mat - transMat )
		Asset_Set( loc, CityAssetID.MONEY, money - transMoney )
		--InputUtil_Pause( loc:ToString( "SUPPLY" ) )
	end,

	DISPATCH_CHARA  = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, 5 )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
	end,
	CALL_CHARA      = function ( task )
		local dur = Move_CalcIntelTransDuration( Asset_Get( task, TaskAssetID.GROUP ), Asset_Get( task, TaskAssetID.LOCATION ), Asset_Get( task, TaskAssetID.DESTINATION ) )
		Asset_Set( task, TaskAssetID.DURATION, dur )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
	end,	

	DECLARE_WAR     = function ( task )
		local group    = Asset_Get( task, TaskAssetID.GROUP )
		local oppGroup = Asset_GetDictItem( task, TaskAssetID.PARAMS, "group" )
		local capital  = Asset_Get( oppGroup, GroupAssetID.CAPITAL )
		local loc      = Asset_Get( task, TaskAssetID.LOCATION )
		local dur = Move_CalcIntelTransDuration( group, loc, capital )
		Asset_Set( task, TaskAssetID.DURATION, dur )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
	end,
}

--return valid means not to set finished status
local _executeTask = 
{
	HARASS_CITY     = function ( task )
		if Asset_Get( task, TaskAssetID.STATUS ) == TaskStatus.RUNNING then return false end		
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		local corps = Asset_Get( task, TaskAssetID.ACTOR )
		if Asset_Get( city, CityAssetID.GROUP ) == Asset_Get( corps, CorpsAssetID.GROUP ) then
			Task_Failed( task )
		else
			Corps_HarassCity( corps, city )
			Asset_Set( task, TaskAssetID.STATUS, TaskStatus.RUNNING )
		end
	end,
	ATTACK_CITY     = function ( task )	
		if Asset_Get( task, TaskAssetID.STATUS ) == TaskStatus.RUNNING then return false end
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		local corps = Asset_Get( task, TaskAssetID.ACTOR )
		Corps_AttackCity( corps, city )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.RUNNING )
	end,
	INTERCEPT       = function ( task )
		if Asset_Get( task, TaskAssetID.STATUS ) == TaskStatus.WAITING then return false end		
		Asset_Set( task, TaskAssetID.DURATION, 60 )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
	end,
	DISPATCH_CORPS  = function ( task )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
	end,

	CONSCRIPT       = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,
	RECRUIT         = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,
	HIRE_GUARD      = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,

	ESTABLISH_CORPS = function ( task )		
		local city   = Asset_Get( task, TaskAssetID.DESTINATION )
		local leader = Asset_GetDictItem( task, TaskAssetID.PARAMS, "leader" )
		local corps  = Corps_EstablishInCity( city, leader )
		if leader then
			Asset_SetDictItem( leader, CharaAssetID.STATUSES, CharaStatus.IN_TASK, task )
		end
		Asset_SetDictItem( task, TaskAssetID.PARAMS, "corps", corps )
		Asset_SetDictItem( corps, CorpsAssetID.STATUSES, CorpsStatus.IN_TASK, task )

		Asset_Set( task, TaskAssetID.DURATION, 60 )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,
	REINFORCE_CORPS = function( task )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,
	ENROLL_CORPS = function( task )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,
	TRAIN_CORPS     = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,	

	DEV_AGRICULTURE = function( task )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,
	DEV_COMMERCE = function( task )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,
	DEV_PRODUCTION = function( task )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,
	BUILD_CITY      = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,
	LEVY_TAX      = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,
	TRANSPORT     = function ( task )
	end,

	HIRE_CHARA = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, 80 )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,
	DISPATCH_CHARA  = function ( task )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
	end,

	RECONNOITRE = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, 80 )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,
	SABOTAGE    = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, 80 )
		local workload = 250
		local dest = Asset_Get( task, TaskAssetID.DESTINATION )
		if dest:HasStatus( CityStatus.VIGILANT ) then
			workload = workload + 100
		end
		Asset_Set( task, TaskAssetID.WORKLOAD, workload )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,

	RESEARCH    = function ( task )
		local tech  = Asset_GetDictItem( task, TaskAssetID.PARAMS, "tech" )
		Asset_Set( task, TaskAssetID.WORKLOAD, tech.workload )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
		Asset_Set( task, TaskAssetID.DURATION, g_turnStep + 1 )
		local loc = Asset_Get( task, TaskAssetID.DESTINATION )
		Asset_Set( loc, CityAssetID.RESEARCH, tech )
	end,

	IMPROVE_RELATION = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, 20 )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,
	SIGN_PACT = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, 20 )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,
}

local function Task_DoConvPopu( task )
	local type = Asset_Get( task, TaskAssetID.TYPE )
	local params
	if type == TaskType.CONSCRIPT then
		params = Scenario_GetData( "CITY_CONSCRIPT_PARAMS" )
	elseif type == TaskType.RECRUIT then
		params = Scenario_GetData( "CITY_RECRUIT_PARAMS" )
	elseif type == TaskType.HIRE_GUARD then		
		params = Scenario_GetData( "CITY_HIREGUARD_PARAMS" )
	end
	local progress = Random_GetInt_Sync( 15, 35 )
	task:DoTask( progress )
	local workload = Asset_Get( task, TaskAssetID.WORKLOAD )	
	if Asset_Get( task, TaskAssetID.PROGRESS ) >= workload then		
		--InputUtil_Pause( task.id, Asset_Get( task, TaskAssetID.PROGRESS ) , workload )
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		local number = City_ConvReserves( city, params )				
		Asset_Set( task, TaskAssetID.PROGRESS, 0 )

		if type == TaskType.CONSCRIPT then
			Stat_Add( "Conscript@Num", number, StatType.ACCUMULATION )			
		elseif type == TaskType.RECRUIT then
			Stat_Add( "Recruit@Num",   number, StatType.ACCUMULATION )
		elseif type == TaskType.HIRE_GUARD then
			Stat_Add( "HireGuard@Num", number, StatType.ACCUMULATION )
		end
		local old = Asset_GetDictItem( task, TaskAssetID.PARAMS, "number" )
		if not old then old = 0 end
		Asset_SetDictItem( task, TaskAssetID.PARAMS, "number", old + number )
	end		
	return Task_Contribute( task, "work" )
end

--in WORKING status, task progress should increase by actor, 
--in some case, task can finish before duration is zero.
local _workOnTask = 
{
	ESTABLISH_CORPS = Task_DoDefault,
	REINFORCE_CORPS = function( task )
		local progress = Random_GetInt_Sync( 10, 35 )
		task:DoTask( progress )
		local workload = Asset_Get( task, TaskAssetID.WORKLOAD )		
		if Asset_Get( task, TaskAssetID.PROGRESS ) >= workload then
			local city    = Asset_Get( task, TaskAssetID.DESTINATION )
			local reserves= city:GetPopu( CityPopu.RESERVES )
			local number  = reserves < workload and reserves or workload
			local corps   = Asset_GetDictItem( task, TaskAssetID.PARAMS, "corps" )
			Log_Write( "task",  "reinforce-corps", corps:ToString(), "+" .. number )
			Corps_ReinforceTroop( corps, number )
			reserves = reserves - number
			city:SetPopu( CityPopu.RESERVES, reserves )
			if reserves == 0 then
				Asset_Set( task, TaskAssetID.DURATION, 0 )
			else
				Asset_Set( task, TaskAssetID.PROGRESS, 0 )
			end
		end
		return Task_Contribute( task, "work" )
	end,
	ENROLL_CORPS    = Task_DoDefault,	
	TRAIN_CORPS     = function ( task )
		local progress = Random_GetInt_Sync( 10, 35 )
		task:DoTask( progress )
		local workload = Asset_Get( task, TaskAssetID.WORKLOAD )
		if Asset_Get( task, TaskAssetID.PROGRESS ) >= workload then
			local corps = Asset_GetDictItem( task, TaskAssetID.PARAMS, "corps" )
			Corps_Train( corps, 1 )
			Asset_Set( task, TaskAssetID.PROGRESS, 0 )
			return DEFAULT_TASK_CONTRIBUTION
		end
		return Task_Contribute( task, "work" )
	end,
	CONSCRIPT       = Task_DoConvPopu,
	RECRUIT         = Task_DoConvPopu,
	HIRE_GUARD      = Task_DoConvPopu,

	DEV_AGRICULTURE = Task_DoDefault,
	DEV_COMMERCE    = Task_DoDefault,
	DEV_PRODUCTION  = Task_DoDefault,	
	BUILD_CITY      = Task_DoDefault,
	LEVY_TAX        = Task_DoDefault,

	HIRE_CHARA      = Task_DoDefault,

	RECONNOITRE     = function ( task )
		local intel = Random_GetInt_Sync( 15, 25 )
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		local loc  = Asset_Get( task, TaskAssetID.LOCATION )
		loc:Reconnoitre( city, intel )
		return Task_Contribute( task, "work" )
	end,
	SABOTAGE        = function ( task )
		local progress = Random_GetInt_Sync( 2, 5 )
		task:DoTask( progress )
		return Task_Contribute( task, "work" )
	end,

	RESEARCH        = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, g_turnStep + 1 )
		local progress = Random_GetInt_Sync( 50, 250 )
		task:DoTask( progress )
		--InputUtil_Pause( "do", Asset_Get( task, TaskAssetID.PROGRESS ) )
		return Task_Contribute( task, "work" )
	end,

	IMPROVE_RELATION = Task_DoDefault,
	SIGN_PACT        = Task_DoDefault,
}

local function Task_MoveChara( task )
	local actor = Asset_Get( task, TaskAssetID.ACTOR )
	
	--chara in corps, won't leave single
	if Asset_Get( actor, CharaAssetID.CORPS ) then
		error( actor:ToString() .. " has corps" )
	end

	local home = Asset_Get( actor, CharaAssetID.HOME )
	if home then
		home:CharaLeave( actor )
	end
	local dest = Asset_Get( task, TaskAssetID.DESTINATION )
	if dest then
		dest:CharaJoin( actor )
	end
	Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
	return Task_Contribute( task, "success" )
end

local _finishTask = 
{
	ESTABLISH_CORPS = function ( task )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_Contribute( task, "success" )
	end,
	REINFORCE_CORPS = function ( task )
		local corps = Asset_Get( task, TaskAssetID.ACTOR )
		local loc   = Asset_Get( task, TaskAssetID.DESTINATION )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_Contribute( task, "success" )
	end,
	ENROLL_CORPS    = function ( task )		
		local corps = Asset_Get( task, TaskAssetID.ACTOR )
		local city  = Asset_Get( task, TaskAssetID.DESTINATION )
		Corps_EnrollInCity( corps, city )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_Contribute( task, "success" )
	end,	
	DISPATCH_CORPS  = function ( task )
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		local corps = Asset_GetDictItem( task, TaskAssetID.PARAMS, "corps" )
		Corps_Dispatch( corps, city )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_Contribute( task, "success" )
	end,
	CONSCRIPT       = function ( task )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_Contribute( task, "success" )
	end,
	RECRUIT         = function ( task )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_Contribute( task, "success" )
	end,
	HIRE_GUARD      = function ( task )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_Contribute( task, "success" )
	end,

	DEV_AGRICULTURE = function( task )
		--InputUtil_Pause( "dev agri", Asset_Get( task, TaskAssetID.PROGRESS ))
		City_Develop( Asset_Get( task, TaskAssetID.DESTINATION ), Asset_Get( task, TaskAssetID.PROGRESS ), CityAssetID.AGRICULTURE )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_Contribute( task, "success" )
	end,
	DEV_COMMERCE = function( task )
		City_Develop( Asset_Get( task, TaskAssetID.DESTINATION ), Asset_Get( task, TaskAssetID.PROGRESS ), CityAssetID.COMMERCE )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_Contribute( task, "success" )
	end,
	DEV_PRODUCTION = function( task )
		City_Develop( Asset_Get( task, TaskAssetID.DESTINATION ), Asset_Get( task, TaskAssetID.PROGRESS ), CityAssetID.PRODUCTION )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_Contribute( task, "success" )
	end,
	BUILD_CITY      = function ( task )
		City_Build( Asset_Get( task, TaskAssetID.DESTINATION ) )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_Contribute( task, "success" )
	end,
	LEVY_TAX      = function ( task )
		City_LevyTax( Asset_Get( task, TaskAssetID.DESTINATION ), Asset_Get( task, TaskAssetID.PROGRESS ) )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_Contribute( task, "success" )
	end,
	TRANSPORT     = function ( task )
		local food  = Asset_GetDictItem( task, TaskAssetID.PARAMS, "food" )
		local mat   = Asset_GetDictItem( task, TaskAssetID.PARAMS, "material" )
		local money = Asset_GetDictItem( task, TaskAssetID.PARAMS, "money" )
		local dest  = Asset_Get( task, TaskAssetID.DESTINATION )
		--print( dest:ToString( "SUPPLY" ) )
		Asset_Plus( dest, CityAssetID.FOOD, food )
		Asset_Plus( dest, CityAssetID.MATERIAL, mat )
		Asset_Plus( dest, CityAssetID.MONEY, money )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		--InputUtil_Pause( dest:ToString( "SUPPLY" ) )
		Stat_Add( "Transport@FOOD", food, StatType.ACCUMULATION )
		Stat_Add( "Transport@MONEY", money, StatType.ACCUMULATION )
		Stat_Add( "Transport@MATERIAL", mat, StatType.ACCUMULATION )
		
		return Task_Contribute( task, "success" )
	end,
	
	HIRE_CHARA = function( task )		
		local progress = Asset_Get( task, TaskAssetID.PROGRESS )
		local rand = Random_GetInt_Sync( 1, Asset_Get( task, TaskAssetID.WORKLOAD ) )
		if rand <= progress then
			local city  = Asset_Get( task, TaskAssetID.DESTINATION )
			local actor = Asset_Get( task, TaskAssetID.ACTOR )
			local group = Asset_Get( task, TaskAssetID.GROUP )
			local chara = CharaCreator_GenerateFictionalChara( city )
			if not chara then DBG_Trace( "no chara to hire" ) end
			Chara_Serve( chara, group, city )
			Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
			Stat_Add( "Hire@Success", 1, StatType.TIMES )
			return Task_Contribute( task, "success" )
		else
			Report_Feedback( task:ToString( "SIMPLE" ) .. " FAILED" )
			Asset_Set( task, TaskAssetID.RESULT, TaskResult.FAILED )
			Stat_Add( "Hire@Failed", 1, StatType.TIMES )
			return Task_Contribute( task, "failed" )
		end
	end,
	PROMOTE_CHARA = function ( task )
		local actor = Asset_Get( task, TaskAssetID.ACTOR )
		local job = Asset_GetDictItem( task, TaskAssetID.PARAMS, "job" )
		Chara_Promote( actor, job )
		return Task_Contribute( task, "success" )
	end,
	DISPATCH_CHARA  = Task_MoveChara,
	CALL_CHARA      = Task_MoveChara,

	RECONNOITRE = function ( task )		
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_Contribute( task, "success" )
	end,
	SABOTAGE    = function ( task )
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		local loc  = Asset_Get( task, TaskAssetID.LOCATION )
		local spy  = loc:GetSpy( city )
		local progress = Asset_Get( task, TaskAssetID.PROGRESS )		
		local workload = Asset_Get( task, TaskAssetID.WORKLOAD )
		progress = progress + CitySpyParams.GRADE_OP_BONUS[spy.grade]		
		if progress >= workload then
			--InputUtil_Pause( "Sabotage", progress, workload, g_Time:CalcDiffDayByDate( Asset_Get( task, TaskAssetID.BEGIN_TIME ) ) )
			city:Sabotage()
			loc:LoseSpy( city, 1 )
			Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
			Stat_Add( "OP@Suc", 1, StatType.TIMES )
			return Task_Contribute( task, "success" )
		else
			Asset_Set( task, TaskAssetID.RESULT, TaskResult.FAILED )
			Stat_Add( "OP@Failed", 1, StatType.TIMES )
			return Task_Contribute( task, "failed" )
		end
	end,

	RESEARCH  = function ( task )
		local group = Asset_Get( task, TaskAssetID.GROUP )
		local tech  = Asset_GetDictItem( task, TaskAssetID.PARAMS, "tech" )
		group:MasterTech( tech )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_Contribute( task, "success" )
	end,

	IMPROVE_RELATION = function ( task )
		local progress = Asset_Get( task, TaskAssetID.PROGRESS )
		local rand = Random_GetInt_Sync( 1, Asset_Get( task, TaskAssetID.WORKLOAD ) )
		if rand < progress then
			local group = Asset_Get( task, TaskAssetID.GROUP )
			local oppGroup = Asset_GetDictItem( task, TaskAssetID.PARAMS, "group" )
			Dipl_ImproveRelation( group, oppGroup, progress )			
			Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
			Stat_Add( "Dipl@Improve", g_Time:CreateCurrentDateDesc() .. " " .. group:ToString() .. "-->" .. oppGroup:ToString(), StatType.LIST )
			return Task_Contribute( task, "success" )
		else
			Asset_Set( task, TaskAssetID.RESULT, TaskResult.FAILED )
			return Task_Contribute( task, "failed" )
		end
	end,
	DECLARE_WAR      = function ( task )
		local group = Asset_Get( task, TaskAssetID.GROUP )
		local oppGroup = Asset_GetDictItem( task, TaskAssetID.PARAMS, "group" )
		Dipl_DeclareWar( group, oppGroup )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		Stat_Add( "Dipl@DeclareWar", g_Time:CreateCurrentDateDesc() .. " " .. group:ToString() .. "-->" .. oppGroup:ToString(), StatType.LIST )
		return Task_Contribute( task, "success" )
	end,
	SIGN_PACT        = function ( task )
		local progress = Asset_Get( task, TaskAssetID.PROGRESS )
		local rand = Random_GetInt_Sync( 1, Asset_Get( task, TaskAssetID.WORKLOAD ) )
		if rand < progress then
			local group    = Asset_Get( task, TaskAssetID.GROUP )
			local oppGroup = Asset_GetDictItem( task, TaskAssetID.PARAMS, "group" )
			local pact     = Asset_GetDictItem( task, TaskAssetID.PARAMS, "pact" )
			local time     = Asset_GetDictItem( task, TaskAssetID.PARAMS, "time" )

			local relation = Dipl_GetRelation( group, oppGroup )
			if not relation:HasPact( pact ) then
				Dipl_SignPact( group, oppGroup, pact, time )
			end
			Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
			Stat_Add( "Dipl@SignPact", g_Time:CreateCurrentDateDesc() .. " " .. group:ToString() .. "-->" .. oppGroup:ToString() .. "=" .. MathUtil_FindName( RelationPact, pact ), StatType.LIST )
			return Task_Contribute( task, "success" )
		else
			Asset_Set( task, TaskAssetID.RESULT, TaskResult.FAILED )
			return Task_Contribute( task, "failed" )
		end
	end,
}

---------------------------------------------------

local function Task_IsArriveDestination( task )	
	local actor = Asset_Get( task, TaskAssetID.ACTOR )	
	local actorType = Asset_Get( task, TaskAssetID.ACTOR_TYPE )

	local loc
	if actorType == TaskActorType.CHARA then
		loc = Asset_Get( actor, CharaAssetID.LOCATION )
	elseif actorType == TaskActorType.CORPS then
		loc = Asset_Get( actor, CorpsAssetID.LOCATION )
	end

	local destination = Asset_Get( task, TaskAssetID.DESTINATION )
	--print( actor.name,  loc.name, destination.name )	
	return loc == destination
end

local function Task_IsAtHome( task )
	local actor = Asset_Get( task, TaskAssetID.ACTOR )	
	local actorType = Asset_Get( task, TaskAssetID.ACTOR_TYPE )
	
	if actorType == TaskActorType.CHARA then
		return actor:IsAtHome()
	
	elseif actorType == TaskActorType.CORPS then
		return actor:IsAtHome()
	end
	return false
end

---------------------------------------------------

function Task_CityReceive( task, city )
	local city = Asset_Get( task, TaskAssetID.LOCATION )
	local plan = Asset_GetDictItem( task, TaskAssetID.PARAMS, "plan" )
	Asset_SetDictItem( city, CityAssetID.PLANS, plan, task )
end

function Task_CharaReceive( task, chara )
	if chara:IsBusy() then
		print( task:ToString() )
		error( chara:ToString() .. " has task " .. chara:GetTask():ToString() )
	end

	Asset_SetDictItem( chara, CharaAssetID.STATUSES, CharaStatus.IN_TASK, task )

	local subordinates = {}

	local opens = {}
	table.insert( opens, chara )
	
	local inx = 1
	local cur = opens[inx]
	while cur do
		Asset_SetDictItem( task, TaskAssetID.CONTRIBUTORS, cur, 0 )
		Asset_SetDictItem( cur, CharaAssetID.STATUSES, CharaStatus.IN_TASK, task )
		Asset_AppendList( cur, CharaAssetID.TASKS, task )
		Asset_Foreach( cur, CharaAssetID.SUBORDINATES, function( subordinate )
			table.insert( opens, subordinate )
		end )
		inx = inx + 1
		cur = opens[inx]		
	end
end

function Task_CorpsReceive( task, corps )	
	if corps:IsBusy() then
		print( task:ToString() )
		error( corps:ToString() .. " has task" )
	end

	Asset_SetDictItem( task, TaskAssetID.CONTRIBUTORS, corps, 0 )
	--Asset_AppendList( corps, CorpsAssetID.TASKS, task )

	Task_SetCorpsStatus( corps, task )

	--Log_Write( "task",  corps:ToString(), "recv task" )
end

function Task_Create( taskType, actor, location, destination, params )
	local task = Entity_New( EntityType.TASK )
	Asset_Set( task, TaskAssetID.TYPE, taskType )

	--copy same data
	Asset_Set( task, TaskAssetID.ACTOR, actor )	
	Asset_Set( task, TaskAssetID.LOCATION, location )
	Asset_Set( task, TaskAssetID.DESTINATION, destination )
	Asset_CopyDict( task, TaskAssetID.PARAMS, params )

	local actor = Asset_Get( task, TaskAssetID.ACTOR )
	local type = Asset_Get( task, TaskAssetID.TYPE )
	
	--need CORPS
	if type == TaskType.HARASS_CITY 
		or type == TaskType.ATTACK_CITY 
		or type == TaskType.INTERCEPT
		or type == TaskType.DISPATCH_CORPS

		or type == TaskType.REINFORCE_CORPS
		or type == TaskType.DISMISS_CORPS 
		or type == TaskType.TRAIN_CORPS
		or type == TaskType.ENROLL_CORPS
		or type == TaskType.UPGRADE_CORPS
		then
		Asset_Set( task, TaskAssetID.ACTOR_TYPE, TaskActorType.CORPS )
		Task_CorpsReceive( task, actor )

	--need CHARA
	elseif type == TaskType.HIRE_CHARA
		or type == TaskType.PROMOTE_CHARA
		or type == TaskType.DISPATCH_CHARA
		or type == TaskType.CALL_CHARA
		or type == TaskType.MOVE_CAPITAL

		or type == TaskType.ESTABLISH_CORPS

		then
		--!!!Attention
		--More same task in this group can be executed!
		--
		Asset_Set( task, TaskAssetID.ACTOR_TYPE, TaskActorType.CHARA )
		Task_CharaReceive( task, actor )

	--city only execute one task
	--need actor
	elseif type == TaskType.DEV_AGRICULTURE
		or type == TaskType.DEV_COMMERCE
		or type == TaskType.DEV_PRODUCTION
		or type == TaskType.BUILD_CITY
		or type == TaskType.LEVY_TAX
		or type == TaskType.TRANSPORT

		or type == TaskType.CONSCRIPT
		or type == TaskType.RECRUIT
		or type == TaskType.HIRE_GUARD		

		then
		Asset_Set( task, TaskAssetID.ACTOR_TYPE, TaskActorType.CHARA )
		Task_CharaReceive( task, actor )
		Task_CityReceive( task, location )

	--city only execute one task
	--need actor
	elseif type == TaskType.IMPROVE_RELATION
		or type == TaskType.DECLARE_WAR
		or type == TaskType.SIGN_PACT

		or type == TaskType.RECONNOITRE
		or type == TaskType.SABOTAGE

		or type == TaskType.RESEARCH
		then
		Asset_Set( task, TaskAssetID.ACTOR_TYPE, TaskActorType.CHARA )
		Task_CharaReceive( task, actor )
		Task_CityReceive( task, location )

	else
		error( "Should deal with this type=" .. MathUtil_FindName( TaskType, type ) )
	end

	local actorType = Asset_Get( task, TaskAssetID.ACTOR_TYPE )
	if actorType == TaskActorType.CHARA then
		Asset_Set( task, TaskAssetID.GROUP, Asset_Get( actor, CharaAssetID.GROUP ) )
	elseif actorType == TaskActorType.CORPS then
		Asset_Set( task, TaskAssetID.GROUP, Asset_Get( actor, CorpsAssetID.GROUP ) )
	end

	Asset_Set( task, TaskAssetID.BEGIN_TIME, g_Time:GetDateValue() )
	Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_INIT_DURATION )

	Log_Write( "task", g_Time:ToString() .. " create task--" .. task:ToString() )

	--Stat_Add( "Task@Issue", task:ToString( "DETAIL" ), StatType.LIST )
	Stat_Add( "TaskCreate@" .. MathUtil_FindName( TaskType, type ), 1, StatType.TIMES )
	--DBG_Watch( "Debug_Meeting", "    execute task=" .. task:ToString() )
end

function Task_IssueByProposal( proposal )		
	--convert proposal type into task type
	local typeName = MathUtil_FindName( ProposalType, Asset_Get( proposal, ProposalAssetID.TYPE ) )
	local taskType = TaskType[typeName]	

	local actor = Asset_Get( proposal, ProposalAssetID.ACTOR )
	local loc   = Asset_Get( proposal, ProposalAssetID.LOCATION )
	local dest  = Asset_Get( proposal, ProposalAssetID.DESTINATION )
	local params = Asset_GetDict( proposal, ProposalAssetID.PARAMS )

	if taskType == TaskType.ATTACK_CITY then		
		local list = Asset_GetDictItem( proposal, ProposalAssetID.PARAMS, "corps_list" )
		for _, corps in ipairs( list ) do
			Task_Create( taskType, corps, loc, dest, params )
		end
	else
		Task_Create( taskType, actor, loc, dest, params )
	end
end

local function Task_BackHome( task )
	if Move_IsMoving( Asset_Get( task, TaskAssetID.ACTOR ) ) == false then
		Stat_Add( "Task@BackHome", 1, StatType.TIMES )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.MOVING )

		local actor     = Asset_Get( task, TaskAssetID.ACTOR )
		local actorType = Asset_Get( task, TaskAssetID.ACTOR_TYPE )
		if actorType == TaskActorType.CHARA then
			Move_Chara( actor, Asset_Get( actor, CharaAssetID.HOME ) )

		elseif actorType == TaskActorType.CORPS then				
			local dest = Asset_Get( actor, CorpsAssetID.ENCAMPMENT )
			if dest then
				Log_Write( "task",  task:ToString() .. " back home=" .. String_ToStr( dest, "name" ) )
				Move_Corps( actor, dest )
			else
				local loc = Asset_Get( actor, CorpsAssetID.LOCATION )				
				dest = Asset_Get( task, TaskAssetID.LOCATION )
				if loc ~= dest then
					--back to location where start the task
					Log_Write( "task",  task:ToString() .. " back home=" .. String_ToStr( dest, "name" ) )
					Move_Corps( actor, dest )
				end
			end
		end
	end
end

local function Task_Move2Destination( task )	
	if Move_IsMoving( Asset_Get( task, TaskAssetID.ACTOR ) ) == false then
		Stat_Add( "Task@Move2Dest", 1, StatType.TIMES )

		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.MOVING )

		local actor     = Asset_Get( task, TaskAssetID.ACTOR )
		local actorType = Asset_Get( task, TaskAssetID.ACTOR_TYPE )		
		local loc       = Asset_Get( task, TaskAssetID.DESTINATION )
		if actorType == TaskActorType.CHARA then
			Log_Write( "task",  task:ToString() .. " move to dest=" .. String_ToStr( loc, "name" ) )
			Move_Chara( actor, loc )
		elseif actorType == TaskActorType.CORPS then			
			Log_Write( "task",  task:ToString() .. " move to dest=" .. String_ToStr( loc, "name" ) )
			Move_Corps( actor, loc )
			Supply_CorpsCarryFood( actor, loc )
		end
	end
end

local function Task_End( task )
	Asset_Set( task, TaskAssetID.END_TIME, g_Time:GetDateValue() )

	Stat_Add( "Task@End", task:ToString( "END" ), StatType.LIST )
	Stat_Add( "TaskEnd@" .. MathUtil_FindName( TaskType, Asset_Get( task, TaskAssetID.TYPE ) ), 1, StatType.TIMES )
	Log_Write( "task",  task:ToString() .. "end task" )
	--Log_Write( "meeting", g_Time:ToString() .. task:ToString() .. " end" )

	Task_Remove( task )

	return true
end

local function Task_Reply( task )
	--default go back home
	if Task_IsAtHome( task ) == false then
		if Asset_Get( task, TaskAssetID.STATUS ) ~= TaskStatus.MOVING then
			Task_BackHome( task )
		end
		return
	else
		if Asset_Get( task, TaskAssetID.STATUS ) == TaskStatus.MOVING then
			Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
		end
	end

	--bonus to contributor
	if Asset_Get( task, TaskAssetID.ACTOR_TYPE ) == TaskActorType.CHARA then		
		Asset_Foreach( task, TaskAssetID.CONTRIBUTORS, function( value, actor )
			actor:Contribute( value )
		end )
	else
		--todo
	end

	Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )

	Stat_Add( "Task@Reply", 1, StatType.TIMES )
end

local function Task_Finish( task )	
	--can execute the task
	local contribution
	local fn = _finishTask[Asset_Get( task, TaskAssetID.TYPE )]
	if fn then
		contribution = fn( task )
	else
		--default set status to WAITING, in order to go next step
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
	end

	if contribution and contribution > 0 then
		task:Contribute( Asset_Get( task, TaskAssetID.ACTOR ), contribution )
	end

	--Stat_Add( "Task@Finish", task:ToString(), StatType.LIST )
end

function Task_Do( task, actor )
	local type = Asset_Get( task, TaskAssetID.TYPE )
	if type == TaskType.HARASS_CITY
		or type == TaskType.ATTACK_CITY then
		return
	end

	if Asset_Get( task, TaskAssetID.STATUS ) ~= TaskStatus.WORKING then
		return
	end

	if Asset_Get( task, TaskAssetID.DURATION ) <= 0 then
	end

	local contribution = DEFAULT_TASK_CONTRIBUTION

	local contribution
	local fn = _workOnTask[Asset_Get( task, TaskAssetID.TYPE )]	
	if fn then
		contribution = fn( task, "work" )
	else
		error( "no work function for working status, " .. MathUtil_FindName( TaskType, type ) )
	end

	if contribution and contribution > 0 then		
		--InputUtil_Pause( "cont=" .. contribution, task:ToString() )
		task:Contribute( Asset_Get( task, TaskAssetID.ACTOR ), contribution )
	end

	--Stat_Add( "Task@Do", 1, StatType.TIMES )
end

local function Task_Execute( task )	
	local taskType = Asset_Get( task, TaskAssetID.TYPE )

	--not arrive the destination
	if Task_IsArriveDestination( task ) == false then		
		if Asset_Get( task, TaskAssetID.STATUS ) ~= TaskStatus.MOVING then
			Task_Move2Destination( task )
		else
			local fn = _movingTask[taskType]
			if fn then
				fn( task )				
			end
		end
		return
	else
		if Asset_Get( task, TaskAssetID.STATUS ) == TaskStatus.MOVING then
			--Task_Debug( task, "WAITING " .. task:ToString() )
			Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
		else
			--already arrive the destination, we should check here in the case that need to move
			--Task_Debug( task, "arrived " .. task:ToString() )
		end
	end

	if Asset_Get( task, TaskAssetID.STATUS ) == TaskStatus.WORKING then
		--Task_Debug( task, "wokring " .. task:ToString() )
		Task_Do( task )
		return
	end

	local fn = _executeTask[taskType]
	if fn then		
		if fn( task ) == false then
			return
		end
		--Task_Debug( task, "execute " .. task:ToString() )
	else
		DBG_Warning( "task [" .. MathUtil_FindName( TaskType, taskType ) .. "]", " no execute function" )
	end

	--Stat_Add( "Task@Excute", task:ToString(), StatType.LIST )
end

local function Task_Prepare( task )
	if Asset_Get( task, TaskAssetID.STATUS ) == TaskStatus.WAITING then return end

	local fn = _prepareTask[Asset_Get( task, TaskAssetID.TYPE )]
	if fn then
		fn( task )
	end

	Stat_Add( "Task@Prepare", 1, StatType.TIMES )
end

local function Task_Update( task )
	local taskStep = task:GetStepType()
	if not taskStep then
		Task_End( task )
		return
	end

	if taskStep == TaskStep.PREPARE then
		Task_Prepare( task )
	elseif taskStep == TaskStep.EXECUTE then
		Task_Execute( task )
	elseif taskStep == TaskStep.FINISH then
		Task_Finish( task )
	elseif taskStep == TaskStep.REPLY then
		Task_Reply( task )
	end

	task:ElpasedTime( g_elapsed )
	
	--Task_Debug( task, "update" )

	if task:Update() == true then
		--Stat_Add( "Task@Update", task:ToString() .. " step=" .. MathUtil_FindName( TaskStep, taskStep ), StatType.LIST )		
		Task_Update( task )
		--Task_Debug( task, "update " .. task:ToString() )
	end
end


-------------------------------------------

local function Task_OnArriveDestination( msg )
	local actor = Asset_SetDictItem( msg, MessageAssetID.PARAMS, "actor" )
	--to do
end

local function Task_OnCombatTriggered( msg )	
	local combat = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "combat" )
	if not combat then return end

	local id = combat.id
	if not _combatTasks[id] then _combatTasks[id] = {} end

	local task   = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "task" )
	if not task then
		local atk = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "atk" )
		local def = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "def" )
		if atk then
			task = _interceptTasks[atk]
			if task then
				table.insert( _combatTasks[id], task )
			end
		end
		if def then
			task = _interceptTasks[def]
			if task then
				table.insert( _combatTasks[id], task )
			end
		end
	end
end

local function Task_OnCombatEnded( msg )
	local combat  = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "combat" )
	if not combat then return end

	local id = combat.id
	local taskList = _combatTasks[id]
	if not taskList or #taskList == 0 then return end	

	function CheckTask( task )
		local isTaskSuccess = false
		local taskType = Asset_Get( task, TaskAssetID.TYPE )

		Log_Write( "task",  "Combat End Checker" .. task:ToString() )

		local combatType = Asset_Get( combat, CombatAssetID.TYPE )
		if combatType == CombatType.SIEGE_COMBAT then
			if Asset_Get( combat, CombatAssetID.WINNER ) == CombatSide.ATTACKER then
				isTaskSuccess = true				
			end
		elseif combatType == CombatType.FIELD_COMBAT then
			if combat:GetGroup( Asset_Get( combat, CombatAssetID.WINNER ) ) == Asset_Get( task, TaskAssetID.GROUP ) then
				if taskType == TaskType.INTERCEPT or taskType == TaskType.HARASS_CITY then
					isTaskSuccess = true
				elseif taskType == TaskType.ATTACK_CITY then
					--resume to attack city
					Message_Post( MessageType.START_MOVING, { actor = Asset_Get( task, TaskAssetID.ACTOR ) } )
					return
				elseif taskType == TaskType.DISPATCH_CORPS then
					Task_Resume( task )
					return
				end
			end		
		end
		
		if isTaskSuccess == false then
			Task_Failed( task )
		else
			Task_Success( task )
		end
	end
	for _, task in ipairs( taskList ) do
		CheckTask( task )
	end
	_combatTasks[id] = nil
end

local function Task_OnCombatWin( msg )
	local combat = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "combat" )
	if not combat then return end
	local taskList = _combatTasks[combat.id]
	if not taskList or #taskList == 0 then return end

	local corps  = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "corps" )
	if not corps then return end
end

-------------------------------------------

TaskSystem = class()

function TaskSystem:__init()
	System_Setup( self, SystemType.TASK_SYS, "TASK" )
end

function TaskSystem:Start()
	Message_Handle( self.type, MessageType.ARRIVE_DESTINATION, Task_OnArriveDestination )
	Message_Handle( self.type, MessageType.COMBAT_TRIGGERRED,  Task_OnCombatTriggered )
	Message_Handle( self.type, MessageType.COMBAT_ENDED,       Task_OnCombatEnded )
	
	_prepareTask = MathUtil_ConvertKeyToID( TaskType, _prepareTask )
	_executeTask = MathUtil_ConvertKeyToID( TaskType, _executeTask )
	_finishTask  = MathUtil_ConvertKeyToID( TaskType, _finishTask )
	_workOnTask  = MathUtil_ConvertKeyToID( TaskType, _workOnTask )
end

function TaskSystem:Update()
	--print( "Task Running=" .. Entity_Number( EntityType.TASK ) )
	Entity_Foreach( EntityType.TASK, function( task )
		local ret = false
		while ret == false do
			ret = Task_Update( task )
		end
	end )
end