WeaponTable = class()

function WeaponTable:Load( data )
	self.id   = data.id or 0	
	self.name = data.name or 0

	--[[]]
	self.level     = data.level
	self.weight    = data.weight
	self.sharpness = data.sharpness
	self.range     = WeaponRangeType[data.range]
	self.ballistic = WeaponBallisticType[data.ballistic]
	self.attributes = MathUtil_Copy( data.attributes )
	--]]
--[[
	self.level = data.level
	self.dmg   = WeaponDamageType[data.dmg]
	self.range = WeaponRangeType[data.range]
	self.power = data.power
	self.accuracy = data.accuracy
	self.duration = data.duration
	--]]
end

-------------------------------

local _weaponTableMng = Manager( 0, "WeaponTable", WeaponTable )

function WeaponTable_Load( datas )
	_weaponTableMng:Clear()
	_weaponTableMng:LoadFromData( datas )
end

function WeaponTable_Get( id )
	return _weaponTableMng:GetData( id )
end

function WeaponTable_Foreach( fn )
	_weaponTableMng:ForeachData( fn )
end