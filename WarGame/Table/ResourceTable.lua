
----------------------------------------------------------------


ResourceTable = class()

function ResourceTable:Load( data )
	self.id   = data.id or 0	
	self.name = data.name or 0
	self.category = ResourceCategory[data.category] or ResourceCategory.NONE	
	
	self.bonuses    = {}
	Table_CalculateBonuses( self.bonuses, data.bonuses )
	
	self.conditions = Table_ConvertConditions( data.conditions )
end

function ResourceTable:Dump()
	print( self.name, MathUtil_FindName( ResourceCategory, self.category ) )
end

-------------------------------

local _resourceTableMng = Manager( 0, "ResourceTable", ResourceTable )

function ResourceTable_Load( datas )
	_resourceTableMng:Clear()
	_resourceTableMng:LoadFromData( datas )
end

function ResourceTable_Get( id )
	return _resourceTableMng:GetData( id )
end