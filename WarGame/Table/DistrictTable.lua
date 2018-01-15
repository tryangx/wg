
DistrictTable = class()

function DistrictTable:Load( data )
	self.id   = data.id or 0	
	self.name = data.name or 0
	self.type = DistrictCategory[data.category] or DistrictCategory.NONE
	
	self.bonuses    = {}
	Table_CalculateBonuses( self.bonuses, data.bonuses )
	
	self.conditions = Table_ConvertConditions( data.conditions )
end

----------------------------

local _districtTableMng = Manager( 0, "DistrictTable", DistrictTable )

function DistrictTable_Load( datas )
	_districtTableMng:Clear()
	_districtTableMng:LoadFromData( datas )
end

function DistrictTable_Get( id )
	return _districtTableMng:GetData( id )
end