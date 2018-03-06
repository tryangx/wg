local DEFAULT_TASK_INIT_DURATION = 0

local NORMAL_TASK_INIT_DURATION  = 30

local DEFAULT_WORKLOAD           = 30

local _removeTask

---------------------------------------------------
-- Task Content Function

local _initTask = 
{
	ESTABLISH_CORPS = function( task )	
		Asset_Set( task, TaskAssetID.DURATION, NORMAL_TASK_INIT_DURATION )
	end,

	HARASS_CITY     = function ( task )
		Intel_Post( IntelType.HARASS_CITY, Asset_Get( task, TaskAssetID.LOCATION ), { actor = Asset_Get( task, TaskAssetID.ACTOR ) } )
		Asset_Set( task, TaskAssetID.DURATION, NORMAL_TASK_INIT_DURATION )
	end,
	ATTACK_CITY     = function ( task )
		Intel_Post( IntelType.ATTACK_CITY, Asset_Get( task, TaskAssetID.LOCATION ), { actor = Asset_Get( task, TaskAssetID.ACTOR ) } )
		Asset_Set( task, TaskAssetID.DURATION, NORMAL_TASK_INIT_DURATION )
	end,
	INTERCEPT       = function ( task )
		InputUtil_EnablePause( false )
		Stat_Add( "Intercept@" .. Asset_Get( task, TaskAssetID.GROUP ).name, 1, StatType.TIMES )
		--InputUtil_Pause( Asset_Get( task, TaskAssetID.ACTOR ).name, "intercept" )
		Asset_Set( task, TaskAssetID.DURATION, NORMAL_TASK_INIT_DURATION )
	end,

	HIRE_CHARA = function ( task )
		Asset_Set( task, TaskAssetID.DURATION, NORMAL_TASK_INIT_DURATION )
	end,
}

--return valid means not to set finished status
local _executeTask = 
{
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
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		local corps = Asset_GetListItem( task, TaskAssetID.PARAMS, "corps" )
		Corps_Train( corps, city )
	end,
	DISPATCH_CORPS  = function ( task )
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		local corps = Asset_GetListItem( task, TaskAssetID.PARAMS, "corps" )
		Corps_Dispatch( corps, city )
	end,

	HARASS_CITY     = function ( task )
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		local corps = Asset_Get( task, TaskAssetID.ACTOR )
		local combat = Corps_HarassCity( corps, city )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.SUSPENDED )
		Asset_SetListItem( task, TaskAssetID.PARAMS, "combat", combat.id )
		return true
	end,
	ATTACK_CITY     = function ( task )
		local city = Asset_Get( task, TaskAssetID.DESTINATION )
		local corps = Asset_Get( task, TaskAssetID.ACTOR )
		local combat = Corps_AttackCity( corps, city )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.SUSPENDED )
		Asset_SetListItem( task, TaskAssetID.PARAMS, "combat", combat.id )
		return true
	end,
	INTERCEPT       = function ( task )
		--back
	end,

	DEV_AGRICULTURE = City_DevelopByTask,
	DEV_COMMERCE    = City_DevelopByTask,
	DEV_PRODUCTION  = City_DevelopByTask,
	BUILD_CITY      = function ( task )
	end,
	LEVY_TAX      = function ( task )
	end,

	HIRE_CHARA = function ( task )
		local city  = Asset_Get( task, TaskAssetID.DESTINATION )
		local actor = Asset_Get( task, TaskAssetID.ACTOR )
		local group = Asset_Get( task, TaskAssetID.GROUP )
		local chara = System_Get( SystemType.CHARA_CREATOR_SYS ):GenerateFictionalChara( city )
		if not chara then DBG_Trace( "no chara to hire" ) end
		Chara_Serve( chara, group, city )
	end,
	PROMOTE_CHARA = function ( task )
		local actor = Asset_Get( task, TaskAssetID.ACTOR )
		local job = Asset_GetListItem( task, TaskAssetID.PARAMS, "job" )
		Chara_Promote( actor, job )
	end,
}

local _workloads = 
{
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

---------------------------------------------------

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

function Task_Issue( task )	
	local actor = Asset_Get( task, TaskAssetID.ACTOR )
	local type = Asset_Get( task, TaskAssetID.TYPE )
	--InputUtil_Pause( "issue task to " .. actor.name, MathUtil_FindName( TaskType, type ) )	
	if type == TaskType.HARASS_CITY or type == TaskType.ATTACK_CITY or type == TaskType.INTERCEPT then
		--Move_SetWatchActor( actor )

		Asset_Set( task, TaskAssetID.ACTOR_TYPE, TaskActorType.CORPS )
		Asset_Set( task, TaskAssetID.GROUP, Asset_Get( actor, CorpsAssetID.GROUP ) )
		Task_CorpsReceive( task, actor )
	else
		Asset_Set( task, TaskAssetID.ACTOR_TYPE, TaskActorType.CHARA )
		Asset_Set( task, TaskAssetID.GROUP, Asset_Get( actor, CharaAssetID.GROUP ) )

		--issue task to every attenders managed by the actor	
		Task_CharaReceive( task, actor )
	end

	Asset_Set( task, TaskAssetID.BEGIN_TIME, g_calendar:GetDateValue() )
	Asset_Set( task, TaskAssetID.DURATION, DEFAULT_TASK_INIT_DURATION )
end

function Task_Do( task, actor )
	local workload = DEFAULT_WORKLOAD
	
	local type = Asset_Get( task, TaskAssetID.TYPE )
	local name = MathUtil_FindName( TaskType, type )
	local fn = _workloads[name]
	if fn then workload = fn( task ) end

	task:Contribute( actor, workload )

	--print( "task_do", workload, Asset_Get( task, TaskAssetID.WORKLOAD ) )
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

	if 1 then
		Stat_Add( "Task@End", { id = task.id, type = Asset_Get( task, TaskAssetID.TYPE ), dest = Asset_Get( task, TaskAssetID.DESTINATION ), group = Asset_Get( task, TaskAssetID.GROUP ),
			--begt = Asset_Get( task, TaskAssetID.BEGIN_TIME ), endt = Asset_Get( task, TaskAssetID.END_TIME ),
			day = g_calendar:CalcDiffDayByDates( Asset_Get( task, TaskAssetID.END_TIME ), Asset_Get( task, TaskAssetID.BEGIN_TIME ) ) }, StatType.LIST )
		Entity_Remove( task )

		Stat_SetDumper( "Task@End", function ( data )
			print( "Task End=" .. StringUtil_Abbreviate( MathUtil_FindName( TaskType, data.type ), 16 ),  "dest=" .. StringUtil_Abbreviate( data.dest.name, 8 ),
				--"beg=" .. g_calendar:CreateDateDescByValue( data.begt ), "end=" .. g_calendar:CreateDateDescByValue( data.endt ),
				"day=" .. data.day, "id=" .. data.id, "group=" .. ( data.group and data.group.name or "[??]" ) )
		end )
	end

	if 1 then
		Stat_Add( "TaskType@" .. MathUtil_FindName( TaskType, Asset_Get( task, TaskAssetID.TYPE ) ), 1, StatType.TIMES )
	end
	return true
end

local function Task_Replay( task )
	local actor = Asset_Get( task, TaskAssetID.ACTOR )
	if actor:IsAtHome() == false then return true end

	--bonus to contributor
	Asset_ForeachList( task, TaskAssetID.CONTRIBUTORS, function( value, actor )
		Asset_Plus( actor, CharaAssetID.CONTRIBUTION, value )
		--print( actor.name, "contribute", value, Asset_Get( actor, CharaAssetID.CONTRIBUTION ) )		
	end )

	Asset_Set( task, TaskAssetID.STATUS, TaskStatus.END )

	return false
end

local function Task_Cancel( task )
	local type = Asset_Get( task, TaskAssetID.TYPE )
	if type == TaskType.ESTABLISH_CORPS then
		--recycle resource
	end

	Stat_Add( "Task@Cancel", { id = task.id, type = Asset_Get( task, TaskAssetID.TYPE ) }, StatType.LIST )
	Stat_SetDumper( "Task@Cancel", function ( data )
		print( "Task Cancel=" .. StringUtil_Abbreviate( MathUtil_FindName( TaskType, data.type ), 16 ) )
	end )

	Entity_Remove( task )
	return true
end

local function Task_Finish( task )
	Asset_Set( task, TaskAssetID.STATUS, TaskStatus.REPLY )

	local actor = Asset_Get( task, TaskAssetID.ACTOR )
	if actor:IsAtHome() == false then
		--move		
		local actorType = Asset_Get( task, TaskAssetID.ACTOR_TYPE )
		if actorType == TaskActorType.CHARA then
			System_Get( SystemType.MOVE_SYS ):CharaMove( Asset_Get( task, TaskAssetID.ACTOR ), Asset_Get( actor, CharaAssetID.HOME ) )
		elseif actorType == TaskActorType.CORPS then
			--InputUtil_Pause( actor.name, "need backhome", Asset_Get( actor, CorpsAssetID.ENCAMPMENT ).name )
			System_Get( SystemType.MOVE_SYS ):CorpsMove( Asset_Get( task, TaskAssetID.ACTOR ), Asset_Get( actor, CorpsAssetID.ENCAMPMENT ) )
		end	
		return true
	end

	return false
end

local function Task_Suspend( task )
	local type = Asset_Get( task, TaskAssetID.TYPE )
	if type == TaskType.HARASS_CITY or type == TaskType.ATTACK_CITY then
		local id = Asset_GetListItem( task, TaskAssetID.PARAMS, "combat" )
		if not Entity_Get( EntityType.COMBAT, id ) then
			Asset_Set( task, TaskAssetID.STATUS, TaskStatus.FINISHED )
			return false			
		end
	end
	return true
end

local function Task_Execute( task )
	local type = Asset_Get( task, TaskAssetID.TYPE )
	local name = MathUtil_FindName( TaskType, type )
	local fn = _executeTask[name]
	if fn then
		if fn( task ) then return false end
	else
		DBG_Warning( "task_" .. name .. "_no_func", "no finish function" )
	end
	Asset_Set( task, TaskAssetID.STATUS, TaskStatus.FINISHED )
	return false
end

local function Task_Ontheway( task )
	if Task_IsArriveDestination( task ) == false then return true end
	Asset_Set( task, TaskAssetID.STATUS, TaskStatus.EXECUTING )
	--InputUtil_Pause( "EXECUTING")
	return false
end

local function Task_Prepare( task )
	if Task_IsArriveDestination( task ) == false then		
		--move
		local actorType = Asset_Get( task, TaskAssetID.ACTOR_TYPE )
		if actorType == TaskActorType.CHARA then
			System_Get( SystemType.MOVE_SYS ):CharaMove( Asset_Get( task, TaskAssetID.ACTOR ), Asset_Get( task, TaskAssetID.DESTINATION ) )
		elseif actorType == TaskActorType.CORPS then
			System_Get( SystemType.MOVE_SYS ):CorpsMove( Asset_Get( task, TaskAssetID.ACTOR ), Asset_Get( task, TaskAssetID.DESTINATION ) )
		end
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.ON_THE_WAY )	
		return true
	else
		local type = Asset_Get( task, TaskAssetID.TYPE )
		if type == TaskType.INTERCEPT then		
			--InputUtil_Pause( Asset_Get( task, TaskAssetID.ACTOR ).name, "Arrive destination" )		
		end
	end

	--local delta = g_calendar:CalcDiffDayByDates( g_calendar:GetDateValue(), Asset_Get( task, TaskAssetID.BEGIN_TIME ) )
	--print( delta )
	--InputUtil_Pause( g_calendar:CreateDesc( true, true ), g_calendar:CreateDateDescByValue( Asset_Get( task, TaskAssetID.BEGIN_TIME ) ) )
	--Stat_Add( "Task@Prepare_Time", delta, StatType.ACCUMULATION )

	Asset_Set( task, TaskAssetID.STATUS, TaskStatus.EXECUTING )
	return false
end

local function Task_Init( task )
	local type = Asset_Get( task, TaskAssetID.TYPE )
	local name = MathUtil_FindName( TaskType, type )
	
	local fn = _initTask[name]
	if fn then
		fn( task )
	else
		Asset_Set( task, TaskAssetID.DURATION, NORMAL_TASK_INIT_DURATION )
		--DBG_Warning( "task no function", ( name or type ) .. " no prepare function, use default operation" )
	end

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

	return false
end

--INITIALIZE -> PREPARE -> ON_THE_WAY -> EXECUTING -> FINISHED -> REPLY -> END
local function Task_Update( task )
	--reduce
	Asset_Reduce( task, TaskAssetID.DURATION, g_elapsed )
	local cur = Asset_Get( task , TaskAssetID.DURATION )	
	if cur > 0 then
		return true
	end

	local status = Asset_Get( task, TaskAssetID.STATUS )
	local type = Asset_Get( task, TaskAssetID.TYPE )
	
	if type == TaskType.ATTACK_CITY then
		--print( "task_update_" .. MathUtil_FindName( TaskType, type ), "task=" .. task.id .. " status=" .. MathUtil_FindName( TaskStatus, status ) )
	elseif type == TaskType.INTERCEPT then
		--InputUtil_Pause( "update intercept" )
	end

	local ret = false
	if status == TaskStatus.INITIALIZE then
		ret = Task_Init( task )
	elseif status == TaskStatus.PREPARE then
		ret = Task_Prepare( task )
	elseif status == TaskStatus.ON_THE_WAY then
		ret = Task_Ontheway( task )
	elseif status == TaskStatus.EXECUTING then
		ret = Task_Execute( task )
	elseif status == TaskStatus.FINISHED then
		ret = Task_Finish( task )
	elseif status == TaskStatus.REPLY then
		ret = Task_Replay( task )
	elseif status == TaskStatus.END or status == TaskStatus.FAILED then
		ret = Task_End( task )
	elseif status == TaskStatus.SUSPENDED then
		ret = Task_Suspend( task )
	elseif status == TaskStatus.CANCELED then
		ret = Task_Cancel( task )
	end
	return ret
end

-------------------------------------------

TaskSystem = class()

function TaskSystem:__init()
	System_Setup( self, SystemType.TASK_SYS, "TASK" )
end

function TaskSystem:Start()
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