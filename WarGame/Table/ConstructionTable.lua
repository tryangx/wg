
ConstructionTable = class()

function ConstructionTable:Load( data )
	self.id   = data.id
	self.name = data.name
	self.type = CityConstructionType[data.type]

	self.area     = data.area or 1
	self.duration = data.duration
	self.effects  = MathUtil_Copy( data.effects )
	self.prerequsite = MathUtil_Copy( data.prerequsite )
end

function ConstructionTable:ToString()
	local content = ""
	for type, value in pairs( self.effects ) do
		content = content .. type .. "=" .. value
	end
	return content
end

----------------------------

local _ConstructionTableMng = Manager( 0, "ConstructionTable", ConstructionTable )

function ConstructionTable_Load( datas )
	_ConstructionTableMng:Clear()
	_ConstructionTableMng:LoadFromData( datas )
end

function ConstructionTable_Get( id )
	return _ConstructionTableMng:GetData( id )
end