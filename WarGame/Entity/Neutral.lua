-------------------------------------------

NeutralAssetType = 
{
	BASE_ATTRIB = 1,
}

NeutralAssetID = 
{
	TYPE        = 1,
	TARGET      = 2,
}

NeutralAssetAttrib = 
{
	type     = AssetAttrib_SetNumber ( { id = NeutralAssetID.TYPE,   type = NeutralAssetType.BASE_ATTRIB } ),
	target   = AssetAttrib_SetPointer( { id = NeutralAssetID.TARGET, type = NeutralAssetType.BASE_ATTRIB } ),
}


-------------------------------------------


Neutral = class()

function Neutral:__init( ... )
	Entity_Init( self, EntityType.NEUTRAL, NeutralAssetAttrib )
end

function Neutral:Load( data )
	self.id = data.id
	Asset_Set( )
end

function Neutral:ToString()
	local content = ""
	content = content .. MathUtil_FindName( NeutralType, Asset_Get( self, NeutralAssetID.TYPE ) ) 
	return content
end