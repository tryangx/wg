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

	ACTOR        = 12,
	ACTOR_TYPE   = 13,
	GROUP        = 14,

	--location
	LOCATION     = 15,
	DESTINATION  = 16,
	--target
	PARAMS       = 17,

	--remain time to finish the task
	DURATION     = 30,
	WORKLOAD     = 31,
	STEP         = 32,
	
	CONTRIBUTORS = 40,

	--debug
	BEGIN_TIME   = 100,
	END_TIME     = 101,
}

TaskAssetAttrib = 
{
	type         = AssetAttrib_SetNumber ( { id = TaskAssetID.TYPE,       type = TaskAssetType.BASE_ATTRIB, enum = TaskType } ),
	status       = AssetAttrib_SetNumber ( { id = TaskAssetID.STATUS,     type = TaskAssetType.BASE_ATTRIB, enum = TaskStatus, default = TaskStatus.WAITING } ),
	
	actor        = AssetAttrib_SetPointer( { id = TaskAssetID.ACTOR,      type = TaskAssetType.BASE_ATTRIB } ),
	actortype    = AssetAttrib_SetNumber ( { id = TaskAssetID.ACTOR_TYPE, type = TaskAssetType.BASE_ATTRIB, enum = TaskActorType } ),	
	group        = AssetAttrib_SetPointer( { id = TaskAssetID.GROUP,      type = TaskAssetType.BASE_ATTRIB, setter = Entity_SetGroup } ),	
	
	location     = AssetAttrib_SetPointer( { id = TaskAssetID.LOCATION,   type = TaskAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	destination  = AssetAttrib_SetPointer( { id = TaskAssetID.DESTINATION,type = TaskAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	params       = AssetAttrib_SetList   ( { id = TaskAssetID.PARAMS,     type = TaskAssetType.BASE_ATTRIB } ),	

	duration     = AssetAttrib_SetNumber ( { id = TaskAssetID.DURATION,   type = TaskAssetType.BASE_ATTRIB, default = 0 } ),
	workload     = AssetAttrib_SetNumber ( { id = TaskAssetID.WORKLOAD,   type = TaskAssetType.BASE_ATTRIB, default = 0 } ),
	step         = AssetAttrib_SetNumber ( { id = TaskAssetID.STEP,       type = TaskAssetType.BASE_ATTRIB, default = 1 } ),
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
	if not cur then
		cur = contribution
	else
		cur = cur + contribution
	end
	Asset_SetListItem( self, TaskAssetID.CONTRIBUTORS, actor, cur )
	
	Asset_Plus( self, TaskAssetID.WORKLOAD, contribution )
end

function Task:ToString()
	local content = self.id .. " " .. MathUtil_FindName( TaskType, Asset_Get( self, TaskAssetID.TYPE ) )
	content = content .. " atr=" .. String_ToStr( Asset_Get( self, TaskAssetID.ACTOR ), "name" )
	content = content .. " loc=" .. String_ToStr( Asset_Get( self, TaskAssetID.LOCATION ), "name" )
	return content
end