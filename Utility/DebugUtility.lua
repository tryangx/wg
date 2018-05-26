local enableDebug = true

local function Debug_GetLog()	
	return Log_Create( "dbg" )
end

function Debug_Level( level )
	if level then DebugLog:SetLogLevel( level ) end
end

function Debug_Normal( ... )
	if enableDebug then Debug_GetLog():WriteDebug( ... ) end
end

function Debug_Log( ... )
	if enableDebug then
		local date = g_Time:CreateCurrentDateDesc()
		Debug_GetLog():WriteLog( date, ... )
	end
end

function Debug_Error( ... )
	if enableDebug then Debug_GetLog():WriteError( ... ) end
end

function Debug_Assert( condition, ... )
	if not condition or condition() then
		Debug_GetLog():Write( ..., LogWarningLevel.LOG )
	end
end

function Debug_Enable( enable )
	enableDebug = enable
end

function Debug_SetPrinterNode( isOn )
	Debug_GetLog():SetPrinterMode( isOn )
end