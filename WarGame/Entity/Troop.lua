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
	TABLEDATA    = 106,

	-------------------------------
	--growth
	POTENTIAL    = 200,
	CONVEYANCE   = 201,
	MAX_SOLDIER  = 202,	

	SKILLS       = 220,
	STATUSES     = 221,

	--Combat
	SOLDIER      = 300,	
	TIRENESS     = 301,		
	MORALE       = 302,
	ORGANIZATION = 303,
	LEVEL        = 304,
	
	ARMOR        = 320,	--anti physical damage
	TOUGHNESS    = 321,	--anti tactic/mental damage

	MOVEMENT     = 330,
	WEAPONS      = 340,
}

TroopAssetAttrib =
{
	corps        = AssetAttrib_SetPointer( { id = TroopAssetID.CORPS,         type = TroopAssetType.BASE_ATTRIB, setter = Entity_SetCorps } ),
	chara        = AssetAttrib_SetPointer( { id = TroopAssetID.OFFICER,       type = TroopAssetType.BASE_ATTRIB, setter = Entity_SetChara } ),	
	tabledata    = AssetAttrib_SetPointer( { id = TroopAssetID.TABLEDATA,     type = TroopAssetType.BASE_ATTRIB, setter = Table_SetTroop } ),
	
	--growth
	potential    = AssetAttrib_SetNumber ( { id = TroopAssetID.POTENTIAL,     type = TroopAssetType.BASE_ATTRIB, min = 0, max = 100 } ),
	maxsoldier   = AssetAttrib_SetNumber ( { id = TroopAssetID.MAX_SOLDIER,   type = TroopAssetType.GROWTH_ATTRIB, min = 0 } ),
	conveyance   = AssetAttrib_SetNumber ( { id = TroopAssetID.CONVEYANCE,    type = TroopAssetType.GROWTH_ATTRIB, enum = CONVEYANCEType } ),
	
	skills       = AssetAttrib_SetPointerList ( { id = TroopAssetID.SKILLS,   type = TroopAssetType.GROWTH_ATTRIB, setter = Entity_SetSkill } ),
	statuses     = AssetAttrib_SetDict   ( { id = TroopAssetID.STATUSES,      type = TroopAssetType.GROWTH_ATTRIB } ),
	
	soldier      = AssetAttrib_SetNumber ( { id = TroopAssetID.SOLDIER,       type = TroopAssetType.COMBAT_ATTRIB, min = 0 } ),
	tireness     = AssetAttrib_SetNumber ( { id = TroopAssetID.TIRENESS,      type = TroopAssetType.GROWTH_ATTRIB, min = 0, max = 100 } ),
	level        = AssetAttrib_SetNumber ( { id = TroopAssetID.LEVEL,         type = TroopAssetType.GROWTH_ATTRIB, min = 0, max = 20 } ),
	morale       = AssetAttrib_SetNumber ( { id = TroopAssetID.MORALE,        type = TroopAssetType.GROWTH_ATTRIB, min = 0, max = 100 } ),
	organization = AssetAttrib_SetNumber ( { id = TroopAssetID.ORGANIZATION,  type = TroopAssetType.GROWTH_ATTRIB, min = 0 } ),	

	armor        = AssetAttrib_SetNumber ( { id = TroopAssetID.ARMOR,         type = TroopAssetType.COMBAT_ATTRIB, min = 0, max = 1000 } ),
	toughness    = AssetAttrib_SetNumber ( { id = TroopAssetID.TOUGHNESS,     type = TroopAssetType.COMBAT_ATTRIB, min = 0, max = 1000 } ),	
		
	weapons      = AssetAttrib_SetList   ( { id = TroopAssetID.WEAPONS,       type = TroopAssetType.COMBAT_ATTRIB } ),
	movement     = AssetAttrib_SetNumber ( { id = TroopAssetID.MOVEMENT,      type = TroopAssetType.COMBAT_ATTRIB, min = 0, max = 1000 } ),
}


-------------------------------------------


Troop = class()

function Troop:__init()
	Entity_Init( self, EntityType.TROOP, TroopAssetAttrib )
end

function Troop:ToString( type )
	local content = "[" .. self.name .. "](" .. self.id .. ")"
	
	content = content .. ( self:GetCombatData( TroopCombatData.SIDE ) and ( self:GetCombatData( TroopCombatData.SIDE ) == CombatSide.ATTACKER and "-ATK" or "-DEF" ) or "" )

	if type == "COMBAT" or type == "COMBAT_ALL" then
		content = content .. " org=" .. Asset_Get( self, TroopAssetID.ORGANIZATION )
		content = content .. " mor=" .. Asset_Get( self, TroopAssetID.MORALE )
		content = content .. " n=" .. Asset_Get( self, TroopAssetID.SOLDIER ) .. "/" .. Asset_Get( self, TroopAssetID.MAX_SOLDIER )
	end
	if type == "COMBAT_DATA" or type == "COMBAT_ALL" then
		if self._combatDatas then
			for type, v in pairs( self._combatDatas ) do
				if typeof( v ) == "boolean" then
				elseif typeof( v ) == "table" then
				elseif typeof( v ) == "object" then
				else
					content = content .. " " .. MathUtil_FindName( TroopCombatData, type ) .. "=" .. v
				end
			end
		end
	end
		
	if type == "SIMPLE" then

	elseif type == "BREIF" then
		content = content .. " n=" .. Asset_Get( self, TroopAssetID.SOLDIER )
	elseif type == "ALL" then
		content = content .. " n=" .. Asset_Get( self, TroopAssetID.SOLDIER )
		content = content .. " exp=" .. Asset_GetDictItem( self, TroopAssetID.STATUSES, TroopStatus.EXP )
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
	Asset_Set( self, TroopAssetID.MORALE, 100 )
	Asset_Set( self, TroopAssetID.ORGANIZATION, Asset_Get( self, TroopAssetID.SOLDIER ) )	
	Asset_Set( self, TroopAssetID.CONVEYANCE, tableData.conveyance )

	Asset_Set( self, TroopAssetID.ARMOR, 	 tableData.armor )
	Asset_Set( self, TroopAssetID.TOUGHNESS, tableData.toughness )
	Asset_Set( self, TroopAssetID.MOVEMENT,  tableData.movement )
end

-------------------------------------

function Troop:GetMaxMorale()	
	local maxMorale = 50
	maxMorale = maxMorale + Asset_Get( self, TroopAssetID.LEVEL ) * 5
	maxMorale = maxMorale + math.ceil( self:GetStatus( TroopStatus.TRAINING ) * 0.2 )
	--todo, leader's ability
	return maxMorale
end

function Troop:GetMaxOrg()
	local soldier = Asset_Get( self, TroopAssetID.SOLDIER )
	local rate   = 50
	rate = rate + math.min( 100, self:GetStatus( TroopStatus.TRAINING ) )
	rate = rate + math.min( 0, Asset_Get( self, TroopAssetID.LEVEL ) * 10 )
	--todo, leader's ability
	local maxOrg = soldier * rate
	return math.ceil( maxOrg )
end

function Troop:GetWeaponBy( name, value )
	local tableData = Asset_Get( self, TroopAssetID.TABLEDATA )
	return tableData and tableData:GetWeaponBy( name, value ) or nil
end

function Troop:GetWeaponByTask( taskType )
	local tableData = Asset_Get( self, TroopAssetID.TABLEDATA )
		if not tableData then error( "1") return end

	local weapon
	if taskType == CombatTask.SHOOT then
		weapon = self:GetWeaponBy( "range", WeaponRangeType.MISSILE )	
	
	elseif taskType == CombatTask.CHARGE then
		weapon = self:GetWeaponBy( "range", WeaponRangeType.LONG )
	
	elseif taskType == CombatTask.FIGHT then		
		weapon = self:GetWeaponBy( "range", WeaponRangeType.CLOSE )
		if not weapon then weapon = self:GetWeaponBy( "range", WeaponRangeType.LONG ) end	

	elseif taskType == CombatTask.DESTROY then
		weapon = self:GetWeaponBy( "dmg", WeaponDamageType.FORTIFIED )

	end
	return weapon
end

function Troop:GetCombatData( type )
	if not self._combatDatas then return end
	return self._combatDatas[type]
end

function Troop:SetCombatData( type, value )
	if self._combatDatas then
		self._combatDatas[type] = value
	else
		--error( "not in combat" )
	end
end

function Troop:JoinCombat( ... )
	self._combatDatas = {}
end

function Troop:LeaveCombat( ... )
	self._combatDatas = nil
end

-------------------------------------

function Troop:GetStatus( status )
	local value = Asset_GetDictItem( self, TroopAssetID.STATUSES, status )
	if status >= TroopStatus.ATTRIBUTE_STATUS then
		if not value then value = 0 end
	end
	return value
end

function Troop:SetStatus( status, value )
	Asset_SetDictItem( self, TroopAssetID.STATUSES, status, value )
end

function Troop:SetOfficer( officer )
	Asset_Set( self, TroopAssetID.OFFICER, officer )
end

-------------------------------------

function Troop:Starve()
	local cur = self:GetStatus( TroopStatus.STARVATION )
	if not cur then cur = 1 end
	self:SetStatus( TroopStatus.STARVATION, math.ceil( cur * 1.5 ) )
end

function Troop:EatFood( food )
	local value = self:GetStatus( TroopStatus.STARVATION )
	if not value or value == 0 then return end
	self:SetStatus( TroopStatus.STARVATION, math.floor( value * 0.5 ) )
end

function Troop:Release()
	self:SetStatus( TroopStatus.SURRENDER )
	local officer = Asset_Get( self, TroopAssetID.OFFICER )
	if officer then
		officer:SetStatus( CharaStatus.SURRENDER )
	end
end

function Troop:Surrender()
	self:SetStatus( TroopStatus.SURRENDER, 1 )
	local officer = Asset_Get( self, TroopAssetID.OFFICER )
	if officer then
		officer:SetStatus( CharaStatus.SURRENDER, 1 )
	end
end

function Troop:KillSoldier( number )
	local exp = self:GetStatus( TroopStatus.EXP )
	exp = exp + number
	self:SetStatus( TroopStatus.EXP, exp * 5 )
	--print( self:ToString(), "exp=" .. exp, number )
end

function Troop:KillTroop( target )
	local bonus = Asset_Get( target, TroopAssetID.LEVEL ) + 5
	local honor = self:GetStatus( TroopStatus.HONOR )
	if not honor then honor = 0 end
	honor = honor + bonus
	self:SetStatus( TroopStatus.HONOR, honor )
end

function Troop:CanLevelUp()
	local level     = Asset_Get( self, TroopAssetID.LEVEL )
	local potential = Asset_Get( self, TroopAssetID.POTENTIAL )
	if level >= potential then return false end	

	local exp = self:GetStatus( TroopStatus.EXP )
	local maxExp = Asset_Get( self, TroopAssetID.MAX_SOLDIER ) * level
	if not exp or exp < maxExp then return false end
	return true
end

function Troop:LevelUp()
	if self:CanLevelUp() == false then
		return false
	end
	local exp = Asset_GetDictItem( self, TroopAssetID.STATUSES, TroopStatus.EXP )
	exp = exp - Scenario_GetData( "TROOP_PARAMS" ).TROOP_LEVELUP_EXP
	self:SetStatus( TroopStatus.EXP, exp )
	Asset_Plus( self, TroopAssetID.LEVEL, 1 )

	Stat_Add( "TroopLevelUp@" .. self.name, 1, StatType.TIMES )
	return true
end

function Troop:Update()
end