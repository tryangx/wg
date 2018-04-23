local DEFAULT_TASK_INIT_DURATION = 0

local DEFAULT_TASK_DURATION      = 25

local DEFAULT_TASK_CONTRIBUTION  = 10

local _removeTask

local _moveWatcher = {}

local _combatTasks = {}

local _interceptTasks = {}

---------------------------------------------------
-- Task Content Function
local function Task_Debug( task, content )
	local group = Asset_Get( task, TaskAssetID.GROUP )
	if group.id == 2 then return end
	local type = Asset_Get( task, TaskAssetID.TYPE )
	--if type == TaskType.HARASS_CITY or type == TaskType.ATTACK_CITY then
	--if type == TaskType.DISPATCH_CHARA or type == TaskType.CALL_CHARA then
	if type == TaskType.HIRE_CHARA then
		--Debug_Log( task:ToString( "DEBUG_UPDATE" ), content )
		--InputUtil_Pause( task:ToString() )
	end
end

local function Task_DoDefault( task )	
	local progress = Random_GetInt_Sync( 5, 10 )
	task:DoTask( progress )
	return DEFAULT_TASK_CONTRIBUTION
end

local function Task_Failed( task )
	Message_Post( MessageType.STOP_MOVING, { actor = Asset_Get( task, TaskAssetID.ACTOR ) } )

	Asset_Set( task, TaskAssetID.RESULT, TaskResult.FAILED )
	task:FinishStep()
	task:Update()

	local type = Asset_Get( task, TaskAssetID.TYPE )
	if type == TaskType.INTERCEPT then
		--InputUtil_Pause( "Intercept failed", task:ToString() )
	elseif type == TaskType.HARASS_CITY then
		--InputUtil_Pause( "Harass failed", task:ToString() )
	end

	Stat_Add( "Task@Failed", 1, StatType.TIMES )
end

local function Task_Success( task )	
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
		InputUtil_Pause( "Intercept suc")
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
		if Supply_CorpsCarryFood( corps, city ) == false then
			--cancel task
			Asset_Set( task, TaskAssetID.DURATION, 0 )
			return true
		end
	end
end

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

	DISPATCH_CHARA  = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, 5 )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
	end,
	CALL_CHARA      = function ( task )
		local dur = Move_CalcIntelTransDuration( Asset_Get( task, TaskAssetID.GROUP ), Asset_Get( task, TaskAssetID.LOCATION ), Asset_Get( task, TaskAssetID.DESTINATION ) )
		Asset_Set( task, TaskAssetID.DURATION, dur )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
	end
}

--return valid means not to set finished status
local _executeTask = 
{
	HARASS_CITY     = function ( task )
		if Asset_Get( task, TaskAssetID.STATUS ) == TaskStatus.RUNNING then return end		
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
		if Asset_Get( task, TaskAssetID.STATUS ) == TaskStatus.RUNNING then return end
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		local corps = Asset_Get( task, TaskAssetID.ACTOR )
		Corps_AttackCity( corps, city )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.RUNNING )
	end,
	INTERCEPT       = function ( task )
		if Asset_Get( task, TaskAssetID.STATUS ) == TaskStatus.WAITING then return end		
		Asset_Set( task, TaskAssetID.DURATION, 60 )
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

	ESTABLISH_CORPS = function ( task )
		local leader = Asset_GetListItem( task, TaskAssetID.PARAMS, "leader" )
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		local corps = Corps_EstablishInCity( city, leader )
		if leader then
			Asset_SetListItem( leader, CharaAssetID.STATUSES, CharaStatus.IN_TASK, true )
		end
		Asset_SetListItem( task, TaskAssetID.PARAMS, "corps", corps )
		Asset_SetListItem( corps, CorpsAssetID.STATUSES, CorpsStatus.IN_TASK, true )
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
	DISPATCH_CORPS  = function ( task )
		if Asset_Get( task, TaskAssetID.STATUS ) == TaskStatus.WAITING then return end
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		local corps = Asset_GetListItem( task, TaskAssetID.PARAMS, "corps" )
		Corps_Dispatch( corps, city )
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

	HIRE_CHARA = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, 15 )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WORKING )
	end,
}

local function Task_DoConvReserves( task )
	local type = Asset_Get( task, TaskAssetID.TYPE )
	local params
	if type == TaskType.CONSCRIPT then
		params = Scenario_GetData( "CITY_CONSCRIPT_PARAMS" )
	elseif type == TaskType.RECRUIT then
		params = Scenario_GetData( "CITY_RECRUIT_PARAMS" )
	end
	local progress = Random_GetInt_Sync( 15, 35 )
	task:DoTask( progress )
	local workload = Asset_Get( task, TaskAssetID.WORKLOAD )	
	if Asset_Get( task, TaskAssetID.PROGRESS ) >= workload then		
		--InputUtil_Pause( task.id, Asset_Get( task, TaskAssetID.PROGRESS ) , workload )
		local number = City_ConvReserves( Asset_Get( task, TaskAssetID.DESTINATION ), params )				
		Asset_Set( task, TaskAssetID.PROGRESS, 0 )

		if type == TaskType.CONSCRIPT then
			Stat_Add( "Conscript@Num", number, StatType.ACCUMULATION )			
		elseif type == TaskType.RECRUIT then
			Stat_Add( "Recruit@Num",   number, StatType.ACCUMULATION )
		end
		local old = Asset_GetListItem( task, TaskAssetID.PARAMS, "number" )
		if not old then old = 0 end
		Asset_SetListItem( task, TaskAssetID.PARAMS, "number", old + number )
	end		
	return DEFAULT_TASK_CONTRIBUTION
end

local _doTask = 
{
	ESTABLISH_CORPS = Task_DoDefault,
	REINFORCE_CORPS = function( task )
		local progress = Random_GetInt_Sync( 10, 35 )
		task:DoTask( progress )
		local workload = Asset_Get( task, TaskAssetID.WORKLOAD )
		if Asset_Get( task, TaskAssetID.PROGRESS ) >= workload then
			local city    = Asset_Get( task, TaskAssetID.DESTINATION )
			local soldier = Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.RESERVES )
			local number  = soldier < workload and soldier or workload
			local corps   = Asset_GetListItem( task, TaskAssetID.PARAMS, "corps" )
			--Debug_Log( "reinforce", corps:ToString(), "+" .. number )
			Corps_ReinforceTroop( corps, number )
			soldier = soldier - number
			Asset_SetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.RESERVES, soldier )
			if soldier == 0 then
				Asset_Set( task, TaskAssetID.DURATION, 0 )
			else
				Asset_Set( task, TaskAssetID.PROGRESS, 0 )
			end
		end		
		return DEFAULT_TASK_CONTRIBUTION
	end,
	ENROLL_CORPS    = Task_DoDefault,	
	TRAIN_CORPS     = function ( task )
		local progress = Random_GetInt_Sync( 10, 35 )
		task:DoTask( progress )
		local workload = Asset_Get( task, TaskAssetID.WORKLOAD )
		if Asset_Get( task, TaskAssetID.PROGRESS ) >= workload then
			local corps = Asset_GetListItem( task, TaskAssetID.PARAMS, "corps" )
			Corps_Train( corps, 1 )
			Asset_Set( task, TaskAssetID.PROGRESS, 0 )
			return DEFAULT_TASK_CONTRIBUTION
		end
		return 0
	end,
	CONSCRIPT       = Task_DoConvReserves,
	RECRUIT         = Task_DoConvReserves,

	DEV_AGRICULTURE = Task_DoDefault,
	DEV_COMMERCE    = Task_DoDefault,
	DEV_PRODUCTION  = Task_DoDefault,	
	BUILD_CITY      = Task_DoDefault,
	LEVY_TAX        = Task_DoDefault,

	HIRE_CHARA      = Task_DoDefault,
}

local function Task_MoveChara( task )
	local actor = Asset_Get( task, TaskAssetID.ACTOR )
	local home = Asset_Get( actor, CharaAssetID.HOME )
	if home then
		home:CharaLeave( actor )
	end
	local dest = Asset_Get( task, TaskAssetID.DESTINATION )
	if dest then
		dest:CharaJoin( actor )
	end
	Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
end

local _finishTask = 
{
	ESTABLISH_CORPS = function ( task )
		local corps = Asset_GetListItem( task, TaskAssetID.PARAMS, "corps" )
		local leader = Asset_Get( corps, CorpsAssetID.LEADER )
		Asset_SetListItem( leader, CharaAssetID.STATUSES, CharaStatus.IN_TASK, nil )
		Asset_SetListItem( corps, CorpsAssetID.STATUSES, CorpsStatus.IN_TASK, nil )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
		Debug_Normal( corps:ToString(), Asset_Get( task, TaskAssetID.LOCATION ):ToString() )
	end,
	REINFORCE_CORPS = function ( task )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
	end,
	ENROLL_CORPS    = function ( task )		
		local corps = Asset_Get( task, TaskAssetID.ACTOR )
		local city  = Asset_Get( task, TaskAssetID.DESTINATION )
		Corps_EnrollInCity( corps, city )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
	end,
	CONSCRIPT       = function ( task )
		--InputUtil_Pause( "conscript", Asset_GetListItem( task, TaskAssetID.PARAMS, "number" ), Asset_Get( Asset_Get( task, TaskAssetID.DESTINATION ), CityAssetID.POPULATION ) )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
	end,
	RECRUIT         = function ( task )
		--InputUtil_Pause( "recruit", Asset_GetListItem( task, TaskAssetID.PARAMS, "number" ), Asset_Get( Asset_Get( task, TaskAssetID.DESTINATION ), CityAssetID.POPULATION ) )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
	end,

	DEV_AGRICULTURE = function( task )
		City_Develop( Asset_Get( task, TaskAssetID.DESTINATION ), Asset_Get( task, TaskAssetID.PROGRESS ), CityAssetID.AGRICULTURE )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
	end,
	DEV_COMMERCE = function( task )
		City_Develop( Asset_Get( task, TaskAssetID.DESTINATION ), Asset_Get( task, TaskAssetID.PROGRESS ), CityAssetID.COMMERCE )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
	end,
	DEV_PRODUCTION = function( task )
		City_Develop( Asset_Get( task, TaskAssetID.DESTINATION ), Asset_Get( task, TaskAssetID.PROGRESS ), CityAssetID.PRODUCTION )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
	end,
	BUILD_CITY      = function ( task )
		City_Build( Asset_Get( task, TaskAssetID.DESTINATION ) )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
	end,
	LEVY_TAX      = function ( task )
		City_LevyTax( Asset_Get( task, TaskAssetID.DESTINATION ), Asset_Get( task, TaskAssetID.PROGRESS ) )
		Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
	end,
	
	HIRE_CHARA = function( task )		
		local progress = Asset_Get( task, TaskAssetID.PROGRESS )
		local rand = Random_GetInt_Sync( 1, 100 )
			if rand <= progress then
			local city  = Asset_Get( task, TaskAssetID.DESTINATION )
			local actor = Asset_Get( task, TaskAssetID.ACTOR )
			local group = Asset_Get( task, TaskAssetID.GROUP )
			local chara = System_Get( SystemType.CHARA_CREATOR_SYS ):GenerateFictionalChara( city )
			if not chara then DBG_Trace( "no chara to hire" ) end
			Chara_Serve( chara, group, city )
			Asset_Set( task, TaskAssetID.RESULT, TaskResult.SUCCESS )
			Stat_Add( "Hire@Success", 1, StatType.TIMES )
		else
			Report_Feedback( task:ToString( "SIMPLE" ) .. " FAILED" )
			--Debug_Log( "hire failed", rand, progress )
			Asset_Set( task, TaskAssetID.RESULT, TaskResult.FAILED )
			Stat_Add( "Hire@Failed", 1, StatType.TIMES )
		end
	end,
	PROMOTE_CHARA = function ( task )
		local actor = Asset_Get( task, TaskAssetID.ACTOR )
		local job = Asset_GetListItem( task, TaskAssetID.PARAMS, "job" )
		Chara_Promote( actor, job )
	end,
	DISPATCH_CHARA  = Task_MoveChara,
	CALL_CHARA      = Task_MoveChara,
}

---------------------------------------------------

local function Task_IsArriveDestination( task )
	local loc
	local actor = Asset_Get( task, TaskAssetID.ACTOR )
	local actorType = Asset_Get( task, TaskAssetID.ACTOR_TYPE )
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

function Task_CityReceive( task )
	local city = Asset_Get( task, TaskAssetID.DESTINATION )
	local plan = Asset_GetListItem( task, TaskAssetID.PARAMS, "plan" )
	Asset_SetListItem( city, CityAssetID.PLANS, plan, task )
end

function Task_CharaReceive( task, chara )
	if Asset_GetListItem( chara, CharaAssetID.STATUSES, CharaStatus.IN_TASK ) == true then
		error( chara:ToString() .. " has task" )
	end

	Asset_SetListItem( chara, CharaAssetID.STATUSES, CharaStatus.IN_TASK, true )

	local subordinates = {}

	local opens = {}
	table.insert( opens, chara )
	
	local inx = 1
	local cur = opens[inx]
	while cur do
		Asset_SetListItem( task, TaskAssetID.CONTRIBUTORS, cur, 0 )
		Asset_SetListItem( cur, CharaAssetID.STATUSES, CharaStatus.IN_TASK, true )
		Asset_AppendList( cur, CharaAssetID.TASKS, task )
		Asset_ForeachList( cur, CharaAssetID.SUBORDINATES, function( subordinate )
			table.insert( opens, subordinate )
		end )
		inx = inx + 1
		cur = opens[inx]		
	end
end

function Task_CorpsReceive( task, corps )	
	function Receive( corps )
		if Asset_GetListItem( corps, CorpsAssetID.STATUSES, CorpsStatus.IN_TASK ) == true then
			print( task:ToString() )
			error( corps:ToString() .. " has task" )
		end

		Asset_SetListItem( task, TaskAssetID.CONTRIBUTORS, corps, 0 )
		Asset_AppendList( corps, CorpsAssetID.TASKS, task )

		Asset_SetListItem( corps, CorpsAssetID.STATUSES, CorpsStatus.IN_TASK, true )

		--Debug_Log( corps:ToString(), "recv task" )
	end

	Receive( corps )
end

function Task_Create( taskType, actor, location, destination, params )
	local task = Entity_New( EntityType.TASK )
	Asset_Set( task, TaskAssetID.TYPE, taskType )

	--copy same data
	Asset_Set( task, TaskAssetID.ACTOR, actor )	
	Asset_Set( task, TaskAssetID.LOCATION, location )
	Asset_Set( task, TaskAssetID.DESTINATION, destination )
	Asset_CopyDict( task, TaskAssetID.PARAMS, params )

	--Debug_Log( "create task--" .. task:ToString() )

	local actor = Asset_Get( task, TaskAssetID.ACTOR )
	local type = Asset_Get( task, TaskAssetID.TYPE )

	if type == TaskType.HARASS_CITY 
		or type == TaskType.ATTACK_CITY 
		or type == TaskType.INTERCEPT
		or type == TaskType.REINFORCE_CORPS
		or type == TaskType.DISMISS_CORPS 
		or type == TaskType.TRAIN_CORPS
		or type == TaskType.UPGRADE_CORPS
		or type == TaskType.DISPATCH_CORPS
		or type == TaskType.ENROLL_CORPS
		then
		Asset_Set( task, TaskAssetID.ACTOR_TYPE, TaskActorType.CORPS )
		Asset_Set( task, TaskAssetID.GROUP, Asset_Get( actor, CorpsAssetID.GROUP ) )
		Task_CorpsReceive( task, actor )
	elseif type == TaskType.HIRE_CHARA 
		or type == TaskType.PROMOTE_CHARA

		or type == TaskType.DEV_AGRICULTURE
		or type == TaskType.DEV_COMMERCE
		or type == TaskType.DEV_PRODUCTION
		or type == TaskType.BUILD_CITY
		or type == TaskType.LEVY_TAX

		or type == TaskType.ESTABLISH_CORPS

		then
		Asset_Set( task, TaskAssetID.ACTOR_TYPE, TaskActorType.CHARA )
		Asset_Set( task, TaskAssetID.GROUP, Asset_Get( actor, CharaAssetID.GROUP ) )
		Task_CityReceive( task )
	elseif type == TaskType.DISPATCH_CHARA
		or type == TaskType.CALL_CHARA
		or type == TaskType.CONSCRIPT
		or type == TaskType.RECRUIT
		then
		Asset_Set( task, TaskAssetID.ACTOR_TYPE, TaskActorType.CHARA )
		Asset_Set( task, TaskAssetID.GROUP, Asset_Get( actor, CharaAssetID.GROUP ) )		
		Task_CharaReceive( task, actor )	
	else
		error( "Should deal with this type=" .. MathUtil_FindName( TaskType, type ) )
	end

	Asset_Set( task, TaskAssetID.BEGIN_TIME, g_calendar:GetDateValue() )
	Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_INIT_DURATION )

	Stat_Add( "Task@Issue", task:ToString( "SIMPLE" ), StatType.LIST )

	if type == TaskType.HARASS_CITY or type == TaskType.ATTACK_CITY then
	--	Debug_Log( "issue task--" .. task:ToString() )
	end
	Stat_Add( "Task@" .. MathUtil_FindName( TaskType, type ), 1, StatType.TIMES )
end

function Task_IssueByProposal( proposal )		
	--convert proposal type into task type
	local typeName = MathUtil_FindName( ProposalType, Asset_Get( proposal, ProposalAssetID.TYPE ) )
	local taskType = TaskType[typeName]	

	local actor = Asset_Get( proposal, ProposalAssetID.ACTOR )
	local loc   = Asset_Get( proposal, ProposalAssetID.LOCATION )
	local dest  = Asset_Get( proposal, ProposalAssetID.DESTINATION )
	local params = Asset_GetList( proposal, ProposalAssetID.PARAMS )

	if taskType == TaskType.ATTACK_CITY then		
		local list = Asset_GetListItem( proposal, ProposalAssetID.PARAMS, "corps_list" )
		for _, corps in ipairs( list ) do
			Task_Create( taskType, corps, loc, dest, params )
		end
	else
		Task_Create( taskType, actor, loc, dest, params )
	end
end

local function Task_BackHome( task )
	Stat_Add( "Task@BackHome", 1, StatType.TIMES )
	if Move_IsMoving( Asset_Get( task, TaskAssetID.ACTOR ) ) == false then
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.MOVING )

		local actor     = Asset_Get( task, TaskAssetID.ACTOR )
		local actorType = Asset_Get( task, TaskAssetID.ACTOR_TYPE )
		if actorType == TaskActorType.CHARA then
			Move_Chara( actor, Asset_Get( actor, CharaAssetID.HOME ) )
		elseif actorType == TaskActorType.CORPS then	
			Debug_Log( task:ToString() .. " back home" )		
			local dest = Asset_Get( actor, CorpsAssetID.ENCAMPMENT )
			if dest then
				Move_Corps( actor, dest )
			else
				local loc = Asset_Get( actor, CorpsAssetID.LOCATION )				
				dest = Asset_Get( task, TaskAssetID.LOCATION )
				if loc ~= dest then
					--back to location where start the task
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

		--move
		local actor     = Asset_Get( task, TaskAssetID.ACTOR )
		local actorType = Asset_Get( task, TaskAssetID.ACTOR_TYPE )		
		if actorType == TaskActorType.CHARA then			
			Move_Chara( actor, Asset_Get( task, TaskAssetID.DESTINATION ) )
		elseif actorType == TaskActorType.CORPS then
			Move_Corps( actor, Asset_Get( task, TaskAssetID.DESTINATION ) )
		end
	end
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

	local fn = _doTask[Asset_Get( task, TaskAssetID.TYPE )]	
	if fn then		
		contribution = fn( task )
	end

	if actor then
		task:Contribute( actor, contribution )
	end

	Stat_Add( "Task@Do", 1, StatType.TIMES )
end

local function Task_End( task )
	local actor = Asset_Get( task, TaskAssetID.ACTOR )
	local actorType = Asset_Get( task, TaskAssetID.ACTOR_TYPE )
	if actorType == TaskActorType.CHARA then
		Asset_SetListItem( actor, CharaAssetID.STATUSES, CharaStatus.IN_TASK, nil )
	elseif actorType == TaskActorType.CORPS then
		Asset_SetListItem( actor, CorpsAssetID.STATUSES, CorpsStatus.IN_TASK, nil )
	end	

	local plan = Asset_GetListItem( task, TaskAssetID.PARAMS, "plan" )
	if plan then
		local city = Asset_Get( task, TaskAssetID.DESTINATION )	
		Asset_SetListItem( city, CityAssetID.PLANS, plan, nil )
		--Debug_Log( "remove plan", task:ToString( "PLAN" ) )
	end

	_interceptTasks[actor] = nil

	Asset_Set( task, TaskAssetID.END_TIME, g_calendar:GetDateValue() )

	Stat_Add( "Task@End", task:ToString( "END" ), StatType.LIST )
	Stat_Add( "TaskType@" .. MathUtil_FindName( TaskType, Asset_Get( task, TaskAssetID.TYPE ) ), 1, StatType.TIMES )

	--Debug_Log( task:ToString(), "end task" )

	Entity_Remove( task )

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
		Asset_ForeachList( task, TaskAssetID.CONTRIBUTORS, function( value, actor )
			Asset_Plus( actor, CharaAssetID.CONTRIBUTION, value )
		end )
	else
		--todo
	end

	Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )

	Stat_Add( "Task@Reply", 1, StatType.TIMES )
end

local function Task_Finish( task )	
	--can execute the task
	local fn = _finishTask[Asset_Get( task, TaskAssetID.TYPE )]
	if fn then
		fn( task )
	else
		--default set status to WAITING, in order to go next step
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
	end

	Stat_Add( "Task@Finish", task:ToString(), StatType.LIST )
end

local function Task_Execute( task )
	--not arrive the destination
	if Task_IsArriveDestination( task ) == false then
		if Asset_Get( task, TaskAssetID.STATUS ) ~= TaskStatus.MOVING then			
			Task_Move2Destination( task )
		end
		return
	else
		if Asset_Get( task, TaskAssetID.STATUS ) == TaskStatus.MOVING then
			Asset_Set( task, TaskAssetID.STATUS, TaskStatus.WAITING )
		end
	end

	if Asset_Get( task, TaskAssetID.STATUS ) == TaskStatus.WORKING then
		Task_Do( task )
		return
	end

	local taskType = Asset_Get( task, TaskAssetID.TYPE )
	local fn = _executeTask[taskType]
	if fn then
		fn( task )
	else
		DBG_Warning( "task [" .. MathUtil_FindName( TaskType, taskType ) .. "]", " no execute function" )
	end

	--Stat_Add( "Task@Excute", 1, StatType.TIMES )
	Stat_Add( "Task@Excute", task:ToString(), StatType.LIST )
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
	end
end


-------------------------------------------

local function Task_OnArriveDestination( msg )
	local actor = Asset_GetListItem( msg, MessageAssetID.PARAMS, "actor" )
	--to do
end

local function Task_OnCombatTriggered( msg )	
	local combat = Asset_GetListItem( msg, MessageAssetID.PARAMS, "combat" )
	if not combat then return end

	local id = combat.id
	if not _combatTasks[id] then _combatTasks[id] = {} end

	local task   = Asset_GetListItem( msg, MessageAssetID.PARAMS, "task" )
	if not task then
		local atk = Asset_GetListItem( msg, MessageAssetID.PARAMS, "atk" )
		local def = Asset_GetListItem( msg, MessageAssetID.PARAMS, "def" )
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
	local combat  = Asset_GetListItem( msg, MessageAssetID.PARAMS, "combat" )
	if not combat then return end

	local id = combat.id
	local taskList = _combatTasks[id]
	if not taskList or #taskList == 0 then return end	

	function CheckTask( task )
		local isTaskSuccess = false
		local taskType = Asset_Get( task, TaskAssetID.TYPE )

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
					--continue to attack city
					Message_Post( MessageType.START_MOVING, { actor = Asset_Get( task, TaskAssetID.ACTOR ) } )
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
	local combat = Asset_GetListItem( msg, MessageAssetID.PARAMS, "combat" )
	if not combat then return end
	local taskList = _combatTasks[combat.id]
	if not taskList or #taskList == 0 then return end

	local corps  = Asset_GetListItem( msg, MessageAssetID.PARAMS, "corps" )
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
	_doTask      = MathUtil_ConvertKeyToID( TaskType, _doTask )
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