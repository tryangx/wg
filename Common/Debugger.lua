DBGLevel = 
{
	NORMAL    = 1,

	IMPORTANT = 2,
	
	FATAL     = 3,
}

local _level = DBGLevel.IMPORTANT

local _watchers = {}

local _warnings = {}

function DBG_SetLevel( lv )
	_level = lv or DBGLevel.IMPORTANT
end

function DBG_Error( ... )
	print( ... )
	error( "" )
end

-- print "content" when "cond" is valid ( true or not nil )
--
-- @usage
--		local cond = true
--		DBG_Trace( cond, "is valid" )
--		cond = false
--		DBG_Trace( cond, "is invalid" )
--      DBG_Trace( cond, "warning", DBGLevel.FATAL )
--
--
function DBG_Trace( content, cond, lv )
	if not lv then lv = DBGLevel.IMPORTANT end	
	if not cond or cond == false then
		if lv >= _level then
			if lv == DBGLevel.FATAL then
				InputUtil_Pause( content )
			else
				print( content )
			end
		end
	end
end

function DBG_TrackBug( content )
	Log_Write( "tracebug", content )
end

-- print content once
function DBG_Warning( key, content )
	if _warnings[key] then return end
	_warnings[key] = 1
	print( "[WRN]" .. key .."-->".. content )
end

--
-- print content when key is switch on, default switch is off
-- @param lv More higher lv means not to watch
--
-- @usage
--		DBG_Set
--		DBG_SetWatcher( "test", DBGLevel.IMPORTANT )
--		DBG_Watch( "test", "nothing", DBGLevel.NORMAL )
--		DBG_Watch( "test", "vip", DBGLevel.IMPORTANT )
--
function DBG_Watch( key, content, lv )
	if not lv then lv = DBGLevel.NORMAL end
	--to check all, make "curlv" lower than given "lv"
	local curlv = _watchers[key] or DBGLevel.IMPORTANT

	if lv == DBGLevel.FATAL then
		InputUtil_Pause( content )
	elseif curlv > lv  then
		print( content )
	end

	if curlv > DBGLevel.NORMAL then
		Log_Write( "watcher", "[WTH]" .. content )
	end
end

function DBG_SetWatcher( key, lv )
	if MathUtil_FindName( DBGLevel, lv ) == "" then
		error( "Invalid watcher-->" .. key, lv )
	end
	_watchers[key] = lv
end

----------------------------------------------

CorrectLevel = 
{
	NORMAL    = 0,
	IMPORTANT = 1,
}

function CRR_Tolerate( content, lv )
	if not lv then lv = CorrectLevel.NORMAL end
	if lv ~= CorrectLevel.NORMAL then 
		InputUtil_Pause( "[TOLERATE]" .. content )
	else
		Log_Write( "tolerate", content )
	end
end

----------------------------------------------

local _logger = {}

function Log_Create( type, isAdd )
	if not isAdd then isAdd = false end
	local logger = _logger[type]
	if not logger then
		local fileName
		if isAdd then
			fileName = "run/" .. type .. ".log" 
		else
			fileName = "run/" .. type .. "_" .. g_gameId .. ".log" 
		end		
		logger = LogUtility( fileName, LogWarningLevel.LOG, false, isAdd )
		_logger[type] = logger
	else
		logger:SetAddMode( isAdd )
	end
	return logger
end

function Log_Add( type, content )
	local logger = Log_Create( type, true )
	if logger then
		logger:WriteLog( content )
	end
end

function Log_Write( type, content )
	local logger = Log_Create( type )
	if logger then
		logger:WriteLog( content )
	end
end