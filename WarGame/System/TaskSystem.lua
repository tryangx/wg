--
--
-- Command: Expand the task system easily
--
--
local _cmds = {}

local function Cmd_Execute( cmd )
	if cmd.params then
		if cmd.params.dur and cmd.params.dur > 0 then
			cmd.params.dur = cmd.params.dur - 1
		end
	end

	if cmd.type == "MOVE_TO_CITY" then
		--print( 'check', cmd.actor:ToString("LOCATION", cmd.city:ToString() ) )
		if Asset_Get( cmd.actor, CharaAssetID.LOCATION ) == cmd.city then
			--InputUtil_Pause( "finish cmd" )
		end

	end
end

function Cmd_MoveToCity( actor, city, params )
	local cmd = _cmds[actor]
	if cmd then
		DBG_Error( actor:ToString(), "has command" )
	end
	cmd = { type = "MOVE_TO_CITY", actor = actor, city = city, params = params }
	_cmds[actor] = cmd
end

function Cmd_Query( actor )
	return _cmds[actor]
end

function Cmd_Clear( actor )
	_cmds[actor] = nil
end

function Cmd_Update()
	local removeList = {}
	for _, cmd in pairs( _cmds ) do
		if Cmd_Execute( cmd ) then
			table.insert( removeList, cmd.actor )
		end
	end

	for _, actor in ipairs( removeList ) do
		_cmds[actor] = nil
	end
end

---------------------------------------------------
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

--key is combat, value is tasks what related to the combat
local _combatTasks = {}

local WorkType = 
{
	ACTOR     = 1 ,
	EXECUTION = 2,
}

---------------------------------------------------
-- Task Content Function

local function Task_Breakpoint( task, fn )
	if Asset_Get( task, TaskAssetID.TYPE ) == TaskType.HARASS_CITY then
		fn( task )
		InputUtil_Pause()
	end
end

local function Task_Debug( task, content )
	if task.id == 0 then
		DBG_TrackBug( task:ToString( "DEBUG" ) .. content )
		print( task:ToString( "DEBUG" ) .. content )
	end	
end

local function Task_GetBonus( task )
	local taskType = Asset_Get( task, TaskAssetID.TYPE )
	local datas = Scenario_GetData( "TASK_BONUS_DATA" )
	return datas[taskType]
end

local function Task_DoDefault( task )	
	local progress = Random_GetInt_Sync( 5, 10 )
	task:DoTask( progress )
	return Task_GetBonus( task, "work" )
end

function Task_Remove( task )
	--remove from actor
	local actor = Asset_Get( task, TaskAssetID.ACTOR )
	local actorType = Asset_Get( task, TaskAssetID.ACTOR_TYPE )
	if actorType == TaskActorType.CHARA then
		actor:SetTask( nil )
	elseif actorType == TaskActorType.CORPS then
		Task_CorpsReceive( actor )
	end

	local type = Asset_Get( task, TaskAssetID.TYPE )	
	if type == TaskType.ESTABLISH_CORPS then		
		local corps = Asset_GetDictItem( task, TaskAssetID.PARAMS, "corps" )
		Task_CorpsReceive( corps )
	end

	local plan = Asset_GetDictItem( task, TaskAssetID.PARAMS, "plan" )
	if plan then
		local city = Asset_Get( task, TaskAssetID.LOCATION )
		city:SetPlan( plan )
		--Log_Write( "task",  "remove plan", task:ToString( "PLAN" ) )
	end

	Debug_Log( "remove task" .. task:ToString() )

	Entity_Remove( task )

	--print( "end", task:ToString() )
end

local function Task_Resume( task )
	Task_Debug( task, "resume" )
	Asset_Set( task, TaskAssetID.STATUS, TaskStatus.MOVING )
	Move_Resume( Asset_Get( task, TaskAssetID.ACTOR ), 5 )
end

local function Task_Failed( task )
	Task_Debug( task, "task failed!!!!!" )

	Log_Write( "task", task:ToString("DEBUG") .. " Failed" )
	
	--should consider about whether to do next
	local actor = Asset_Get( task, TaskAssetID.ACTOR )
	Move_Suspend( actor )
	Log_Write( "move", "task failed=" .. actor:ToString() .. " taks=" .. task:ToString("DEBUG") )

	Asset_Set( task, TaskAssetID.RESULT, TaskResult.FAILED )
	task:Finish()

	local type = Asset_Get( task, TaskAssetID.TYPE )
	if type == TaskType.INTERCEPT then
		--InputUtil_Pause( "Intercept failed", task:ToString() )
	elseif type == TaskType.HARASS_CITY then
		--InputUtil_Pause( "Harass failed", task:ToString("DEBUG") )
	end

	Stat_Add( "Task@Failed", task:ToString(), StatType.LIST )
end

local function Task_Success( task )	
	Log_Write( "task",  task:ToString() .. " succeed!!!" )
	local actor = Asset_Get( task, TaskAssetID.ACTOR )
	Move_Suspend( actor )
	Log_Write( "move", "task suc=" .. actor:ToString() .. " taks=" .. task:ToString() )

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
	task:Finish()

	Stat_Add( "Task@Success", task:ToString( "END" ), StatType.LIST )

	--InputUtil_Pause( task:ToString(), "success" )
end

--debug
local function Task_Verify( task )
	local type = Asset_Get( task, TaskAssetID.TYPE )
	local group    = Asset_Get( task, TaskAssetID.GROUP )

	if type == TaskType.HARASS_CITY 
	or type == TaskType.ATTACK_CITY then
		local dest = Asset_Get( task, TaskAssetID.DESTINATION )
		local oppGroup = Asset_Get( dest, CityAssetID.GROUP )
		if group == oppGroup then
			Log_Write( "task", task:ToString() )
		end
	end

	--sanity checker
	if Asset_Get( task, TaskAssetID.ELPASED_DAYS ) - Asset_Get( task, TaskAssetID.COMBAT_DAYS ) > 400 then
		--print( "turn=" .. g_Time:ToString() )
		--print( Asset_Get( task, TaskAssetID.ELPASED_DAYS ), Asset_Get( task, TaskAssetID.COMBAT_DAYS ) )
		--print( task:GetStepType() )
		if not task:GetCombat() then
			local actor = Asset_Get( task, TaskAssetID.ACTOR )
			if Asset_Get( task, TaskAssetID.ACTOR_TYPE ) == TaskActorType.CORPS then
				print( actor:ToString("STATUS") )
				Entity_ToString( EntityType.MOVE )
				DBG_Error( task:ToString("DEBUG") .. " is bug" )
			end
		end

		--checker actor exist?
	end	
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

local function Task_GiveupWhenDestNotUs( task )
	local curGroup  = Asset_Get( task, TaskAssetID.GROUP )
	if not curGroup then
		error( "not belong to any group" )
		return false
	end
	
	local dest = Asset_Get( task, TaskAssetID.DESTINATION )
	if not dest then
		error( "not destination" )
		return false
	end

	local destGroup = Asset_Get( dest, CityAssetID.GROUP )
	if curGroup == destGroup then
		Task_Debug( task, "same group" .. curGroup.name )
		return false
	end

	Task_Failed( task )
	Log_Write( "task", "give up" .. task:ToString("DEBUG") )
end

local function Task_CombatMoving( task )
end

local _movingTask = 
{
	TRANSPORT      = Task_GiveupWhenDestNotUs,

	HARASS_CITY    = Task_CombatMoving,
	ATTACK_CITY    = Task_CombatMoving,
	INTERCEPT      = Task_CombatMoving,

	DISPATCH_CORPS = Task_GiveupWhenDestNotUs,
	DISPATCH_CHARA = Task_GiveupWhenDestNotUs,
}

local _prepareTask = 
{
	HARASS_CITY     = function ( task )
		local loc = Asset_Get( task, TaskAssetID.LOCATION )
		loc:AddStatus( CityStatus.WAR_WEARINESS, DAY_IN_SEASON )

		Intel_Post( IntelType.HARASS_CITY, Asset_Get( task, TaskAssetID.LOCATION ), { actor = Asset_Get( task, TaskAssetID.ACTOR ) } )
		Asset_Set( task, TaskAssetID.DURATION, 10 )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
	end,
	ATTACK_CITY     = function ( task )
		local loc = Asset_Get( task, TaskAssetID.LOCATION )
		loc:AddStatus( CityStatus.WAR_WEARINESS, DAY_IN_SEASON )

		Intel_Post( IntelType.ATTACK_CITY, loc, { actor = Asset_Get( task, TaskAssetID.ACTOR ) } )
		Asset_Set( task, TaskAssetID.DURATION, 10 )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )	
	end,
	INTERCEPT       = function ( task )
		Stat_Add( "Intercept@" .. Asset_Get( task, TaskAssetID.GROUP ).name, 1, StatType.TIMES )
		Asset_Set( task, TaskAssetID.DURATION, 10 )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
	end,
	DISPATCH_CORPS  = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, 10 )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
	end,

	ESTABLISH_CORPS = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, 20 )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
	end,
	REGROUP_CORPS   = function ( task )
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
			Task_Debug( task, city:ToString(), "is belong to", Asset_Get( corps, CorpsAssetID.GROUP ) )
			Task_Failed( task )
		else
			local defenders = city:GetDefendCorps()
			if #defenders ~= 0 then
				Corps_HarassCity( corps, city )
				Asset_Set( task, TaskAssetID.STATUS, TaskStatus.RUNNING )
			else
				--print( "no defender, should cancel?", task:ToString() )
				Asset_Set( task, TaskAssetID.WORKLOAD, 30 )
				Asset_Set( task, TaskAssetID.DURATION, 30 )
				Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
			end			
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
		if Asset_Get( task, TaskAssetID.STATUS ) == TaskStatus.WAITING then
			--reach the position, wait 30days
			Asset_Set( task, TaskAssetID.WORKLOAD, 30 )
			Asset_Set( task, TaskAssetID.DURATION, 30 )
			Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
		end		
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
		local leader = Asset_Get( task, TaskAssetID.ACTOR )
		local corps  = Corps_EstablishInCity( city, leader )
		Asset_SetDictItem( task, TaskAssetID.PARAMS, "corps", corps )
		corps:SetTask( task )

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
		local constr = Asset_GetDictItem( task, TaskAssetID.PARAMS, "construction" )
		Asset_Set( task, TaskAssetID.DURATION, constr.duration )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,
	LEVY_TAX      = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,
	BUY_FOOD      = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,
	SELL_FOOD     = function ( task )
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
		if dest:GetStatus( CityStatus.VIGILANT ) then
			workload = workload + 100
		end
		Asset_Set( task, TaskAssetID.WORKLOAD, workload )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,
	DESTROY_DEF = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, 80 )
		local workload = 250
		local dest = Asset_Get( task, TaskAssetID.DESTINATION )
		if dest:GetStatus( CityStatus.VIGILANT ) then
			workload = workload + 100
		end
		Asset_Set( task, TaskAssetID.WORKLOAD, workload )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,
	ASSASSINATE = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, 80 )
		local workload = 250
		local dest = Asset_Get( task, TaskAssetID.DESTINATION )
		if dest:GetStatus( CityStatus.VIGILANT ) then
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
	return Task_GetBonus( task, "work" )
end

--in WORKING status, task progress should increase by actor, 
--in some case, task can finish before duration is zero.
local _workOnTask = 
{
	INTERCEPT       = function( task, workType )
		if workType == WorkType.EXECUTION then
			Asset_Plus( task, TaskAssetID.PROGRESS, 1 )
		end
		return 0
	end,

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
			--Log_Write( "task",  "reinforce-corps=" .. corps:ToString() .. "+" .. number )			
			--DBG_TrackBug( "reinforce-corps=" .. corps:ToString() .. "+" .. number .. "/" .. reserves )
			Corps_ReinforceTroop( corps, number )
			reserves = reserves - number
			city:SetPopu( CityPopu.RESERVES, reserves )
			if reserves == 0 then
				Asset_Set( task, TaskAssetID.DURATION, 0 )
			else
				Asset_Set( task, TaskAssetID.PROGRESS, 0 )
			end
		end
		return Task_GetBonus( task, "work" )
	end,

	ENROLL_CORPS    = Task_DoDefault,	

	TRAIN_CORPS     = function ( task )
		local progress = Random_GetInt_Sync( 20, 30 )
		local corps    = Asset_GetDictItem( task, TaskAssetID.PARAMS, "corps" )
		local officer  = Asset_Get( corps, CorpsAssetID.LEADER )
		progress = math.ceil( progress * ( 100 + Chara_GetSkillEffectValue( officer, CharaSkillEffect.TRAINING_EFF_BONUS ) ) * 0.01 )
		task:DoTask( progress )
		local workload = Asset_Get( task, TaskAssetID.WORKLOAD )
		if Asset_Get( task, TaskAssetID.PROGRESS ) >= workload then
			Asset_Set( task, TaskAssetID.PROGRESS, 0 )
			local corps = Asset_GetDictItem( task, TaskAssetID.PARAMS, "corps" )						
			Corps_Train( corps, progress )			
			Corps_GainExp( corps, Chara_GetSkillEffectValue( officer, CharaSkillEffect.TRAINING_EFF_BONUS ) )
			return DEFAULT_TASK_CONTRIBUTION
		end
		return Task_GetBonus( task, "work" )
	end,
	CONSCRIPT       = Task_DoConvPopu,
	RECRUIT         = Task_DoConvPopu,
	HIRE_GUARD      = Task_DoConvPopu,

	DEV_AGRICULTURE = Task_DoDefault,
	DEV_COMMERCE    = Task_DoDefault,
	DEV_PRODUCTION  = Task_DoDefault,	
	BUILD_CITY      = Task_DoDefault,
	LEVY_TAX        = Task_DoDefault,
	BUY_FOOD        = Task_DoDefault,
	SELL_FOOD       = Task_DoDefault,

	HIRE_CHARA      = Task_DoDefault,

	RECONNOITRE     = function ( task )
		local intel = Random_GetInt_Sync( 15, 25 )
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		local loc  = Asset_Get( task, TaskAssetID.LOCATION )
		loc:Reconnoitre( city, intel )
		return Task_GetBonus( task, "work" )
	end,
	SABOTAGE        = function ( task )
		local progress = Random_GetInt_Sync( 2, 5 )
		task:DoTask( progress )
		return Task_GetBonus( task, "work" )
	end,
	DESTROY_DEF     = function ( task )
		local progress = Random_GetInt_Sync( 2, 5 )
		task:DoTask( progress )
		return Task_GetBonus( task, "work" )
	end,
	ASSASSINATE     = function ( task )
		local progress = Random_GetInt_Sync( 2, 5 )
		task:DoTask( progress )
		return Task_GetBonus( task, "work" )
	end,

	RESEARCH        = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, g_turnStep + 1 )
		local progress = Random_GetInt_Sync( 50, 250 )
		task:DoTask( progress )
		--InputUtil_Pause( "do", Asset_Get( task, TaskAssetID.PROGRESS ) )
		return Task_GetBonus( task, "work" )
	end,

	IMPROVE_RELATION = Task_DoDefault,
	SIGN_PACT        = Task_DoDefault,
}

local function Task_MoveChara( task )
	local actor = Asset_Get( task, TaskAssetID.ACTOR )
	
	--chara in corps, won't leave single
	if Asset_Get( actor, CharaAssetID.CORPS ) then
		print( task:ToString() )
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

	--print( actor:ToString(), "move to", dest:ToString() )

	Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
	return Task_GetBonus( task, "success" )
end

local _finishTask = 
{
	INTERCEPT       = function ( task )
		--failed
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return 0
	end,
	ESTABLISH_CORPS = function ( task )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_GetBonus( task, "success" )
	end,
	REINFORCE_CORPS = function ( task )
		local corps = Asset_Get( task, TaskAssetID.ACTOR )
		local loc   = Asset_Get( task, TaskAssetID.DESTINATION )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_GetBonus( task, "success" )
	end,
	ENROLL_CORPS    = function ( task )		
		local corps = Asset_Get( task, TaskAssetID.ACTOR )
		local city  = Asset_Get( task, TaskAssetID.DESTINATION )
		Corps_EnrollInCity( corps, city )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_GetBonus( task, "success" )
	end,	
	DISPATCH_CORPS  = function ( task )
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		local corps = Asset_GetDictItem( task, TaskAssetID.PARAMS, "corps" )
		Corps_Dispatch( corps, city )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_GetBonus( task, "success" )
	end,
	LEAD_CORPS      = function ( task )
		local corps = Asset_Get( task, TaskAssetID.ACTOR )
		local actor = Asset_GetDictItem( task, TaskAssetID.PARAMS, "leader" )		
		corps:AssignLeader( actor )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_GetBonus( task, "success" )
	end,
	REGROUP_CORPS   = function ( task )
		local list = Asset_GetDictItem( task, TaskAssetID.PARAMS, "corps_list" )
		local actor = Asset_Get( task, TaskAssetID.ACTOR )
		Corps_Regroup( actor, list )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_GetBonus( task, "success" )
	end,
	CONSCRIPT       = function ( task )
		--InputUtil_Pause( task:ToString(), "conscript=" .. Asset_GetDictItem( task, TaskAssetID.PARAMS, "number" ) )

		local loc = Asset_Get( task, TaskAssetID.DESTINATION )
		loc:SetStatus( CityStatus.RESERVE_UNDERSTAFFED )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_GetBonus( task, "success" )
	end,
	RECRUIT         = function ( task )
		local loc = Asset_Get( task, TaskAssetID.DESTINATION )
		loc:SetStatus( CityStatus.RESERVE_UNDERSTAFFED )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_GetBonus( task, "success" )
	end,
	HIRE_GUARD      = function ( task )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_GetBonus( task, "success" )
	end,

	DEV_AGRICULTURE = function( task )
		--InputUtil_Pause( "dev agri", Asset_Get( task, TaskAssetID.PROGRESS ))
		City_Develop( Asset_Get( task, TaskAssetID.DESTINATION ), Asset_Get( task, TaskAssetID.PROGRESS ), CityAssetID.AGRICULTURE, Asset_Get( task, TaskAssetID.ACTOR ) )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_GetBonus( task, "success" )
	end,
	DEV_COMMERCE = function( task )
		City_Develop( Asset_Get( task, TaskAssetID.DESTINATION ), Asset_Get( task, TaskAssetID.PROGRESS ), CityAssetID.COMMERCE, Asset_Get( task, TaskAssetID.ACTOR ) )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_GetBonus( task, "success" )
	end,
	DEV_PRODUCTION = function( task )
		City_Develop( Asset_Get( task, TaskAssetID.DESTINATION ), Asset_Get( task, TaskAssetID.PROGRESS ), CityAssetID.PRODUCTION, Asset_Get( task, TaskAssetID.ACTOR ) )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_GetBonus( task, "success" )
	end,
	BUILD_CITY      = function ( task )
		City_Build( Asset_Get( task, TaskAssetID.DESTINATION ), Asset_GetDictItem( task, TaskAssetID.PARAMS, "construction" ) )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_GetBonus( task, "success" )
	end,
	LEVY_TAX      = function ( task )
		City_LevyTax( Asset_Get( task, TaskAssetID.DESTINATION ), Asset_Get( task, TaskAssetID.PROGRESS ) )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_GetBonus( task, "success" )
	end,
	BUY_FOOD      = function ( task )
		City_BuyFood( Asset_Get( task, TaskAssetID.DESTINATION ), Asset_Get( task, TaskAssetID.PROGRESS ) )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_GetBonus( task, "success" )
	end,
	SELL_FOOD     = function ( task )
		City_SellFood( Asset_Get( task, TaskAssetID.DESTINATION ), Asset_Get( task, TaskAssetID.PROGRESS ) )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_GetBonus( task, "success" )
	end,
	TRANSPORT     = function ( task )
		local food  = Asset_GetDictItem( task, TaskAssetID.PARAMS, "food" )
		local mat   = Asset_GetDictItem( task, TaskAssetID.PARAMS, "material" )
		local money = Asset_GetDictItem( task, TaskAssetID.PARAMS, "money" )
		local dest  = Asset_Get( task, TaskAssetID.DESTINATION )
		--print( dest:ToString( "SUPPLY" ) )
		dest:ReceiveFood( food )
		Asset_Plus( dest, CityAssetID.MATERIAL, mat )
		Asset_Plus( dest, CityAssetID.MONEY, money )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		--InputUtil_Pause( dest:ToString( "SUPPLY" ) )
		Stat_Add( "Transport@FOOD", food, StatType.ACCUMULATION )
		Stat_Add( "Transport@MONEY", money, StatType.ACCUMULATION )
		Stat_Add( "Transport@MATERIAL", mat, StatType.ACCUMULATION )
		
		return Task_GetBonus( task, "success" )
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
			return Task_GetBonus( task, "success" )
		else
			Report_Feedback( task:ToString( "SIMPLE" ) .. " FAILED" )
			Asset_Set( task, TaskAssetID.RESULT, TaskResult.FAILED )
			Stat_Add( "Hire@Failed", 1, StatType.TIMES )
			return Task_GetBonus( task, "failed" )
		end
	end,
	PROMOTE_CHARA = function ( task )
		local actor = Asset_Get( task, TaskAssetID.ACTOR )
		local title = Asset_GetDictItem( task, TaskAssetID.PARAMS, "title" )
		actor:PromoteTitle( title )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_GetBonus( task, "success" )
	end,
	DISPATCH_CHARA  = Task_MoveChara,
	
	RECONNOITRE = function ( task )		
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_GetBonus( task, "success" )
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
			return Task_GetBonus( task, "success" )
		else
			Asset_Set( task, TaskAssetID.RESULT, TaskResult.FAILED )
			Stat_Add( "OP@Failed", 1, StatType.TIMES )
			return Task_GetBonus( task, "failed" )
		end
	end,
	DESTROY_DEF = function ( task )
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		local loc  = Asset_Get( task, TaskAssetID.LOCATION )
		local spy  = loc:GetSpy( city )
		local progress = Asset_Get( task, TaskAssetID.PROGRESS )		
		local workload = Asset_Get( task, TaskAssetID.WORKLOAD )
		progress = progress + CitySpyParams.GRADE_OP_BONUS[spy.grade]		
		if progress >= workload then
			city:DestroyDefensive()
			loc:LoseSpy( city, 1 )
			Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
			Stat_Add( "OP@Suc", 1, StatType.TIMES )
			return Task_GetBonus( task, "success" )
		else
			Asset_Set( task, TaskAssetID.RESULT, TaskResult.FAILED )
			Stat_Add( "OP@Failed", 1, StatType.TIMES )
			return Task_GetBonus( task, "failed" )
		end
	end,
	ASSASSINATE = function ( task )
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		local loc  = Asset_Get( task, TaskAssetID.LOCATION )
		local spy  = loc:GetSpy( city )
		local progress = Asset_Get( task, TaskAssetID.PROGRESS )		
		local workload = Asset_Get( task, TaskAssetID.WORKLOAD )
		progress = progress + CitySpyParams.GRADE_OP_BONUS[spy.grade]
		if progress >= workload then
			local target = Asset_GetDictItem( task, TaskAssetID.PARAMS, "chara" )
			local actor = Asset_Get( task, TaskAssetID.ACTOR )
			city:Assassinate( target, actor )
			loc:LoseSpy( city, 1 )
			Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
			Stat_Add( "OP@Suc", 1, StatType.TIMES )
			return Task_GetBonus( task, "success" )
		else
			Asset_Set( task, TaskAssetID.RESULT, TaskResult.FAILED )
			Stat_Add( "OP@Failed", 1, StatType.TIMES )
			return Task_GetBonus( task, "failed" )
		end
	end,


	RESEARCH  = function ( task )
		local group = Asset_Get( task, TaskAssetID.GROUP )
		local tech  = Asset_GetDictItem( task, TaskAssetID.PARAMS, "tech" )
		group:MasterTech( tech )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		return Task_GetBonus( task, "success" )
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
			return Task_GetBonus( task, "success" )
		else
			Asset_Set( task, TaskAssetID.RESULT, TaskResult.FAILED )
			return Task_GetBonus( task, "failed" )
		end
	end,
	DECLARE_WAR      = function ( task )
		local group = Asset_Get( task, TaskAssetID.GROUP )
		local oppGroup = Asset_GetDictItem( task, TaskAssetID.PARAMS, "group" )
		Dipl_DeclareWar( group, oppGroup )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		Stat_Add( "Dipl@DeclareWar", g_Time:CreateCurrentDateDesc() .. " " .. group:ToString() .. "-->" .. oppGroup:ToString(), StatType.LIST )
		return Task_GetBonus( task, "success" )
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
			return Task_GetBonus( task, "success" )
		else
			Asset_Set( task, TaskAssetID.RESULT, TaskResult.FAILED )
			return Task_GetBonus( task, "failed" )
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

local function Task_BackHome( task )	
	if Move_IsMoving( Asset_Get( task, TaskAssetID.ACTOR ) ) == false then
		Stat_Add( "Task@BackHome", 1, StatType.TIMES )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.MOVING )

		local actor     = Asset_Get( task, TaskAssetID.ACTOR )
		local actorType = Asset_Get( task, TaskAssetID.ACTOR_TYPE )
		if actorType == TaskActorType.CHARA then
			local home = Asset_Get( actor, CharaAssetID.HOME )
			if not home then
				print( task:ToString() )
				Debug_Log( "no home" .. task.id )
			else
				Move_Chara( actor, home )
			end			

		elseif actorType == TaskActorType.CORPS then
			local loc = Asset_Get( actor, CorpsAssetID.LOCATION )
			local dest = Asset_Get( actor, CorpsAssetID.ENCAMPMENT )			
			if dest then
				if dest ~= loc then
					Task_Debug( task, "back loc=" .. loc.name .. " dest=" .. dest.name )
					Log_Write( "task", task:ToString() .. " back home=" .. String_ToStr( dest, "name" ) )
					Move_Corps( actor, dest )
					return
				end
			else
				dest = Asset_Get( task, TaskAssetID.LOCATION )
				if loc ~= dest then
					--back to location where start the task
					Task_Debug( task, "back loc=" .. loc.name .. " dest=" .. dest.name )
					Log_Write( "task", task:ToString() .. " back home=" .. String_ToStr( dest, "name" ) )
					Move_Corps( actor, dest )
					return
				end
			end
			--whether actor is outside and in-move, to modify movesystem let it can goback home			
			Move_Corps( actor, dest )
			--[[
			print( "debug this")
			Entity_ToString( EntityType.MOVE )
			print( actor:ToString("STATUS"))
			error("")
			]]
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

		Task_Debug( task, "move2dest" )
		if actorType == TaskActorType.CHARA then
			Log_Write( "task", task:ToString() .. " move to dest=" .. String_ToStr( loc, "name" ) )
			Move_Chara( actor, loc )
		elseif actorType == TaskActorType.CORPS then
			Log_Write( "task", task:ToString() .. " move to dest=" .. String_ToStr( loc, "name" ) )
			Move_Corps( actor, loc )
			Supply_CorpsCarryFood( actor, loc )
		end
	end
end

local function Task_IsBackHome( task )
	--default go back home
	if Task_IsAtHome( task ) == false then
		if Asset_Get( task, TaskAssetID.STATUS ) ~= TaskStatus.MOVING then
			Task_BackHome( task )
		else
			--[[
			--sanity checker
			if not Move_HasMoving( Asset_Get( task, TaskAssetID.ACTOR ) ) then
				Entity_ToString( EntityType.MOVE )
				print( Asset_Get( task, TaskAssetID.ACTOR ):ToString("LOCATION") )
				DBG_Error( "why here", g_Time:ToString(), task:ToString() )
			end
			]]
		end
		return false
	else
		if Asset_Get( task, TaskAssetID.STATUS ) == TaskStatus.MOVING then
			Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
		end
	end
	return true
end

local function Task_End( task )
	if not Task_IsBackHome( task ) then
		--[[
		local actor = Asset_Get( task, TaskAssetID.ACTOR )
		print( actor:ToString("LOCATION") )
		error( task:ToString() .. " actor not at home" )
		]]
		--Task_BackHome( task )		
		return
	end

	Asset_Set( task, TaskAssetID.END_TIME, g_Time:GetDateValue() )

	if Asset_Get( task, TaskAssetID.STATUS ) == TaskStatus.END then
		--error( "why")
	end

	Asset_Set( task, TaskAssetID.STATUS, TaskStatus.END )
	
	local type = Asset_Get( task, TaskAssetID.TYPE )
	Stat_Add( "TaskEnd@" .. MathUtil_FindName( TaskType, type ), 1, StatType.VALUE )
	Log_Write( "task",  task:ToString() .. "end task" )
	
	--Log_Write( "meeting", g_Time:ToString() .. task:ToString() .. " end" )
	Task_Remove( task )

	return true
end

---------------------------------------------------

function Task_CityReceive( task, city )
	local plan = Asset_GetDictItem( task, TaskAssetID.PARAMS, "plan" )
	if not plan then return end
	
	local city = Asset_Get( task, TaskAssetID.LOCATION )
	city:SetPlan( plan, task )
end

function Task_CharaReceive( chara, task )
	if chara:IsBusy() then
		print( task:ToString() )
		error( chara:ToString() .. " has task " .. chara:GetTask():ToString() )
	end

	chara:SetTask( task )
end

function Task_CorpsReceive( corps, task )	
	if task and corps:IsBusy() then
		print( task:ToString() )
		error( corps:ToString() .. "already has task" )
	end

	if task then
		local actor = Asset_Get( task, TaskAssetID.ACTOR )
		if actor ~= corps then
			--attack city may include lots corps
			--error( "why" )
		end
	end

	corps:SetTask( task )

	Log_Write( "task",  corps:ToString(), "recv task" )
end

--actor was removed or captured
function Task_Terminate( task, requestor )
	if not task then return end
	--sanity checker
	local actor = Asset_Get( task, TaskAssetID.ACTOR )
	if actor ~= requestor then
		Debug_Log( "!!!!" .. ( requestor and requestor:ToString() or "" ) .. " isn't actor=" .. actor:ToString() .. " for task=" .. task:ToString() )
		--only remove requestor's task
		requestor:SetTask()
		--InputUtil_Pause( requestor:ToString("STATUS") )
		return
	end

	Task_Remove( task )

	Log_Write( "task", "Terminate task=" .. task:ToString() )
	--Debug_Log( task, "task terminate by=" .. requestor:ToString() )
	Stat_Add( "Task@Terminate", task:ToString("DETAIL"), StatType.LIST )
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

	Task_CityReceive( task, location )

	--need CORPS
	if type == TaskType.LEAD_CORPS then
		Asset_Set( task, TaskAssetID.ACTOR_TYPE, TaskActorType.CORPS )
		Task_CorpsReceive( actor, task )

		local leader = Asset_GetDictItem( task, TaskAssetID.PARAMS, "leader" )
		Task_CharaReceive( leader, task )

	elseif type == TaskType.REGROUP_CORPS then
		Asset_Set( task, TaskAssetID.ACTOR_TYPE, TaskActorType.CORPS )		
		local list = Asset_GetDictItem( task, TaskAssetID.PARAMS, "corps_list" )
		for _, corps in ipairs( list ) do
			Task_CorpsReceive( corps, task )
		end

	elseif type == TaskType.HARASS_CITY 
		or type == TaskType.ATTACK_CITY then
		Asset_Set( task, TaskAssetID.ACTOR_TYPE, TaskActorType.CORPS )
		Task_CorpsReceive( actor, task )

	elseif type == TaskType.INTERCEPT
		or type == TaskType.DISPATCH_CORPS

		or type == TaskType.REINFORCE_CORPS
		or type == TaskType.DISMISS_CORPS 
		or type == TaskType.TRAIN_CORPS
		or type == TaskType.ENROLL_CORPS
		or type == TaskType.UPGRADE_CORPS		
		then
		Asset_Set( task, TaskAssetID.ACTOR_TYPE, TaskActorType.CORPS )		
		Task_CorpsReceive( actor, task )

	--need CHARA
	elseif type == TaskType.HIRE_CHARA
		or type == TaskType.PROMOTE_CHARA
		or type == TaskType.DISPATCH_CHARA
		or type == TaskType.MOVE_CAPITAL

		or type == TaskType.ESTABLISH_CORPS

		or type == TaskType.DEV_AGRICULTURE
		or type == TaskType.DEV_COMMERCE
		or type == TaskType.DEV_PRODUCTION
		or type == TaskType.BUILD_CITY
		or type == TaskType.LEVY_TAX
		or type == TaskType.BUY_FOOD
		or type == TaskType.SELL_FOOD
		or type == TaskType.TRANSPORT

		or type == TaskType.CONSCRIPT
		or type == TaskType.RECRUIT
		or type == TaskType.HIRE_GUARD		
 
 		or type == TaskType.IMPROVE_RELATION
		or type == TaskType.DECLARE_WAR
		or type == TaskType.SIGN_PACT

		or type == TaskType.RECONNOITRE
		or type == TaskType.SABOTAGE
		or type == TaskType.DESTROY_DEF
		or type == TaskType.ASSASSINATE

		or type == TaskType.RESEARCH
		then
		Asset_Set( task, TaskAssetID.ACTOR_TYPE, TaskActorType.CHARA )
		Task_CharaReceive( actor, task )

	else
		error( "Should deal with this type=" .. MathUtil_FindName( TaskType, type ) .. "/" .. type )
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

	return task
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
			--print( corps:ToString() .. "atk")
			return Task_Create( taskType, corps, loc, dest, params )
		end
	else
		return Task_Create( taskType, actor, loc, dest, params )
	end
end

local function Task_Reply( task )
	Task_Debug( task, "in reply progress--" .. ( Task_IsAtHome( task ) and "at home" or "outside" ) )

	if not Task_IsBackHome( task ) then		
		return
	end
	
	--Task_Breakpoint( task, function() print( "reply", task:ToString("DEBUG") ) end )

	--bonus to contributor
	if Asset_Get( task, TaskAssetID.ACTOR_TYPE ) == TaskActorType.CHARA then
		Asset_Foreach( task, TaskAssetID.CONTRIBUTORS, function( data )
			--local type = Asset_Get( task, TaskAssetID.TYPE )
			--if type == TaskType.LEAD_CORPS then print( actor.name, "contribute", value, task:ToString() ) end			
			local bonus = Task_GetBonus( task )
			data.actor:AffectExp( CharaStatus.MILITARY_EXP, bonus.mil_exp )
			data.actor:AffectExp( CharaStatus.OFFICER_EXP, bonus.off_exp )
			data.actor:AffectExp( CharaStatus.DIPLOMAT_EXP, bonus.dip_exp )
			data.actor:Contribute( data.value )
		end )
	else
		--todo
	end

	Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )

	Stat_Add( "Task@Reply", 1, StatType.TIMES )

	Task_Debug( task, "reply finished" )

	Log_Write( "task", task:ToString() .. " replied" )
end

local function Task_Finish( task )	
	--can execute the task
	local contribution
	local fn = _finishTask[Asset_Get( task, TaskAssetID.TYPE )]
	if fn then
		bonus = fn( task )
	else
		--default set status to WAITING, in order to go next step
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
	end

	if bonus then
		local result = Asset_Get( task, TaskAssetID.RESULT )
		if result == TaskResult.SUCCESS then
			task:Contribute( Asset_Get( task, TaskAssetID.ACTOR ), bonus["success"] )
		elseif result == TaskResult.FAILED then
			task:Contribute( Asset_Get( task, TaskAssetID.ACTOR ), bonus["failed"] )
		end
	end

	--Stat_Add( "Task@Finish", task:ToString(), StatType.LIST )
end

function Task_Do( task, actor )
	local type = Asset_Get( task, TaskAssetID.TYPE )
	if type == TaskType.HARASS_CITY or type == TaskType.ATTACK_CITY then
		return
	end

	if Asset_Get( task, TaskAssetID.STATUS ) ~= TaskStatus.WORKING then
		return
	end

	if Asset_Get( task, TaskAssetID.DURATION ) <= 0 then
	end

	local contribution
	local fn = _workOnTask[Asset_Get( task, TaskAssetID.TYPE )]	
	if fn then
		bonus = fn( task, actor and WorkType.ACTOR or WorkType.EXECUTION )
	else
		error( "no work function for working status, " .. MathUtil_FindName( TaskType, type ) )
	end

	if bonus then
		task:Contribute( Asset_Get( task, TaskAssetID.ACTOR ), bonus["work"] )
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
			Task_Debug( task, "WAITING " .. task:ToString() )
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

--core function
function Task_Update( task )	
	--in combat
	if task:GetCombat() then
		return
	end

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
		Task_Debug( task, "next step" .. task:ToString() )
		--Stat_Add( "Task@Update", task:ToString() .. " step=" .. MathUtil_FindName( TaskStep, taskStep ), StatType.LIST )		
		Task_Update( task )
	end
end


-------------------------------------------

local function Task_OnArriveDestination( msg )
	local actor = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "actor" )
	--to do
end

local function Task_OnMoveBlocked( msg )
	--cancel task
	local corps = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "actor" )
	local task = corps:GetTask()
	if not task then
		DBG_Error( "why here?", corps:ToString() )
		return		
	end
	InputUtil_Pause( corps:ToString(), "task moving blocked by", task:ToString() )
	Task_Failed( task )
end

--occur like
--1. city already occupied by the attack-city corps
local function Task_OnCombatUntrigger( msg )
	local corps = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "corps" )
	if not corps then
		DBG_Error( "why no corps" )
		return
	end
	local task = corps:GetTask()
	if not task then
		DBG_Error( "why no task" )
		return
	end	
	local taskType = Asset_Get( task, TaskAssetID.TYPE )
	if taskType == TaskType.INTERCEPT or taskType == TaskType.HARASS_CITY or taskType == TaskType.ATTACK_CITY then
		Task_Failed( task )
	else
		DBG_Error( "why goto here" )
	end
end

local function Task_OnCombatTriggered( msg )	
	local combat = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "combat" )
	if not combat then error( "invalid combat?" ) return end

	local id = combat.id
	if not _combatTasks[id] then _combatTasks[id] = {} end

	function CheckTask( actor )
		local task = actor:GetTask()
		if not task then
			Debug_Log( "why corps no task?", actor:ToString() )
			return
		end

		if MathUtil_IndexOf( _combatTasks[id], task ) then
			if task:GetCombat() and combat.id ~= task:GetCombat() then
				error( "trigger=" .. combat.id .. " combat_exist" .. task:ToString() .. actor:ToString() )
			end
		end

		table.insert( _combatTasks[id], task )
		
		Task_Debug( task, "!!!!trigger combat=" .. combat:ToString("DEBUG_CORPS") )
		Log_Write( "task", "trigger combat? actor=" .. actor:ToString("STATUS") .. " " .. combat:ToString("DEBUG_CORPS") .. " " .. task:ToString() )
	end

	function CheckCorps( target )
		if not target then return end

		if typeof( target ) == "table" then
			for _, single in ipairs( target ) do
				CheckTask( single )
			end
		else
			CheckTask( target )
		end
	end
	
	CheckCorps( Asset_GetDictItem( msg, MessageAssetID.PARAMS, "atk" ) )
	CheckCorps( Asset_GetDictItem( msg, MessageAssetID.PARAMS, "def" ) )
end

local function Task_OnCombatInterrupted( msg )
	local combat = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "combat" )
	if not combat then error( "invalid combat?" ) return end

	local id = combat.id
		local taskList = _combatTasks[id]
	if not taskList or #taskList == 0 then
		DBG_Error( "why here")
		return
	end
	
	InputUtil_Pause( "inte task" )

	for _, task in ipairs( taskList ) do
		
	end
end

local function Task_OnCombatEnded( msg )
	local combat  = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "combat" )
	if not combat then
		return
	end

	local id = combat.id
	local taskList = _combatTasks[id]
	if not taskList or #taskList == 0 then return end	

	function CheckTask( task )		
		local taskType = Asset_Get( task, TaskAssetID.TYPE )

		--print( "combat end task", task:ToString() )

		if Asset_Get( task, TaskAssetID.RESULT ) ~= TaskResult.UNKNOWN then
			--DBG_TrackBug( task:ToString("SIMPLE") .. " has result" )
			return
		end

		Log_Write( "task",  "CombatEnd=" .. combat.id .. " Check task=" .. task:ToString() )
		Log_Write( "move",  "CombatEnd=" .. combat.id .. " Check task=" .. task:ToString() )

		local isTaskSuccess = false		

		local combatType = Asset_Get( combat, CombatAssetID.TYPE )
		if combatType == CombatType.SIEGE_COMBAT then
			if Asset_Get( combat, CombatAssetID.WINNER ) == CombatSide.ATTACKER then
				isTaskSuccess = true
			end

		elseif combatType == CombatType.FIELD_COMBAT then
			if combat:GetGroup( Asset_Get( combat, CombatAssetID.WINNER ) ) == Asset_Get( task, TaskAssetID.GROUP ) then
				if taskType == TaskType.INTERCEPT or taskType == TaskType.HARASS_CITY then
					local status = Asset_Get( task, TaskAssetID.STATUS )
					if status == TaskStatus.MOVING then
						Task_Debug( task, "should move to the destination" .. task:ToString() )
					end
					isTaskSuccess = true

				elseif taskType == TaskType.ATTACK_CITY or taskType == TaskType.DISPATCH_CORPS then
					--resume to attack city
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
		--print( "relatedcombat=" .. combat.id, task:ToString() )
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
	Message_Handle( self.type, MessageType.ARRIVE_DESTINATION,        Task_OnArriveDestination )
	Message_Handle( self.type, MessageType.MOVE_IS_BLOCKED,           Task_OnMoveBlocked )	
	Message_Handle( self.type, MessageType.COMBAT_TRIGGERRED_NOTIFY,  Task_OnCombatTriggered )
	Message_Handle( self.type, MessageType.COMBAT_UNTRIGGER_NOTIFY,   Task_OnCombatUntrigger )
	Message_Handle( self.type, MessageType.COMBAT_ENDED,              Task_OnCombatEnded )
	
	_prepareTask = MathUtil_ConvertKeyToID( TaskType, _prepareTask )
	_executeTask = MathUtil_ConvertKeyToID( TaskType, _executeTask )
	_finishTask  = MathUtil_ConvertKeyToID( TaskType, _finishTask )
	_workOnTask  = MathUtil_ConvertKeyToID( TaskType, _workOnTask )
	_movingTask  = MathUtil_ConvertKeyToID( TaskType, _movingTask )

	for name, type in pairs( TaskType ) do
		Stat_Add( "TaskEnd@" .. name, 0, StatType.VALUE )
	end	
end

function TaskSystem:Update()
	Cmd_Update()

	Entity_Foreach( EntityType.TASK, function ( t )
		local actor = Asset_Get( t, TaskAssetID.ACTOR )
		if not actor:GetTask() then
			print( t:ToString() )
			DBG_Error( actor:ToString(), actor.id, "should has task" )
		end
		--[[
		if Asset_Get( t, TaskAssetID.ACTOR ) == actor and t.id ~= task.id then
			print( actor:ToString("TASK") )
			print( t:ToString() )
			print( task:ToString() )
			DBG_Error( actor:ToString() )
		end
		]]
	end)

	--Debug_Log( "Task Running=" .. Entity_Number( EntityType.TASK ) )	
	if 1 then return end
	Entity_Foreach( EntityType.TASK, function( task )
		local ret = false
		while ret == false do
			ret = Task_Update( task )
		end

		Task_Verify( task )
	end )
end