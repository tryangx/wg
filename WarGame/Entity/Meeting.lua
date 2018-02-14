MeetingAssetType = 
{
	BASE_ATTRIB = 1,
}

MeetingAssetID = 
{
	LOCATION     = 1,
	TOPIC        = 2,
	SUPERIOR     = 3,
	PARTICIPANTS = 4,
	TARGET       = 5,
}

MeetingAssetAttrib = 
{
	loc      = AssetAttrib_SetPointer( { id = MeetingAssetID.LOCATION,    type = MeetingAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	topic    = AssetAttrib_SetNumber ( { id = MeetingAssetID.TOPIC,       type = MeetingAssetType.BASE_ATTRIB, enum = MeetingTopic, default = MeetingTopic.NONE } ),
	superior = AssetAttrib_SetPointer( { id = MeetingAssetID.SUPERIOR,    type = MeetingAssetType.BASE_ATTRIB, setter = Entity_SetChara } ),
	participants = AssetAttrib_SetPointerList( { id = MeetingAssetID.PARTICIPANTS, type = MeetingAssetType.BASE_ATTRIB, setter = Entity_SetChara } ),
	target   = AssetAttrib_SetPointer( { id = MeetingAssetID.TARGET,      type = MeetingAssetType.BASE_ATTRIB } ),
}


-------------------------------------------


Meeting = class()

function Meeting:__init( ... )
	Entity_Init( self, EntityType.MEETING, MeetingAssetAttrib )
end

function Meeting:Load( data )
	self.id = data.id

	Asset_Set( self, MeetingAssetID.LOCATION,     data.loction )
	Asset_Set( self, MeetingAssetID.TOPIC,        data.topic )
	Asset_Set( self, MeetingAssetID.PARTICIPANTS, data.participants )
end