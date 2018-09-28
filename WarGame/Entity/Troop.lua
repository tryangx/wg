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
	MAX_SOLDIER  = 201,	
	CONVEYANCE   = 202,	

	SKILLS       = 220,
	STATUSES     = 221,

	-------------------------------
	--Combat	
	SOLDIER      = 300,
	LEVEL        = 301,	
	--Determine: CHAOS, RETREAT
	--DependsOn: TRAINING, OFFICER
	ORGANIZATION = 302,
	--Determine: CHAOS, FLEE
	--DependsOn: LEVEL, OFFICER
	MORALE       = 303,
	TIRENESS     = 304,
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
	level        = AssetAttrib_SetNumber ( { id = TroopAssetID.LEVEL,         type = TroopAssetType.GROWTH_ATTRIB, min = 0, max = 20 } ),
	morale       = AssetAttrib_SetNumber ( { id = TroopAssetID.MORALE,        type = TroopAssetType.GROWTH_ATTRIB, min = 0, max = 100 } ),
	organization = AssetAttrib_SetNumber ( { id = TroopAssetID.ORGANIZATION,  type = TroopAssetType.GROWTH_ATTRIB, min = 0 } ),	
	tireness     = AssetAttrib_SetNumber ( { id = TroopAssetID.TIRENESS,      type = TroopAssetType.GROWTH_ATTRIB, min = 0, max = 100 } ),	
}


-------------------------------------------


Troop = class()

function Troop:__init()
	Entity_Init( self, EntityType.TROOP, TroopAssetAttrib )
end

function Troop:ToString( type )
	local content = "[" .. self.name .. "](" .. self.id .. ")"
	
	content = content .. ( self:GetCombatData( TroopCombatData.SIDE ) and ( self:GetCombatData( TroopCombatData.SIDE ) == CombatSide.ATTACKER and "-ATK" or "-DEF" ) or "" )

	if type == "COMBAT" or type == "COMBAT_ALL" or type == "ALL" then
		local officer = Asset_Get( self, TroopAssetID.OFFICER )
		if officer then content = content .. " o=" .. officer:ToString() end
		content = content .. " org=" .. Asset_Get( self, TroopAssetID.ORGANIZATION )
		content = content .. " mor=" .. Asset_Get( self, TroopAssetID.MORALE )
		content = content .. " n=" .. Asset_Get( self, TroopAssetID.SOLDIER ) .. "/" .. Asset_Get( self, TroopAssetID.MAX_SOLDIER )
		content = content .. " ar=" .. self:GetArmor() .. " tg=" .. self:GetToughness()
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
		content = content .. " exp=" .. self:GetStatus( TroopStatus.EXP )
		content = content .. " cid=" .. ( self:GetStatus( TroopStatus.COMBATID ) or "" )
		content = content .. " isg=" .. ( self:GetStatus( TroopStatus.GUARD ) and "true" or "" )
		content = content .. " isr=" .. ( self:GetStatus( TroopStatus.RESERVE ) and "true" or "" )
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
end

-------------------------------------

function Troop:GetMaxMorale()	
	local maxMorale = 50
	--level effect
	maxMorale = maxMorale + Asset_Get( self, TroopAssetID.LEVEL ) * 5
	--officer effect
	maxMorale = maxMorale + Chara_GetSkillEffectValue( Asset_Get( self, TroopAssetID.OFFICER ), CharaSkillEffect.MORALE_BONUS )
	--status effect
	maxMorale = MathUtil_Clamp( maxMorale - ( self:GetStatus( TroopStatus.DOWNCAST ) or 0 ) , 30, 999 )
	return maxMorale
end

function Troop:GetMaxOrg()	
	local rate = 50
	--training effect
	rate = rate + self:GetStatus( TroopStatus.TRAINING )
	--officer effect
	rate = rate + Chara_GetSkillEffectValue( Asset_Get( self, TroopAssetID.OFFICER ), CharaSkillEffect.ORGANIZATION_BONUS )
	--calculate final
	local soldier = Asset_Get( self, TroopAssetID.SOLDIER )
	local maxOrg = math.ceil( soldier * rate * 0.01 )
	return maxOrg
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

function Troop:GetArmor()
	local tableData = Asset_Get( self, TroopAssetID.TABLEDATA )
	return tableData and tableData.armor or 0
end
function Troop:GetToughness()
	local tableData = Asset_Get( self, TroopAssetID.TABLEDATA )
	return tableData and tableData.toughness or 0
end
function Troop:GetMovement()
	local tableData = Asset_Get( self, TroopAssetID.TABLEDATA )
	return tableData and tableData.movement or 0
end

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

function Troop:AffectMorale( delta )	
	local maxMorale = self:GetMaxMorale()
	local morale = Asset_Get( self, TroopAssetID.MORALE )
	morale = math.max( 0, math.min( maxMorale, morale + delta ) )
	Asset_Set( self, TroopAssetID.MORALE, morale )
end

function Troop:KillSoldier( number )
	local exp = self:GetStatus( TroopStatus.EXP )
	self:SetStatus( TroopStatus.EXP, exp + number )
	--print( self:ToString(), "exp=" .. exp, number )
end

function Troop:NeutralizeTroop( target )
	local targetLevel = Asset_Get( target, TroopAssetID.LEVEL )
	local selfLevel   = Asset_Get( self, TroopAssetID.LEVEL )
	local bonus = 0
	if targetLevel + 5 >= selfLevel then
		bonus = targetLevel
	else
		bonus = math.ceil( targetLevel * 0.5 )
	end
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
	if self:CanLevelUp() == false then return false end
	local exp = Asset_GetDictItem( self, TroopAssetID.STATUSES, TroopStatus.EXP )
	exp = exp - Scenario_GetData( "TROOP_PARAMS" ).TROOP_LEVELUP_EXP
	self:SetStatus( TroopStatus.EXP, exp )
	Asset_Plus( self, TroopAssetID.LEVEL, 1 )

	Stat_Add( "TroopLevelUp@" .. self.name, 1, StatType.TIMES )
	return true
end

function Troop:UpdateAtHome()
	local lv = Asset_Get( self, TroopAssetID.LEVEL )
	local delta = lv + 5
	self:AffectMorale( delta )

	--check honor
	local honor = self:GetStatus( TroopStatus.HONOR )
	if not honor then return end
	local numOfSkills = Asset_GetListSize( self, TroopAssetID.SKILLS )
	local maxHonor = ( lv - 1 ) * 50 + numOfSkills * 100 + 50
	if honor < maxHonor then return end
	--learn troop skill
end