
StatType = 
{
	DESC         = 1,
	TIMES        = 2,
	DATA         = 3,
	VALUE        = 4,
	LIST         = 5,
	ACCUMULATION = 6,
}

----------------------------------------------

local _stats = {}

local _types = {}

local function Stat_Get( type, name )
	if not type then type = StatType.DESC end
	if not _stats[type] then _stats[type] = {} end
	if not _stats[type][name] then _stats[type][name] = {} end
	return _stats[type][name], type
end

function Stat_Add( name, data, type )
	local stats
	stats, type = Stat_Get( type, name )
	_types[name] = type	
	if type == StatType.DESC then
		stats.desc = data
	elseif type == StatType.TIMES then
		stats.times = stats.times and stats.times + 1 or 1
	elseif type == StatType.DATA then
		stats.data = data
	elseif type == StatType.VALUE then
		stats.value = data
	elseif type == StatType.LIST then
		table.insert( stats, data )
	elseif type == StatType.ACCUMULATION then
		stats.accumulation = stats.accumulation and stats.accumulation + data or data
	end	
end

function Stat_Dump( type )
	for t, list in pairs( _stats ) do
		if not type or t == type then
			for name, data in pairs( list ) do
				--print( list, name, data, list[name] )
				local dumper = list[name] and list[name]._DUMPER or nil
				if t == StatType.LIST then
					print( name .. ":" .. " cnt=" .. #data )--, dumper )
					if dumper then
						for _, item in ipairs( data ) do
							dumper( item )
						end
					end
				elseif t == StatType.DESC then
					print( name .. "=" .. data.desc )
				elseif t == StatType.TIMES  then
					print( name .. "=" .. data.times )
				elseif t == StatType.DATA then
					if dumper then
						dumper( name, data )
					else
						print( name .. "=" .. data.data )
					end
				elseif t == StatType.VALUE then
					print( name .. "=" .. data.value )
				elseif t == StatType.ACCUMULATION then
					print( name .. "=" .. data.accumulation )
				end
			end
		end
	end
end

function Stat_SetDumper( name, fn )
	local type = _types[name]
	if not type then
		InputUtil_Pause( "Invalid name-type for=", name )
		return
	end
	local stats = Stat_Get( type, name )
	stats._DUMPER = fn
end