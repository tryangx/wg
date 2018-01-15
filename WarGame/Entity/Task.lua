TaskAssetType = 
{
	BASE_ATTRIB = 1,
}

TaskAssetID = 
{
	TYPE         = 10,
	ACTOR        = 11,
	ACTOR_TYPE   = 12,
	TARGET       = 13,
	LOCATION     = 14,
	PREREQUISITE = 15,
	STATUS       = 20,
	DURATION     = 21,
	ELAPSED      = 22,
	VALUES       = 23,
}

TaskAssetAttrib = 
{
	type      = AssetAttrib_SetNumber ( { id = TaskAssetID.TYPE,       type = TaskAssetType.BASE_ATTRIB, enum = TaskType } ),
	actor     = AssetAttrib_SetPointer( { id = TaskAssetID.ACTOR,      type = TaskAssetType.BASE_ATTRIB } ),
	actortype = AssetAttrib_SetNumber ( { id = TaskAssetID.ACTOR_TYPE, type = TaskAssetType.BASE_ATTRIB } ),	
	target    = AssetAttrib_SetPointer( { id = TaskAssetID.TARGET,     type = TaskAssetType.BASE_ATTRIB } ),	
	location  = AssetAttrib_SetPointer( { id = TaskAssetID.LOCATION,   type = TaskAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	prerequisite = AssetAttrib_SetNumber ( { id = TaskAssetID.PREREQUISITE, type = TaskAssetType.BASE_ATTRIB } ),

	status    = AssetAttrib_SetNumber ( { id = TaskAssetID.STATUS,     type = TaskAssetType.BASE_ATTRIB, enum = TaskStatus, default = TaskStatus.PREPARE } ),
	duration  = AssetAttrib_SetPointer( { id = TaskAssetID.DURATION,   type = TaskAssetType.BASE_ATTRIB, default = 0 } ),	
	elapsed   = AssetAttrib_SetPointer( { id = TaskAssetID.ELAPSED,    type = TaskAssetType.BASE_ATTRIB } ),	
	values    = AssetAttrib_SetList   ( { id = TaskAssetID.VALUES,     type = TaskAssetType.BASE_ATTRIB } ),	
}


-------------------------------------------


Task = class()

function Task:__init( ... )
	Entity_Init( self, EntityType.TASK, TaskAssetAttrib )
end

function Task:Load( data )
	self.id = data.id
end


-------------------------------------------

function Task_InitActorType( task )
	local type = Asset_Get( task, TaskAssetID.TYPE )
	if type == TaskType.ESTABLISH_CORPS
		or type == TaskType.REINFORCE_CORPS
		or type == TaskType.DISMISS_CORPS
		or type == TaskType.TRAIN_CORPS
		or type == TaskType.UPGRADE_CORPS
		or type == TaskType.DISPATCH_CORPS
		or type == TaskType.HARASS_CITY
		or type == TaskType.ATTACK_CITY
		then
		Asset_Set( task, TaskAssetID.ACTOR_TYPE, TaskActorType.CORPS )
	else
		Asset_Set( task, TaskAssetID.ACTOR_TYPE, TaskActorType.CHARA )
	end
end
