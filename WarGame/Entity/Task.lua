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
	STEP         = 12,

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
	status       = AssetAttrib_SetNumber ( { id = TaskAssetID.STATUS,     type = TaskAssetType.BASE_ATTRIB, enum = TaskStatus, default = TaskStatus.WAITING } ),
	step         = AssetAttrib_SetNumber ( { id = TaskAssetID.STEP,       type = TaskAssetType.BASE_ATTRIB, default = 1 } ),
	
	actor        = AssetAttrib_SetPointer( { id = TaskAssetID.ACTOR,      type = TaskAssetType.BASE_ATTRIB } ),
	actortype    = AssetAttrib_SetNumber ( { id = TaskAssetID.ACTOR_TYPE, type = TaskAssetType.BASE_ATTRIB, enum = TaskActorType } ),	
	group        = AssetAttrib_SetPointer( { id = TaskAssetID.GROUP,      type = TaskAssetType.BASE_ATTRIB, setter = Entity_SetGroup } ),	
	
	location     = AssetAttrib_SetPointer( { id = TaskAssetID.LOCATION,   type = TaskAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	destination  = AssetAttrib_SetPointer( { id = TaskAssetID.DESTINATION,type = TaskAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	params       = AssetAttrib_SetList   ( { id = TaskAssetID.PARAMS,     type = TaskAssetType.BASE_ATTRIB } ),	

	duration     = AssetAttrib_SetNumber ( { id = TaskAssetID.DURATION,   type = TaskAssetType.BASE_ATTRIB, default = 0 } ),
	workload     = AssetAttrib_SetNumber ( { id = TaskAssetID.WORKLOAD,   type = TaskAssetType.BASE_ATTRIB, default = 0 } ),	
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
	return Asset_Get( self, TaskAssetID.DURATION ) <= 0
end

function Task:ElpasedTime( time )
	local org = Asset_Get( self, TaskAssetID.DURATION )
	Asset_Reduce( self, TaskAssetID.DURATION, time )
end

function Task:Contribute( actor, contribution )
	local cur = Asset_GetListItem( self, TaskAssetID.CONTRIBUTORS, actor )
	cur = cur and cur + contribution or contribution
	Asset_SetListItem( self, TaskAssetID.CONTRIBUTORS, actor, cur )
end

function Task:Do( progress )
	local cur = Asset_Get( task, TaskAssetID.PROGRESS )
	cur = cur + progress
	Asset_Set( task, TaskAssetID.PROGRESS, cur )

	if cur >= 100 then
		--finish task
		Asset_Set( task, TaskAssetID.DURATION, 0 )
		self:Update()
	end
end

function Task:ToString( type )	
	local content = self.id .. " " .. MathUtil_FindName( TaskType, Asset_Get( self, TaskAssetID.TYPE ) )
	if type == "SIMPLE" then
	else
		content = content .. " atr=" .. String_ToStr( Asset_Get( self, TaskAssetID.ACTOR ), "name" )
		content = content .. " loc=" .. String_ToStr( Asset_Get( self, TaskAssetID.LOCATION ), "name" )
	end
	return content
end

function Task:Update()
	if self:IsStepFinished() == true then
		Asset_Set( self, TaskAssetID.STATUS, TaskStatus.WAITING )
		Asset_Plus( self, TaskAssetID.STEP, 1 )
		print( self:ToString() .. " to next step" )
		return true
	end
	--print( self:ToString() .. " update=" .. Asset_Get( self, TaskAssetID.DURATION ) )
	return false
end