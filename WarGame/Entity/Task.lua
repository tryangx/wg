-- Task 
--
--
--
--

TaskAssetType = 
{
	BASE_ATTRIB = 1,
}

TaskAssetID = 
{
	TYPE         = 10,	
	STATUS       = 11,
	RESULT       = 12,
	STEP         = 13,

	ACTOR        = 20,
	ACTOR_TYPE   = 21,
	GROUP        = 22,
	--location
	LOCATION     = 23,
	DESTINATION  = 24,
	--target
	PARAMS       = 25,

	--remain time to finish the task
	DURATION     = 30,
	--how many works need to finish
	WORKLOAD     = 31,
	--how many works finished
	PROGRESS     = 32,
	
	CONTRIBUTORS = 40,

	--debug
	BEGIN_TIME   = 100,
	END_TIME     = 101,
}

TaskAssetAttrib = 
{
	type         = AssetAttrib_SetNumber ( { id = TaskAssetID.TYPE,       type = TaskAssetType.BASE_ATTRIB, enum = TaskType } ),
	status       = AssetAttrib_SetNumber ( { id = TaskAssetID.STATUS,     type = TaskAssetType.BASE_ATTRIB, enum = TaskStatus, default = TaskStatus.RUNNING } ),
	result       = AssetAttrib_SetNumber ( { id = TaskAssetID.RESULT,     type = TaskAssetType.BASE_ATTRIB, enum = TaskResult, default = TaskResult.UNKNOWN } ),
	step         = AssetAttrib_SetNumber ( { id = TaskAssetID.STEP,       type = TaskAssetType.BASE_ATTRIB, default = 1 } ),
	
	actor        = AssetAttrib_SetPointer( { id = TaskAssetID.ACTOR,      type = TaskAssetType.BASE_ATTRIB } ),
	actortype    = AssetAttrib_SetNumber ( { id = TaskAssetID.ACTOR_TYPE, type = TaskAssetType.BASE_ATTRIB, enum = TaskActorType } ),	
	group        = AssetAttrib_SetPointer( { id = TaskAssetID.GROUP,      type = TaskAssetType.BASE_ATTRIB, setter = Entity_SetGroup } ),	
	
	location     = AssetAttrib_SetPointer( { id = TaskAssetID.LOCATION,   type = TaskAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	destination  = AssetAttrib_SetPointer( { id = TaskAssetID.DESTINATION,type = TaskAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	params       = AssetAttrib_SetList   ( { id = TaskAssetID.PARAMS,     type = TaskAssetType.BASE_ATTRIB } ),	

	duration     = AssetAttrib_SetNumber ( { id = TaskAssetID.DURATION,   type = TaskAssetType.BASE_ATTRIB, default = 0 } ),
	workload     = AssetAttrib_SetNumber ( { id = TaskAssetID.WORKLOAD,   type = TaskAssetType.BASE_ATTRIB, default = 100 } ),
	progress     = AssetAttrib_SetNumber ( { id = TaskAssetID.PROGRESS,   type = TaskAssetType.BASE_ATTRIB, default = 0 } ),	
	
	contributors = AssetAttrib_SetList   ( { id = TaskAssetID.CONTRIBUTORS,  type = TaskAssetType.BASE_ATTRIB } ),

	begtime      = AssetAttrib_SetNumber( { id = TaskAssetID.BEGIN_TIME,  type = TaskAssetType.BASE_ATTRIB } ),
	endtime      = AssetAttrib_SetNumber( { id = TaskAssetID.END_TIME,    type = TaskAssetType.BASE_ATTRIB } ),
}	



-------------------------------------------


Task = class()

function Task:__init( ... )
	Entity_Init( self, EntityType.TASK, TaskAssetAttrib )
end

function Task:ToString( type )	
	local content = self.id .. " " .. MathUtil_FindName( TaskType, Asset_Get( self, TaskAssetID.TYPE ) )
	content = content .. " " .. String_ToStr( Asset_Get( self, TaskAssetID.GROUP ), "name" )
	if type == "SIMPLE" then
		content = content .. " beg=" .. g_Time:CreateDateDescByValue( Asset_Get( self, TaskAssetID.BEGIN_TIME ) )
	elseif type == "DEBUG_UPDATE" then
		content = content .. " atr=" .. ( Asset_Get( self, TaskAssetID.ACTOR ):ToString() )
		content = content .. " dur=" .. Asset_Get( self, TaskAssetID.DURATION )
	elseif type == "END" then
		content = content .. " atr=" .. ( Asset_Get( self, TaskAssetID.ACTOR ):ToString() )
		content = content .. " beg=" .. g_Time:CreateDateDescByValue( Asset_Get( self, TaskAssetID.BEGIN_TIME ) )
		content = content .. " end=" .. g_Time:CreateDateDescByValue( Asset_Get( self, TaskAssetID.END_TIME ) )
		content = content .. " pas=" .. g_Time:CalcDiffDayByDate( Asset_Get( self, TaskAssetID.BEGIN_TIME ) )
	elseif type == "PLAN" then
		content = content .. " pln=" .. MathUtil_FindName( CityPlan, Asset_GetListItem( self, TaskAssetID.PARAMS, "plan" ) )
	elseif type == "DETAIL" then
		content = content .. " atr=" .. ( Asset_Get( self, TaskAssetID.ACTOR ):ToString() )
		content = content .. " loc=" .. String_ToStr( Asset_Get( self, TaskAssetID.LOCATION ), "name" )	
		content = content .. " dst=" .. String_ToStr( Asset_Get( self, TaskAssetID.DESTINATION ), "name" )
		content = content .. " beg=" .. g_Time:CreateDateDescByValue( Asset_Get( self, TaskAssetID.BEGIN_TIME ) )
	else
		content = content .. " atr=" .. ( Asset_Get( self, TaskAssetID.ACTOR ):ToString() )
		content = content .. " loc=" .. String_ToStr( Asset_Get( self, TaskAssetID.LOCATION ), "name" )	
		content = content .. " dst=" .. String_ToStr( Asset_Get( self, TaskAssetID.DESTINATION ), "name" )		
		content = content .. " stp=" .. MathUtil_FindName( TaskStep, self:GetStepType() )
		content = content .. " sts=" .. MathUtil_FindName( TaskStatus, Asset_Get( self, TaskAssetID.STATUS ) )
		content = content .. " pas=" .. g_Time:CalcDiffDayByDate( Asset_Get( self, TaskAssetID.BEGIN_TIME ) )
		content = content .. " prg=" .. Asset_Get( self, TaskAssetID.PROGRESS )
	end	
	local result = Asset_Get( self, TaskAssetID.RESULT )
	if result ~= TaskResult.UNKNOWN then
		content = content .. " rslt=" .. MathUtil_FindName( TaskResult, result )
	end
	return content
end


function Task:Remove()
	local type = Asset_Get( self, TaskAssetID.TYPE )
	
	--remove from all contributor
	Asset_ForeachList( self, TaskAssetID.CONTRIBUTORS, function ( value, chara )		
		Asset_RemoveListItem( chara, CharaAssetID.TASKS, self )
	end )
end

function Task:Load( data )
	self.id = data.id
end

function Task:IsStepFinished()
	local result = Asset_Get( self, TaskAssetID.RESULT )
	if result ~= TaskResult.UNKNOWN then
		return true
	end

	local status   = Asset_Get( self, TaskAssetID.STATUS )
	if status == TaskStatus.WAITING then
		return Asset_Get( self, TaskAssetID.DURATION ) <= 0
	end

	if status == TaskStatus.WORKING then
		if Asset_Get( self, TaskAssetID.PROGRESS ) >= Asset_Get( self, TaskAssetID.WORKLOAD ) then
			return true
		end
		return Asset_Get( self, TaskAssetID.DURATION ) <= 0
	end
	return false
end

function Task:GetStepType()
	local type = Asset_Get( self, TaskAssetID.TYPE )	
	local step = Scenario_GetData( "TASK_STEP_DATA" )[type]	
	if not step then
		error( "task [" .. MathUtil_FindName( TaskType, type ) .. "] no step data" )
		return
	end

	local stepIndex = Asset_Get( self, TaskAssetID.STEP )
	local taskStep = step[stepIndex]	
	return taskStep
end

function Task:ElpasedTime( time )
	local org = Asset_Get( self, TaskAssetID.DURATION )
	Asset_Reduce( self, TaskAssetID.DURATION, time )
end

function Task:Contribute( actor, contribution )
	local cur = Asset_GetListItem( self, TaskAssetID.CONTRIBUTORS, actor )
	cur = cur and cur + contribution or contribution
	Asset_SetListItem( self, TaskAssetID.CONTRIBUTORS, actor, cur )
	--InputUtil_Pause( actor.name, contribution, Asset_GetListItem( self, TaskAssetID.CONTRIBUTORS, actor ) )
end

function Task:DoTask( progress )
	local cur = Asset_Get( self, TaskAssetID.PROGRESS )
	cur = cur + progress
	Asset_Set( self, TaskAssetID.PROGRESS, cur )
	--Debug_Log( self:ToString() )
end

function Task:FinishStep()
	Asset_Set( self, TaskAssetID.PROGRESS, Asset_Get( self, TaskAssetID.WORKLOAD ) )
end

function Task:NextStep()
	if Asset_Get( self, TaskAssetID.PROGRESS ) >= Asset_Get( self, TaskAssetID.WORKLOAD ) then
		--finish task
		Asset_Set( self, TaskAssetID.STATUS, TaskStatus.WAITING )
		Asset_Set( self, TaskAssetID.DURATION, 0 )
		self:Update()
	end
end

function Task:Update()
	if self:IsStepFinished() == true then
		Asset_Set( self, TaskAssetID.STATUS, TaskStatus.RUNNING )
		Asset_Set( self, TaskAssetID.DURATION, 0 )
		--Asset_Set( self, TaskAssetID.PROGRESS, 0 )
		Asset_Plus( self, TaskAssetID.STEP, 1 )
		--InputUtil_Pause( self:ToString() .. " to next step" )
		return true
	end
	--print( self:ToString() .. " update=" .. Asset_Get( self, TaskAssetID.DURATION ) )
	return false
end