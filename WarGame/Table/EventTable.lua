
EventTable = class()

function EventTable:Load( data )
	self.id   = data.id or 0	
	self.name = data.name

	self.type   = EventType[data.type]
	self.target = data.target

	self.trigger = data.trigger
	self.effect  = data.effect
	self.storyboard = data.storyboard
end

----------------------------

local _EventTableMng = Manager( 0, "EventTable", EventTable )

function EventTable_Load( datas )
	_EventTableMng:Clear()
	_EventTableMng:LoadFromData( datas )
end

function EventTable_Add( event )
	local ev = EventTable()
	ev.id = _EventTableMng:GetCount() + 1
	ev.name = event.name

	ev.type    = Asset_Get( event, EventAssetID.TYPE )
	ev.target  = Asset_Get( event, EventAssetID.TARGET )

	ev.trigger = MathUtil_Copy( Asset_GetList( event, EventAssetID.TRIGGER ) )
	ev.effect  = MathUtil_Copy( Asset_GetList( event, EventAssetID.EFFECT ) )
	ev.storyboard  = MathUtil_Copy( Asset_GetList( event, EventAssetID.STORYBOARD ) )
end

function EventTable_Get( id )
	return _EventTableMng:GetData( id )
end

function EventTable_Find( fn )
	return _EventTableMng:FindData( fn )
end