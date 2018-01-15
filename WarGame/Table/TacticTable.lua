
TacticTable = class()

function TacticTable:Load( data )
	self.id   = data.id or 0	
	self.name = data.name or 0
	self.type = TacticCategory[data.category] or TacticCategory.ACTIVE
	
	self.trigger = data.trigger
	self.result = data.conditions
end

----------------------------

local _TacticTableMng = Manager( 0, "TacticTable", TacticTable )

function TacticTable_Load( datas )
	_TacticTableMng:Clear()
	_TacticTableMng:LoadFromData( datas )
end

function TacticTable_Get( id )
	return _TacticTableMng:GetData( id )
end