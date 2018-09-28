
StatType = 
{
	--DEST is just description, no else
	DESC         = 1,
	--TIMER only accumulation the called times
	TIMES        = 2,
	--DATA can use dumper to display
	DATA         = 3,
	--VALUE always is numberic
	VALUE        = 4,
	--LIST will records all datas in call
	LIST         = 5,
	--ACCUMULATION will accumulate all data in call
	ACCUMULATION = 6,
	--
	EFF          = 7,
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

--useful statistic function
--@usage
--  Stat_Add( "Item", { type = "FOOD", id = 100 }, StatType.LIST )
--  Stat_Add( "Bonus", Asset_Get( combat, CombatAssetID.TIME ), StatType.ACCUMULATION )
--  Stat_Add( "Times", "standup", StatType.TIMES )
function Stat_Add( name, data, type )
	if not data and type ~= StatType.TIMES then
		error( "statistic item should be valid" )
	end
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
	elseif type == StatType.ACCUMULATION 
		or type == StatType.EFF
		then
		stats.times = stats.times and stats.times + 1 or 1
		stats.accumulation = stats.accumulation and stats.accumulation + data or data
	end
end

function Stat_Dump( type )	
	--output
	for t, list in pairs( _stats ) do
		if not type or t == type then			
			Log_Write( "stat",  "" )
			Log_Write( "stat",  "#" .. MathUtil_FindName( StatType, t ) )
			local namelist = {}
			for name, data in pairs( list ) do
				table.insert( namelist, name )
			end
			table.sort( namelist )
			for _, name in ipairs( namelist ) do				
				local data = list[name]
				local dumper = list[name] and list[name]._DUMPER or nil
				if t == StatType.LIST then
					Log_Write( "stat",  name .. ":" .. " cnt=" .. #data, dumper )
					if dumper then
						for _, item in ipairs( data ) do
							dumper( item )
						end
					else
						for _, item in ipairs( data ) do
							Log_Write( "stat",  item )
						end
					end
				elseif t == StatType.DESC then
					Log_Write( "stat",  name .. "=" .. data.desc )
				elseif t == StatType.TIMES  then
					Log_Write( "stat",  name .. "=" .. data.times )
				elseif t == StatType.DATA then
					if dumper then
						dumper( name, data )
					else
						Log_Write( "stat",  name .. "=" .. data.data )
					end
				elseif t == StatType.VALUE then
					Log_Write( "stat",  name .. "=" .. data.value )
				elseif t == StatType.ACCUMULATION then
					Log_Write( "stat",  name .. "=" .. data.accumulation )
				elseif t == StatType.EFF then
					Log_Write( "stat",  name .. "=" .. math.floor( data.accumulation / data.times ) )
				end
			end
		end
	end
	Log_Write( "stat",  "####END_DUMP####" )	
end

function Stat_SetDumper( name, fn, type )
	if not type then
		type = _types[name]
		if not type then
			error( "Invalid name-type for=" .. name )
		end
	elseif not _types[name] then
		_types[name] = type
	end
	local stats = Stat_Get( type, name )
	stats._DUMPER = fn
end