-----------------------------------------------------
--
-----------------------------------------------------

TroopAssetType = 
{
	BASE_ATTRIB    = 1,
	GROWTH_ATTRIB  = 2,
	COMBAT_ATTRIB  = 3,
}

TroopAssetID = 
{
	--base
	CORPS        = 101,
	OFFICER      = 102,
	POTENTIAL    = 105,	
	TABLEDATA    = 106,

	-------------------------------
	--growth
	LEVEL        = 201,
	EXP          = 202,
	MORALE       = 203,
	ORGANIZATION = 204,
	CONVEYANCE   = 205,
	MAX_SOLDIER  = 206,
	TIRENESS     = 210,
	TRAINING     = 211,
	HONOR        = 212, --TBD, kill how many soldier?
	GLORY        = 213, --TBD, kill how many troop?	

	SKILLS       = 220,
	STATUSES     = 221,

	--Combat
	SOLDIER      = 300,
	ABILITY      = 310,	
	ARMOR        = 320,	--anti physical damage
	TOUGHNESS    = 321,	--anti tactic/mental damage
	MOVEMENT     = 330,
	WEAPONS      = 340,
}

TroopAssetAttrib =
{
	corps        = AssetAttrib_SetPointer( { id = TroopAssetID.CORPS,         type = TroopAssetType.BASE_ATTRIB, setter = Entity_SetCorps } ),
	chara        = AssetAttrib_SetPointer( { id = TroopAssetID.OFFICER,       type = TroopAssetType.BASE_ATTRIB, setter = Entity_SetChara } ),
	potential    = AssetAttrib_SetNumber ( { id = TroopAssetID.POTENTIAL,     type = TroopAssetType.BASE_ATTRIB, min = 0, max = 100 } ),	
	tabledata    = AssetAttrib_SetPointer( { id = TroopAssetID.TABLEDATA,     type = TroopAssetType.BASE_ATTRIB, setter = Table_SetTroop } ),
	
	--growth
	level        = AssetAttrib_SetNumber ( { id = TroopAssetID.LEVEL,         type = TroopAssetType.GROWTH_ATTRIB, min = 0, max = 10 } ),
	exp          = AssetAttrib_SetNumber ( { id = TroopAssetID.EXP,           type = TroopAssetType.GROWTH_ATTRIB, min = 0, max = 9999 } ),
	morale       = AssetAttrib_SetNumber ( { id = TroopAssetID.MORALE,        type = TroopAssetType.GROWTH_ATTRIB, min = 0, max = 100 } ),
	organization = AssetAttrib_SetNumber ( { id = TroopAssetID.ORGANIZATION,  type = TroopAssetType.GROWTH_ATTRIB, min = 0 } ),
	maxsoldier   = AssetAttrib_SetNumber ( { id = TroopAssetID.MAX_SOLDIER,   type = TroopAssetType.GROWTH_ATTRIB, min = 0 } ),
	conveyance   = AssetAttrib_SetNumber ( { id = TroopAssetID.CONVEYANCE,    type = TroopAssetType.GROWTH_ATTRIB, enum = CONVEYANCEType } ),
	tireness     = AssetAttrib_SetNumber ( { id = TroopAssetID.TIRENESS,      type = TroopAssetType.GROWTH_ATTRIB, min = 0, max = 100 } ),
	training     = AssetAttrib_SetNumber ( { id = TroopAssetID.TRAINING,      type = TroopAssetType.GROWTH_ATTRIB, min = 0, max = 200 } ),
	honor        = AssetAttrib_SetNumber ( { id = TroopAssetID.HONOR,         type = TroopAssetType.GROWTH_ATTRIB, } ),
	glory        = AssetAttrib_SetNumber ( { id = TroopAssetID.GLORY,         type = TroopAssetType.GROWTH_ATTRIB, } ),
	
	skills       = AssetAttrib_SetPointerList ( { id = TroopAssetID.SKILLS,   type = TroopAssetType.GROWTH_ATTRIB, setter = Entity_SetSkill } ),
	statuses     = AssetAttrib_SetDict   ( { id = TroopAssetID.STATUSES,      type = TroopAssetType.GROWTH_ATTRIB } ),

	--ability
	armor        = AssetAttrib_SetNumber ( { id = TroopAssetID.ARMOR,         type = TroopAssetType.COMBAT_ATTRIB, min = 0, max = 1000 } ),
	toughness    = AssetAttrib_SetNumber ( { id = TroopAssetID.TOUGHNESS,     type = TroopAssetType.COMBAT_ATTRIB, min = 0, max = 1000 } ),
	movement     = AssetAttrib_SetNumber ( { id = TroopAssetID.MOVEMENT,      type = TroopAssetType.COMBAT_ATTRIB, min = 0, max = 1000 } ),
	soldier      = AssetAttrib_SetNumber ( { id = TroopAssetID.SOLDIER,       type = TroopAssetType.COMBAT_ATTRIB, min = 0 } ),
	weapons      = AssetAttrib_SetList   ( { id = TroopAssetID.WEAPONS,       type = TroopAssetType.COMBAT_ATTRIB } ),
}


-------------------------------------------


Troop = class()

function Troop:__init()
	Entity_Init( self, EntityType.TROOP, TroopAssetAttrib )
end

function Troop:ToString( type )
	local content = "[" .. self.name .. "](" .. self.id .. ")"

	if type == "COMBAT" then
		content = content .. ( self._combatSide and ( self._combatSide == CombatSide.ATTACKER and "-ATK" or "-DEF" ) or "" )		
	elseif type == "SIMPLE" then

	elseif type == "BREIF" then
		content = content .. " n=" .. Asset_Get( self, TroopAssetID.SOLDIER )
	else
		content = content .. " n=" .. Asset_Get( self, TroopAssetID.SOLDIER )
		local corps = Asset_Get( self, TroopAssetID.CORPS )
		if corps then
			content = content .. " corp=" .. corps.name
			local group = corps and Asset_Get( corps, CorpsAssetID.GROUP ) or nil
			if group then
				content = content .. " grp=" .. group.name
			end
		end
	end
	return content
end

function Troop:LoadFromTable( tableData )
	self.name = tableData.name

	Asset_Set( self, TroopAssetID.TABLEDATA, tableData )

	Asset_Set( self, TroopAssetID.POTENTIAL, tableData.potential )

	Asset_Set( self, TroopAssetID.LEVEL, 1 )
	Asset_Set( self, TroopAssetID.EXP, 0 )
	Asset_Set( self, TroopAssetID.MORALE, 100 )
	Asset_Set( self, TroopAssetID.ORGANIZATION, Asset_Get( self, TroopAssetID.SOLDIER ) )	
	Asset_Set( self, TroopAssetID.CONVEYANCE, tableData.conveyance )

	Asset_Set( self, TroopAssetID.ARMOR, 	 tableData.armor )
	Asset_Set( self, TroopAssetID.TOUGHNESS, tableData.toughness )
	Asset_Set( self, TroopAssetID.MOVEMENT,  tableData.movement )
end

function Troop:TestGenerate()
	Asset_Set( self, TroopAssetID.CORPS, nil )
	Asset_Set( self, TroopAssetID.OFFICER, nil )
	Asset_Set( self, TroopAssetID.POTENTIAL, Random_GetInt( TroopAssetAttrib.potential.min, TroopAssetAttrib.potential.max ) )	
	Asset_Set( self, TroopAssetID.SOLDIER, Random_GetInt( 1, 4 ) * 500 )
	Asset_Set( self, TroopAssetID.MAX_SOLDIER, Asset_Get( self, TroopAssetID.SOLDIER ) )
	
	Asset_Set( self, TroopAssetID.LEVEL, 0 )
	Asset_Set( self, TroopAssetID.EXP, 0 )
	Asset_Set( self, TroopAssetID.MORALE, 0 )
	Asset_Set( self, TroopAssetID.ORGANIZATION, 0 )
	Asset_Set( self, TroopAssetID.CONVEYANCE, 0 )

	Asset_Set( self, TroopAssetID.ARMOR, 100 )
	Asset_Set( self, TroopAssetID.TOUGHNESS, 0 )
	Asset_Set( self, TroopAssetID.MOVEMENT, 0 )

end

function Troop:Starve()
	local cur = Asset_GetDictItem( self, TroopAssetID.STATUSES, TroopStatus.STARVATION )
	if not cur then cur = 1 end
	Asset_SetDictItem( self, TroopAssetID.STATUSES, TroopStatus.STARVATION, math.ceil( cur * 1.5 ) )
end

function Troop:EatFood( food )
	local value = Asset_GetDictItem( self, TroopAssetID.STATUSES, TroopStatus.STARVATION )
	if not value or value == 0 then return end
	Asset_SetDictItem( self, TroopAssetID.STATUSES, TroopStatus.STARVATION, math.floor( value * 0.5 ) )
end

function Troop:GetWeaponBy( name, value )
	local tableData = Asset_Get( self, TroopAssetID.TABLEDATA )
	return tableData and tableData:GetWeaponBy( name, value ) or nil
end
