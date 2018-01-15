WeaponAssetType = 
{
	BASE_ATTRIB = 1,
}

WeaponAssetID = 
{
	LEVEL    = 10,
	DAMAGE   = 11,
	RANGE    = 12,
	POWER    = 20,
	ACCURACY = 21,
	DURATION = 22,
}

WeaponAssetAttrib = 
{
	level      = AssetAttrib_SetNumber( { id = WeaponAssetID.LEVEL,       type = WeaponAssetType.BASE_ATTRIB } ),
	dmg        = AssetAttrib_SetNumber( { id = WeaponAssetID.DAMAGE,      type = WeaponAssetType.BASE_ATTRIB } ),
	pow        = AssetAttrib_SetNumber( { id = WeaponAssetID.POWER,       type = WeaponAssetType.BASE_ATTRIB } ),

	power      = AssetAttrib_SetNumber( { id = WeaponAssetID.POWER,       type = WeaponAssetType.BASE_ATTRIB } ),
	accuracy   = AssetAttrib_SetNumber( { id = WeaponAssetID.ACCURACY,    type = WeaponAssetType.BASE_ATTRIB } ),
	duration   = AssetAttrib_SetNumber( { id = WeaponAssetID.DURATION,    type = WeaponAssetType.BASE_ATTRIB } ),
}


-------------------------------------------


Weapon = class()

function Weapon:__init( ... )
	Entity_Init( self, EntityType.WEAPON, WeaponAssetAttrib )
end

function Weapon:Load( data )
	self.id = data.id
	self.name = data.name

	Asset_Set( self, WeaponAssetID.LEVEL,    data.level )
	Asset_Set( self, WeaponAssetID.DAMAGE,   WeaponDamageType[data.dmg] )
	Asset_Set( self, WeaponAssetID.RANGE,    WeaponRangeType[data.range] )

	Asset_Set( self, WeaponAssetID.POWER,    data.power )
	Asset_Set( self, WeaponAssetID.ACCURACY, data.accuracy )
	Asset_Set( self, WeaponAssetID.DURATION, data.duration )
end