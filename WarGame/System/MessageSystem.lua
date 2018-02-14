-------------------------------------------------------
-- All system should start watch  on messages and process with them
-------------------------------------------------------
local _watcher = {}

function Message_Send( msgtype, params )

end

function Message_Post( msgtype, params )
	local msg = Entity_New( EntityType.MESSAGE )
	Asset_Set( msg, MessageAssetID.TYPE, msgtype )
	Asset_CopyDict( msg, MessageAssetID.PARAMS, params )

	--InputUtil_Pause( "post msg=" .. MathUtil_FindName( MessageType, msgtype ), "type=" .. msgtype )
end

function Message_Handle( systype, msgtype, callback )
	if not _watcher[msgtype] then _watcher[msgtype] = {} end
	--table.insert( _watcher[msgtype], systype )
	if _watcher[msgtype][systype] then
		DBG_Trace( MathUtil_FindName( MessageType, msgtype ) .. " already has callback for msg=" .. MathUtil_FindName( SystemType, systype ), not callback, DBGLevel.FATAL )
	else
		_watcher[msgtype][systype] = callback
	end
end

function Message_Update( msg )
	local watchers = _watcher[Asset_Get( msg, MessageAssetID.TYPE )]
	if not watchers then return end
	for sysid, callback in pairs( watchers ) do
		if callback then
			callback( msg )
		end
	end
end

--------------------------------------------------------------

MessageSystem = class()

function MessageSystem:__init()
	System_Setup( self, SystemType.MESSAGE_SYS )
end

function MessageSystem:Start()
end

function MessageSystem:Update()
	Entity_Foreach( EntityType.MESSAGE, Message_Update )
	Entity_Clear( EntityType.MESSAGE )
end