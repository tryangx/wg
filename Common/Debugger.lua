DBGLevel = 
{
	NORMAL    = 1,

	IMPORTANT = 2,
	
	FATAL     = 3,
}

local _level = DBGLevel.IMPORTANT

local _logs = {}

local _watchers = {}

local _warnings = {}

function DBG_SetLevel( lv )
	_level = lv or DBGLevel.IMPORTANT
end

function DBG_Error( content )
	print( content )
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

		table.insert( _logs, "[DBG]" .. content )
	end
end

-- print content once
function DBG_Warning( key, content )
	if _warnings[key] then return end
	_warnings[key] = 1
	print( "[WRN]" .. key .."-->".. content )
end

--
-- print content when key is switch on, default switch is off
--
-- @usage
--		DBG_Set
--		DBG_SetWatcher( "test", DBGLevel.IMPORTANT )
--		DBG_Watch( "test", "nothing", DBGLevel.NORMAL )
--		DBG_Watch( "test", "vip", DBGLevel.IMPORTANT )
--
function DBG_Watch( key, content, lv )
	if not lv then lv = DBGLevel.NORMAL end	
	local curlv = _watchers[key] or DBGLevel.IMPORTANT

	if lv == DBGLevel.FATAL then
		InputUtil_Pause( content )
	elseif lv >= curlv then
		print( content )
	end
	if lv > DBGLevel.NORMAL then
		table.insert( _logs, "[WTH]" .. content )
	end
end

function DBG_SetWatcher( key, lv )
	if MathUtil_FindName( DBGLevel, lv ) == "" then
		InputUtil_Pause( "wrong key-->" .. key )
	end
	_watchers[key] = lv
end

----------------------------------------------

CorrectLevel = 
{
	NORMAL    = 0,
	IMPORTANT = 1,
}

local _logs = {}

function CRR_Tolerate( content, lv )
	if not lv then lv = CorrectLevel.NORMAL end
	if lv ~= CorrectLevel.NORMAL then 
		InputUtil_Pause( "[TOLERATE]" .. content )
	else
		print( "[TOLERATE]" .. content )
	end
	table.insert( _logs, content )	
end