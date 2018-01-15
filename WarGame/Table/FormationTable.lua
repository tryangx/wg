
FormationTable = class()

function FormationTable:Load( data )
	self.id   = data.id or 0	
	self.name = data.name or 0
end

----------------------------

local _FormationTableMng = Manager( 0, "FormationTable", FormationTable )

function FormationTable_Load( datas )
	_FormationTableMng:Clear()
	_FormationTableMng:LoadFromData( datas )
end

function FormationTable_Get( id )
	return _FormationTableMng:GetData( id )
end