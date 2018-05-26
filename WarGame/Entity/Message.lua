-------------------------------------------

MessageAssetType = 
{
	BASE_ATTRIB = 1,
}

MessageAssetID = 
{
	TYPE      = 1,
	PARAMS    = 2,
}

MessageAssetAttrib = 
{
	type     = AssetAttrib_SetPointer( { id = MessageAssetID.TYPE,   type = MessageAssetType.BASE_ATTRIB } ),
	params   = AssetAttrib_SetDict   ( { id = MessageAssetID.PARAMS, type = MessageAssetType.BASE_ATTRIB } ),
}


-------------------------------------------


Message = class()

function Message:__init( ... )
	Entity_Init( self, EntityType.MESSAGE, MessageAssetAttrib )
end

function Message:Load( data )
	self.id = data.id
end