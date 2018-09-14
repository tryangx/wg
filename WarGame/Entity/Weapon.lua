--[[
-- Weapon 1.0
--
--   Properties:
--   #Level
--     measure the grade of the weapon, the soldier can master the weapon with proficiency limitation
--   #Weight
--     measure the kinect damages, against the toughness
--   #Sharpness
--     measure the pierce damages, against the armor
--   #Attributes
--     measure other additions
--         heat real-damages
--         poison damages etc
--   #Duration
--     measure the times weapon can used in the duel, reserved for extension
--   #Material
--     measure the supply cost for the weapon, reserved for extension
--   #Range
--     measure the attack-range, the longer range will attack first, reserved for extension
--   #Ballistic
--     measure the wepaon Closed, Long, Flat fire, Projectile, reserved for extension
--
--]]

WeaponAssetType = 
{
	BASE_ATTRIB = 1,
}

WeaponAssetID = 
{
	LEVEL      = 10,
	WEIGHT     = 11,
	SHARPNESS  = 12,
	ATTRIBUTES = 13,
	
	MATERIAL   = 21,
	RANGE      = 22,
	BALLISTIC  = 23,
}

WeaponAssetAttrib = 
{
	level      = AssetAttrib_SetNumber( { id = WeaponAssetID.LEVEL,       type = WeaponAssetType.BASE_ATTRIB } ),
	weight     = AssetAttrib_SetNumber( { id = WeaponAssetID.WEIGHT,      type = WeaponAssetType.BASE_ATTRIB } ),
	sharpness  = AssetAttrib_SetNumber( { id = WeaponAssetID.SHARPNESS,   type = WeaponAssetType.BASE_ATTRIB } ),
	attributes = AssetAttrib_SetList  ( { id = WeaponAssetID.ATTRIBUTES,  type = WeaponAssetType.BASE_ATTRIB } ),
	
	material   = AssetAttrib_SetNumber( { id = WeaponAssetID.MATERIAL,    type = WeaponAssetType.BASE_ATTRIB } ),
	range      = AssetAttrib_SetNumber( { id = WeaponAssetID.RANGE,       type = WeaponAssetType.BASE_ATTRIB } ),
	ballistic  = AssetAttrib_SetNumber( { id = WeaponAssetID.BALLISTIC,   type = WeaponAssetType.BASE_ATTRIB } ),
}


-------------------------------------------


Weapon = class()

function Weapon:__init( ... )
	Entity_Init( self, EntityType.WEAPON, WeaponAssetAttrib )
end

function Weapon:Load( data )
	self.id = data.id
	self.name = data.name

	Asset_Set( self, WeaponAssetID.LEVEL,     data.level )
	Asset_Set( self, WeaponAssetID.WEIGHT,    data.weight )
	Asset_Set( self, WeaponAssetID.SHARPNESS, data.sharpness )
	Asset_CopyList( self, WeaponAssetID.ATTRIBUTES,   data.attributes )

	Asset_Set( self, WeaponAssetID.RANGE,    WeaponRangeType[data.range] )
	Asset_Set( self, WeaponAssetID.BALLISTIC,WeaponBallisticType[data.ballistic] )
	Asset_Set( self, WeaponAssetID.MATERIAL, data.material )
end