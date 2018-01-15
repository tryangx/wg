BattlefieldTable = class()

function BattlefieldTable:Load( data )
	self.id   = data.id or 0	
	self.name = data.name or 0

	self.width  = data.width or 1
	self.height = data.height or 1

	self.grids  = MathUtil_Copy( data.grids )
	self.atkpos = MathUtil_Copy( data.atkpos )
	self.defpos = MathUtil_Copy( data.defpos )

	--print( self.name )
	--MathUtil_Dump( self.atkpos )
end

----------------------------

local _BattlefieldTableMng = Manager( 0, "BattlefieldTable", BattlefieldTable )

function BattlefieldTable_Load( datas )
	_BattlefieldTableMng:Clear()
	_BattlefieldTableMng:LoadFromData( datas )
end

function BattlefieldTable_Get( id )
	return _BattlefieldTableMng:GetData( id )
end