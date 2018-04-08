local DEFAULT_TASK_INIT_DURATION = 0

local DEFAULT_TASK_DURATION      = 30

local DEFAULT_TASK_CONTRIBUTION  = 10

local _removeTask

local _moveWatcher = {}

---------------------------------------------------
-- Task Content Function

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
			Asset_Set( task, TaskAssetID.STATUS, TaskStatus.CANCELED )
			return true
		end
	end

	Asset_Set( task, TaskAssetID.STATUS, TaskStatus.PREPARE )
end

local _prepareTask = 
{
	ESTABLISH_CORPS = function( task )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
	end,
	ESTABLISH_CORPS = function( task )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
	end,

	HARASS_CITY     = function ( task )
		Intel_Post( IntelType.HARASS_CITY, Asset_Get( task, TaskAssetID.LOCATION ), { actor = Asset_Get( task, TaskAssetID.ACTOR ) } )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
	end,
	ATTACK_CITY     = function ( task )
		Intel_Post( IntelType.ATTACK_CITY, Asset_Get( task, TaskAssetID.LOCATION ), { actor = Asset_Get( task, TaskAssetID.ACTOR ) } )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
	end,
	INTERCEPT       = function ( task )
		--Stat_Add( "Intercept@" .. Asset_Get( task, TaskAssetID.GROUP ).name, 1, StatType.TIMES )
		--InputUtil_Pause( Asset_Get( task, TaskAssetID.ACTOR ).name, "intercept" )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
	end,
}

--return valid means not to set finished status
local _executeTask = 
{
	HARASS_CITY     = function ( task )
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		local corps = Asset_Get( task, TaskAssetID.ACTOR )
		local combat = Corps_HarassCity( corps, city )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.RUNNING )
		Asset_SetListItem( task, TaskAssetID.PARAMS, "combat", combat.id )
		return true
	end,
	ATTACK_CITY     = function ( task )
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		local corps = Asset_Get( task, TaskAssetID.ACTOR )
		local combat = Corps_AttackCity( corps, city )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.RUNNING )
		Asset_SetListItem( task, TaskAssetID.PARAMS, "combat", combat.id )
		return true
	end,
	INTERCEPT       = function ( task )
		--back
	end,

	ESTABLISH_CORPS = function ( task )
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		Corps_EstablishInCity( city )
	end,
	REINFORCE_CORPS = function ( task )
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		local corps = Asset_GetListItem( task, TaskAssetID.PARAMS, "corps" )
		Corps_ReinforceInCity( corps, city )
	end,
	TRAIN_CORPS     = function ( task )
	--[[
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		local corps = Asset_GetListItem( task, TaskAssetID.PARAMS, "corps" )
		Corps_Train( corps, city )
		]]
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
	end,
	DISPATCH_CORPS  = function ( task )
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		local corps = Asset_GetListItem( task, TaskAssetID.PARAMS, "corps" )
		Corps_Dispatch( corps, city )
	end,

	DEV_AGRICULTURE = function( task )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
	end,
	DEV_COMMERCE = function( task )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
	end,
	DEV_PRODUCTION = function( task )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
	end,
	BUILD_CITY      = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
	end,
	LEVY_TAX      = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_DURATION )
	end,

	HIRE_CHARA = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, 10 )
	end,
	PROMOTE_CHARA = function ( task )
		local actor = Asset_Get( task, TaskAssetID.ACTOR )
		local job = Asset_GetListItem( task, TaskAssetID.PARAMS, "job" )
		Chara_Promote( actor, job )
	end,
}

local function Default_Work( task )
	local progress = Random_GetInt_Sync( 5, 10 )	
	task:Do( progress )
	return DEFAULT_TASK_CONTRIBUTION
end

local _doTask = 
{
	HIRE_CHARA      = Default_Work,

	DEV_AGRICULTURE = Default_Work,
	DEV_COMMERCE    = Default_Work,
	DEV_PRODUCTION  = Default_Work,	
	BUILD_CITY      = Default_Work,
	LEVY_TAX        = Default_Work,
}

local _finishTask = 
{
	DEV_AGRICULTURE = function( task )
		City_Develop( Asset_Get( task, TaskAssetID.DESTINATION ), Asset_Get( task, TaskAssetID.PROGRESS ), CityAssetID.AGRICULTURE )
	end,
	DEV_COMMERCE = function( task )
		City_Develop( Asset_Get( task, TaskAssetID.DESTINATION ), Asset_Get( task, TaskAssetID.PROGRESS ), CityAssetID.COMMERCE )
	end,
	DEV_PRODUCTION = function( task )
		City_Develop( Asset_Get( task, TaskAssetID.DESTINATION ), Asset_Get( task, TaskAssetID.PROGRESS ), CityAssetID.PRODUCTION )
	end,
	BUILD_CITY      = function ( task )
		City_Build( Asset_Get( task, TaskAssetID.DESTINATION ) )
	end,
	LEVY_TAX      = function ( task )
		City_LevyTax( Asset_Get( task, TaskAssetID.DESTINATION ), Asset_Get( task, TaskAssetID.PROGRESS ) )
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
		else
			Report_Feedback( task:ToString( "SIMPLE" ) .. " FAILED" )
		end
	end,
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
	Asset_SetListItem( task, TaskAssetID.CONTRIBUTORS, corps, 0 )
	Asset_AppendList( corps, CorpsAssetID.TASKS, task )

	Asset_SetListItem( corps, CorpsAssetID.STATUSES, CorpsStatus.IN_TASK, true )
end

function Task_IssueByProposal( proposal )	
	local task = Entity_New( EntityType.TASK )

	--convert proposal type into task type
	local typeName = MathUtil_FindName( ProposalType, Asset_Get( proposal, ProposalAssetID.TYPE ) )
	local taskType = TaskType[typeName]
	Asset_Set( task, TaskAssetID.TYPE, taskType )

	--copy same data
	Asset_Set( task, TaskAssetID.ACTOR, Asset_Get( proposal, ProposalAssetID.ACTOR ) )	
	Asset_Set( task, TaskAssetID.LOCATION, Asset_Get( proposal, ProposalAssetID.LOCATION ) )
	Asset_Set( task, TaskAssetID.DESTINATION, Asset_Get( proposal, ProposalAssetID.DESTINATION ) )
	local plan = Asset_GetListItem( proposal, ProposalAssetID.PARAMS, "plan" )
	Asset_CopyDict( task, TaskAssetID.PARAMS, Asset_GetList( proposal, ProposalAssetID.PARAMS ) )	

	local actor = Asset_Get( task, TaskAssetID.ACTOR )
	local type = Asset_Get( task, TaskAssetID.TYPE )

	if type == TaskType.HARASS_CITY or type == TaskType.ATTACK_CITY or type == TaskType.INTERCEPT then
		Asset_Set( task, TaskAssetID.ACTOR_TYPE, TaskActorType.CORPS )
		Asset_Set( task, TaskAssetID.GROUP, Asset_Get( actor, CorpsAssetID.GROUP ) )
		Task_CorpsReceive( task, actor )
	else		
		Asset_Set( task, TaskAssetID.ACTOR_TYPE, TaskActorType.CHARA )
		Asset_Set( task, TaskAssetID.GROUP, Asset_Get( actor, CharaAssetID.GROUP ) )
		Task_CityReceive( task )
		--issue task to every attenders managed by the actor	
		--Task_CharaReceive( task, actor )
	end

	Asset_Set( task, TaskAssetID.BEGIN_TIME, g_calendar:GetDateValue() )
	Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_INIT_DURATION )

	print( "issue task--" .. task:ToString() )
end

function Task_Do( task, actor )	
	local contribution = DEFAULT_TASK_CONTRIBUTION

	local fn = _doTask[Asset_Get( task, TaskAssetID.TYPE )]	
	if fn then
		contribution = fn( task )
	end

	task:Contribute( actor, contribution )
end

local function Task_End( task )
	local actor = Asset_Get( task, TaskAssetID.ACTOR )
	local actorType = Asset_Get( task, TaskAssetID.ACTOR_TYPE )
	if actorType == TaskActorType.CHARA then
		Asset_SetListItem( actor, CharaAssetID.STATUSES, CharaStatus.IN_TASK, nil )
	elseif actorType == TaskActorType.CORPS then
		Asset_SetListItem( actor, CorpsAssetID.STATUSES, CorpsStatus.IN_TASK, nil )
	end	

	Asset_Set( task, TaskAssetID.END_TIME, g_calendar:GetDateValue() )

	Stat_Add( "Task@End", { id = task.id, type = Asset_Get( task, TaskAssetID.TYPE ), dest = Asset_Get( task, TaskAssetID.DESTINATION ), group = Asset_Get( task, TaskAssetID.GROUP ), actor = Asset_Get( task, TaskAssetID.ACTOR ),
		begt = Asset_Get( task, TaskAssetID.BEGIN_TIME ), endt = Asset_Get( task, TaskAssetID.END_TIME ),
		day = g_calendar:CalcDiffDayByDates( Asset_Get( task, TaskAssetID.END_TIME ), Asset_Get( task, TaskAssetID.BEGIN_TIME ) ) }, StatType.LIST )
	Entity_Remove( task )

	Stat_Add( "TaskType@" .. MathUtil_FindName( TaskType, Asset_Get( task, TaskAssetID.TYPE ) ), 1, StatType.TIMES )

	--InputUtil_Pause( g_calendar:CreateCurrentDateDesc() )

	return true
end

local function Task_BackHome( task )
	Stat_Add( "Task@BackHome", 1, StatType.TIMES )
	if Move_IsMoving( Asset_Get( task, TaskAssetID.ACTOR ) ) == false then
		local actorType = Asset_Get( task, TaskAssetID.ACTOR_TYPE )		
		if actorType == TaskActorType.CHARA then
			Move_Chara( actor, Asset_Get( actor, CharaAssetID.HOME ) )
		elseif actorType == TaskActorType.CORPS then
			Move_Corps( actor, Asset_Get( actor, CorpsAssetID.ENCAMPMENT ) )
		end
	end
end

local function Task_Move2Destination( task )
	Stat_Add( "Task@Move2Dest", 1, StatType.TIMES )
	if Move_IsMoving( Asset_Get( task, TaskAssetID.ACTOR ) ) == false then
		--move
		local actorType = Asset_Get( task, TaskAssetID.ACTOR_TYPE )
		if actorType == TaskActorType.CHARA then
			Move_Chara( actor, Asset_Get( actor, CharaAssetID.HOME ) )
		elseif actorType == TaskActorType.CORPS then
			Move_Corps( actor, Asset_Get( actor, CorpsAssetID.ENCAMPMENT ) )
		end
	end
end

local function Task_Reply( task )
	--default go back home
	if Task_IsAtHome( task ) == false then
		Task_BackHome( task )
		return
	end

	--bonus to contributor
	if Asset_Get( task, TaskAssetID.ACTOR_TYPE ) == TaskActorType.CHARA then
		Asset_ForeachList( task, TaskAssetID.CONTRIBUTORS, function( value, actor )
			Asset_Plus( actor, CharaAssetID.CONTRIBUTION, value )
		end )
	else
		--todo
	end

	Asset_Set( task, TaskAssetID.STATUS, TaskStatus.END )

	Stat_Add( "Task@Reply", 1, StatType.TIMES )
end

local function Task_Finish( task )
	if Asset_Get( task, TaskAssetID.STATUS ) == TaskStatus.RUNNING then return end

	--can execute the task
	local fn = _finishTask[Asset_Get( task, TaskAssetID.TYPE )]
	if fn then fn( task ) end

	Asset_Set( task, TaskAssetID.STATUS, TaskStatus.RUNNING )

	Stat_Add( "Task@Finish", 1, StatType.TIMES )
end

local function Task_Execute( task )
	--not arrive the destination
	if Task_IsArriveDestination( task ) == false then
		Task_Move2Destination( task )
		return
	end

	--can execute the task
	if Asset_Get( task, TaskAssetID.STATUS ) == TaskStatus.RUNNING then return end

	local fn = _executeTask[Asset_Get( task, TaskAssetID.TYPE )]
	if fn then
		fn( task )
	else
		DBG_Warning( "task [" .. name .. "]", "no execute function" )
	end

	Asset_Set( task, TaskAssetID.STATUS, TaskStatus.RUNNING )

	Stat_Add( "Task@Excute", 1, StatType.TIMES )

	Stat_Add( "TaskExecute", task:ToString(), StatType.LIST )
end

local function Task_Prepare( task )
	if Asset_Get( task, TaskAssetID.STATUS ) == TaskStatus.RUNNING then return end

	local fn = _prepareTask[Asset_Get( task, TaskAssetID.TYPE )]
	if fn then fn( task ) end

	Asset_Set( task, TaskAssetID.STATUS, TaskStatus.RUNNING )
end

local function Task_Update( task )
	local type = Asset_Get( task, TaskAssetID.TYPE )	
	local step = Scenario_GetData( "TASK_STEP_DATA" )[type]	
	if not step then
		DBG_Warning( "task [" .. MathUtil_FindName( TaskType, type ) .. "]", "no step data" )
		return
	end
	
	local stepIndex = Asset_Get( task, TaskAssetID.STEP )
	local taskStep = step[stepIndex]
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

	if task:Update( g_elapsed ) == true then Task_Update( task ) end
end

local function Task_ArriveDestination( msg )
	Asset_GetListItem( msg, MessageAssetID.PARAMS, "actor" )
end

-------------------------------------------

TaskSystem = class()

function TaskSystem:__init()
	System_Setup( self, SystemType.TASK_SYS, "TASK" )

	Stat_SetDumper( "Task@End", function ( data )
		print( "Task=" .. data.id .. " " .. StringUtil_Abbreviate( MathUtil_FindName( TaskType, data.type ), 16 ),  "dest=" .. StringUtil_Abbreviate( data.dest.name, 8 ),
			"act=" .. data.actor.name, "beg=" .. g_calendar:CreateDateDescByValue( data.begt ), "end=" .. g_calendar:CreateDateDescByValue( data.endt ),
			"day=" .. data.day, "id=" .. data.id, "group=" .. ( data.group and data.group.name or "[??]" ) )
	end, StatType.LIST )
end

function TaskSystem:Start()
	Message_Handle( SystemType.TASK_SYS, MessageType.ARRIVE_DESTINATION, Task_ArriveDestination )

	_prepareTask = MathUtil_ConvertKeyToID( TaskType, _prepareTask )
	_executeTask = MathUtil_ConvertKeyToID( TaskType, _executeTask )
	_finishTask  = MathUtil_ConvertKeyToID( TaskType, _finishTask )
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