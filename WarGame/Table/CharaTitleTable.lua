CharaTitleTable = class()

function CharaTitleTable:Load( data )
	self.id   = data.id or 0	
	self.name = data.name or 0
	self.grade = data.grade

	self.prerequsite = MathUtil_Copy( data.prerequsite )
end

-------------------------------

local _CharaTitleTableMng = Manager( 0, "CharaTitleTable", CharaTitleTable )

function CharaTitleTable_Load( datas )
	_CharaTitleTableMng:Clear()
	_CharaTitleTableMng:LoadFromData( datas )
end

function CharaTitleTable_Get( id )
	return _CharaTitleTableMng:GetData( id )
end
