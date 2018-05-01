
----------------------------------------------------------------

SkillTable = class()

function SkillTable:Load( data )
	self.id   = data.id or 0	
	self.name = data.name or 0
	
		id=2000, name="HR expert",
		effects = { HIRE_CHARA_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits  = { { "OPEN" } },

	self.armor = data.armor
	self.toughness = data.toughness
	self.movement = data.movement	

	self.skills = data.skills

	self.potential = data.potential

	self.capacity = data.capacity

	self.consume = data.consume
	self.requirement = data.requirement
	self.weapons = data.weapons
end

function SkillTable:GetWeaponBy( name, value )
	for _, weapon in pairs( self.weapons ) do
		if weapon[name] == value then
			--InputUtil_Pause( weapon[name], value )
			return weapon
		end
	end
	return nil
end

-------------------------------

local _SkillTableMng = Manager( 0, "SkillTable", SkillTable )

function SkillTable_Load( datas )
	_SkillTableMng:Clear()
	_SkillTableMng:LoadFromData( datas )
end


function SkillTable_Init()
	_SkillTableMng:ForeachData( function( tabledata )
		local weapons = {}
		for _, id in pairs( tabledata.weapons ) do
			local wp = WeaponTable_Get( id )
			table.insert( weapons, wp )
		end
		tabledata.weapons = weapons
	end)
end

function SkillTable_Get( id )
	return _SkillTableMng:GetData( id )
end

function SkillTable_Foreach( fn )
	_SkillTableMng:ForeachData( fn )
end

function SkillTable_Find( fn )
	return _SkillTableMng:FindData( fn )
end