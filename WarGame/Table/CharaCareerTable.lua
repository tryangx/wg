CharaCareerTable = class()

function CharaCareerTable:Load( data )
	self.id   = data.id or 0	
	self.name = data.name or 0
	self.grade = data.grade

	self.prerequsite = MathUtil_Copy( data.prerequsite )
end

-------------------------------

local _CharaCareerTableMng = Manager( 0, "CharaCareerTable", CharaCareerTable )

function CharaCareerTable_Load( datas )
	_CharaCareerTableMng:Clear()
	_CharaCareerTableMng:LoadFromData( datas )
end

function CharaCareerTable_Get( id )
	return _CharaCareerTableMng:GetData( id )
end
