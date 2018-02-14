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
	LEADER       = 102,
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
	chara        = AssetAttrib_SetPointer( { id = TroopAssetID.LEADER,        type = TroopAssetType.BASE_ATTRIB, setter = Entity_SetChara } ),
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
	statuses     = AssetAttrib_SetList   ( { id = TroopAssetID.STATUSES,      type = TroopAssetType.GROWTH_ATTRIB } ),

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
	Asset_Set( self, TroopAssetID.LEADER, nil )
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


function Troop:Starvation()
	local cur = Asset_GetListItem( self, TroopAssetID.STATUSES, TroopStatus.STARVATION )
	if not cur then cur = 1 end
	Asset_SetListItem( self, TroopAssetID.STATUSES, TroopStatus.STARVATION, cur + 1 )
	--morale reduce
	Asset_Reduce( self, TroopAssetID.MORALE, cur + cur + 5 )
	--InputUtil_Pause( self.id, self.name, "Starvation=" .. cur, "mor=" .. Asset_Get( self, TroopAssetID.MORALE ) )
end

function Troop:ConsumeFood( food )
	--print( self.id, self.name, "consume food=", food )
	local value = Asset_GetListItem( self, TroopAssetID.STATUSES, TroopStatus.STARVATION )
	if not value or value == 0 then return end
	
	value = math.floor( value * 0.5 )
	Asset_SetListItem( self, TroopAssetID.STATUSES, TroopStatus.STARVATION, value )	
end

function Troop:GetWeaponBy( name, value )
	local tableData = Asset_Get( self, TroopAssetID.TABLEDATA )
	return tableData and tableData:GetWeaponBy( name, value ) or nil
end

-------------------------------------------
-- Global

-----------------------------------
--  Remove troop from data
--    1. killed in combat
--    2. dismiss by command
--    3. sth. else
--
--  Don't care about the leader here.
--  It should be dealed with the situtation
--
function Troop_Remove( troop )
	--remove from list in corps
	local corps = Asset_Get( troop, TroopAssetID.CORPS )
	if corps then Asset_RemoveListItem( corps, CorpsAssetID.TROOP_LIST, troop ) end

	--remove entity
	Entity_Remove( troop )
end

function Troop_GetConsumeFood( troop )
	local table = Asset_Get( troop, TroopAssetID.TABLEDATA )
	return table and table.consume.FOOD
end