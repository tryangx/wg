TroopMedalTable = class()

function TroopMedalTable:Load( data )
	self.id   = data.id or 0	
	self.name = data.name or 0

	self.prerequsite = MathUtil_Copy( data.prerequsite )
	self.effects     = MathUtil_Copy( data.effects )
end

-------------------------------

local _TroopMedalTableMng = Manager( 0, "TroopMedalTable", TroopMedalTable )

function TroopMedalTable_Load( datas )
	_TroopMedalTableMng:Clear()
	_TroopMedalTableMng:LoadFromData( datas )
end

function TroopMedalTable_Get( id )
	return _TroopMedalTableMng:GetData( id )
end

function TroopMedalTable_Foreach( fn )
	_TroopMedalTableMng:ForeachData( fn )
end

function TroopMedalTable_Find( fn )
	return _TroopMedalTableMng:FindData( fn )
end