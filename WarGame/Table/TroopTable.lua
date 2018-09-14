
----------------------------------------------------------------


TroopTable = class()

function TroopTable:Load( data )
	self.id   = data.id or 0	
	self.name = data.name or 0
	self.category = TroopCategory[data.category] or TroopCategory.INFANTRY

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

function TroopTable:GetWeaponBy( name, value )
	for _, weapon in pairs( self.weapons ) do
		if weapon[name] == value then
			--InputUtil_Pause( weapon[name], value )
			return weapon
		end
	end
	return nil
end

-------------------------------

local _troopTableMng = Manager( 0, "TroopTable", TroopTable )

function TroopTable_Load( datas )
	_troopTableMng:Clear()
	_troopTableMng:LoadFromData( datas )
end


function TroopTable_Init()
	_troopTableMng:ForeachData( function( tabledata )		
		local weapons = {}
		for _, id in pairs( tabledata.weapons ) do
			local wp = WeaponTable_Get( id )
			table.insert( weapons, wp )
		end
		tabledata.weapons = weapons
	end)
end

function TroopTable_Get( id )
	return _troopTableMng:GetData( id )
end

function TroopTable_Foreach( fn )
	_troopTableMng:ForeachData( fn )
end

function TroopTable_Find( fn )
	return _troopTableMng:FindData( fn )
end

function TroopTable_ListAbility( troop )
	print( troop.name
		.. " armor="     .. troop:GetArmor()
		.. " toughness=" .. troop:GetToughness()
	    .. " movement="  .. troop:GetMovement() )
end

function TroopTable_List()
	TroopTable_Foreach( TroopTable_ListGrade )
end

function TroopTable_GetPower( troop )
	local armor     = troop:GetArmor()
	local toughness = troop:GetToughness()
	local tableData = Asset_Get( troop, TroopAssetID.TABLEDATA )
	local atk = 0	
	for _, weapon in pairs( tableData.weapons ) do
		atk = atk + weapon.weight + weapon.sharpness
	end
	local def = armor + toughness
	return atk + def
end