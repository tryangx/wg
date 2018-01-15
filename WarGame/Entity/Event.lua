EventAssetType = 
{
	BASE_ATTRIB      = 1,
}

EventAssetID = 
{
	TYPE       = 10,
	TARGET     = 11,
	TRIGGER    = 20,
	EFFECTS    = 30,
}

EventAssetAttrib = 
{
	type     = AssetAttrib_SetNumber( { id = EventAssetID.TYPE,       type = EventAssetType.BASE_ATTRIB, enum = EventType } ),
	target   = AssetAttrib_SetNumber( { id = EventAssetID.TARGET,     type = EventAssetType.BASE_ATTRIB, default = "NONE" } ),
	trigger  = AssetAttrib_SetList  ( { id = EventAssetID.TRIGGER,    type = EventAssetType.BASE_ATTRIB } ),
	effects  = AssetAttrib_SetList  ( { id = EventAssetID.EFFECTS,    type = EventAssetType.BASE_ATTRIB } ),
}

-------------------------------------------


Event = class()

function Event:__init( ... )
	Entity_Init( self, EntityType.EVENT, EventAssetAttrib )
end

function Event:Load( data )
	self.id = data.id

	Asset_CopyDict( self, EventAssetID.TRIGGER,   data.trigger )
	Asset_CopyDict( self, EventAssetID.EFFECTS,   data.effects )
end
