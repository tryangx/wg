-------------------------------------------

SpyAssetType = 
{
	BASE_ATTRIB = 1,
}

SpyAssetID = 
{
	GRADE    = 1,
	INTELS   = 2,
}

SpyAssetAttrib = 
{
	grade    = AssetAttrib_SetNumber ( { id = SpyAssetID.GRADE,           type = SpyAssetType.BASE_ATTRIB, default = 0 } )
	intels   = AssetAttrib_SetNumber ( { id = SpyAssetID.INTELS,          type = SpyAssetType.BASE_ATTRIB, default = 0 } )
}


-------------------------------------------


Spy = class()

function Spy:__init( ... )
	Entity_Init( self, EntityType.INTEL, SpyAssetAttrib )
end

function Spy:Load( data )
	self.id = data.id
end

function Spy:ToString()
	local content = ""
	content = content .. MathUtil_FindName( IntelType, Asset_Get( self, SpyAssetID.TYPE ) ) 
	return content
end