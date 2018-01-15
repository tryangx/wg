---------------------------------------------------

local function Task_IsFinished( taks )
	local duration = Asset_Get( task, TaskAssetID.DURATION )
	if not duration or duration > 0 then
		duration = duration - 1
		Asset_Set( task, TaskAssetID.DURATION )
		return false
	end
	return true
end

---------------------------------------------------
-- Task Content Function

local _startTask = 
{
	ESTABLISH_CORPS = function( task )	
		local city = Asset_Get( task, TaskAssetID.LOCATION )
		print( city )
		if not city then InputUtil_Pause( "invalid city in EstablishCorps" ) end
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.EXECUTING )
		Asset_Set( task, TaskAssetID.DURATION, 30 )
		Asset_SetListItem( task, TaskAssetID.VALUES, "LOCK_MANPOWER", lock )
	end,
}

---------------------------------------------------

local function Task_End( task )
	Stat_Add( "Task End", { id = task.id, type = Asset_Get( task, TaskAssetID.TYPE ) }, StatType.LIST )

	Entity_Remove( task )
end

local function Task_Prepare( task )
	Asset_Set( task, TaskAssetID.STATUS, TaskStatus.START )	
end

local function Task_Start( task )
	local type = Asset_Get( task, TaskAssetID.TYPE )
	
	local name = MathUtil_FindName( TaskType, type )
	local fn = _startTask[name]
	if fn and fn( task ) then return end

	--default execution
	Asset_Set( task, TaskAssetID.STATUS, TaskStatus.ON_THE_WAY )
end
local function Task_Ontheway( task )

end
local function Task_Finished( task )

end
local function Task_Replay( task )

end

local function Task_Execute( task )
	local type = Asset_Get( task, TaskAssetID.TYPE )
	if type == TaskType.ESTABLISH_CORPS then
		local city = Asset_Get( task, TaskAssetID.LOCATION )
		System_Get( SystemType.CORPS_SYS ):EstablishCorpsInCity( city )
		Asset_Set( task, TaskAssetID.STATUS, TaskStatus.END )		
	end	
end

local function Task_Canceled( task )
	local type = Asset_Get( task, TaskAssetID.TYPE )
	if type == TaskType.ESTABLISH_CORPS then
		--recycle resource
	end
	Entity_Remove( task )
end

local function Task_Update( task )	
	local status = Asset_Get( task, TaskAssetID.STATUS )
	--InputUtil_Pause( "task=" .. task.id .. " status=" .. MathUtil_FindName( TaskStatus, status ) )
	if status == TaskStatus.PREPARE then
		Task_Prepare( task )
	elseif status == TaskStatus.START then
		Task_Start( task )
	elseif status == TaskStatus.ON_THE_WAY then
		Task_Ontheway( task )
	elseif status == TaskStatus.FINISHED then
		Task_Finished( task )
	elseif status == TaskStatus.REPLY then
		Task_Replay( task )
	elseif status == TaskStatus.END then
		Task_End( task )
	elseif status == TaskStatus.EXECUTING then
		Task_Execute( task )
	elseif status == TaskStatus.IDLE then
	elseif status == TaskStatus.CANCELED then
		Task_Canceled( task )
	end
end

-------------------------------------------

TaskSystem = class()

function TaskSystem:__init()
	System_Setup( self, SystemType.TASK_SYS, "TASK" )
end

function TaskSystem:Start()
end

function TaskSystem:Update()
	Entity_Foreach( EntityType.TASK, Task_Update )
end