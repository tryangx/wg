--[[
	Tracker helper

	@useage 
		Track_Data( "Number", 5 )
		Track_Data( "Number", 10 )
		Track_Reset( true )
--]]

local _trackerCaches = {}
local _trackerStacks = {}

----------------------------------------------

function Track_Pop( name )
	if not _trackerStacks[name] then _trackerStacks[name] = {} end
	_trackerCaches = _trackerStacks[name]
end

function Track_Data( name, data, need )
	if _trackerCaches[name] then
		_trackerCaches[name].current = data or 0
		if need then _trackerCaches[name].need = need end
	else
		_trackerCaches[name] = {}
		_trackerCaches[name].init    = data or 0
		_trackerCaches[name].current = data or 0
		_trackerCaches[name].need    = need
	end
end

function Track_Dump()
	--print( "#Track Data" )
	for k, v in pairs( _trackerCaches ) do
		local delta = v.current - v.init
		if delta ~= 0 then
			local content = HelperUtil_AbbreviateString( k, 10 ) .. "= " .. v.init .. "->" .. v.current .. ( delta >= 0 and " +" or " " ) .. delta .. "(" .. ( math.ceil( delta * 100 / v.init ) ) .. "%)"
			if v.need then
				content = content .. " ==>" ..  v.need
			end
			print( content )
		end		
	end
end

function Track_Reset( dump )
	_trackerCaches = {}
end