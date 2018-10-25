EventAssetType = 
{
	BASE_ATTRIB      = 1,
}

EventAssetID = 
{
	TYPE       = 10,
	TARGET     = 11,
	TRIGGER    = 20,
	EFFECT     = 30,
	STORYBOARD = 31,
}

EventAssetAttrib = 
{
	type     = AssetAttrib_SetNumber( { id = EventAssetID.TYPE,       type = EventAssetType.BASE_ATTRIB, enum = EventType } ),
	target   = AssetAttrib_SetNumber( { id = EventAssetID.TARGET,     type = EventAssetType.BASE_ATTRIB, default = "NONE" } ),

	trigger  = AssetAttrib_SetList  ( { id = EventAssetID.TRIGGER,    type = EventAssetType.BASE_ATTRIB } ),
	effect   = AssetAttrib_SetList  ( { id = EventAssetID.EFFECT,    type = EventAssetType.BASE_ATTRIB } ),
	STORYBOARD = AssetAttrib_SetList  ( { id = EventAssetID.STORYBOARD,    type = EventAssetType.BASE_ATTRIB } ),
}

-------------------------------------------

Event = class()

function Event:__init( ... )
	Entity_Init( self, EntityType.EVENT, EventAssetAttrib )
end

function Event:Load( data )
	self.id = data.id

	Asset_CopyDict( self, EventAssetID.TRIGGER,   data.trigger )
	Asset_CopyDict( self, EventAssetID.EFFECT,    data.effect )
	Asset_CopyDict( self, EventAssetID.STORYBOARD,    data.storyboard )
end
