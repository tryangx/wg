MeetingAssetType = 
{
	BASE_ATTRIB = 1,
}

MeetingAssetID = 
{
	LOCATION     = 1,
	TOPIC        = 2,

	PARTICIPATNS = 2,
}

MeetingAssetAttrib = 
{
	loc      = AssetAttrib_SetPointer( { id = MeetingAssetID.LOCATION,    type = MeetingAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	topic    = AssetAttrib_SetNumber ( { id = MeetingAssetID.TOPIC,       type = MeetingAssetType.BASE_ATTRIB, enum = MeetingTopic } ),
	
	participants = AssetAttrib_SetPointerList( { id = MeetingAssetID.PARTICIPATNS,       type = MeetingAssetType.BASE_ATTRIB, setter = Entity_SetChara } ),

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
	Asset_Set( self, MeetingAssetID.PARTICIPATNS, data.participants )
end