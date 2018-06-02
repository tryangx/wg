-------------------------------------------

IntelAssetType = 
{
	BASE_ATTRIB = 1,
}

IntelAssetID = 
{
	TYPE          = 1,
	SOURCE        = 2,
	PARAMS        = 3,
	SPYS_DURATION = 4,
}

IntelAssetAttrib = 
{
	type     = AssetAttrib_SetPointer( { id = IntelAssetID.TYPE,   type = IntelAssetType.BASE_ATTRIB } ),
	source   = AssetAttrib_SetPointer( { id = IntelAssetID.SOURCE, type = IntelAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	params   = AssetAttrib_SetDict   ( { id = IntelAssetID.PARAMS, type = IntelAssetType.BASE_ATTRIB } ),
	spy_durs = AssetAttrib_SetDict   ( { id = IntelAssetID.SPYS_DURATION,   type = IntelAssetType.BASE_ATTRIB } ),
}


-------------------------------------------


Intel = class()

function Intel:__init( ... )
	Entity_Init( self, EntityType.INTEL, IntelAssetAttrib )
end

function Intel:Load( data )
	self.id = data.id
end

function Intel:ToString()
	local content = ""
	content = content .. MathUtil_FindName( IntelType, Asset_Get( self, IntelAssetID.TYPE ) ) 
	return content
end