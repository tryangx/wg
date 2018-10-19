AssetAttribType = 
{
	NUMBER       = 0,
	STRING       = 1,
	LIST         = 2,
	DICT         = 3,
	POINTER_LIST = 4,
	POINTER_DICT = 5,
	POINTER      = 6,
	DATA         = 7,
	TEMPORARY    = 10,	
}

ASSET_DEBUG = true

ASSET_CHECKER = true

--[[
	function Watcher( entity, id, value )
		if entity.type == xxx then
			print( yyy )
		end
	end
--]]
local _defaultAssetWatcher = nil

function AssetAttrib_SetWatcher( watcher )
	_defaultAssetWatcher = watcher
end

--[[
	AssetData = { id = ?, type = ?, value_type = ?, min = ?, max = ?, default = ?, setter = ? }

	id      : numberic, it's ID of the entity
	type    : string or numberic, it's the category
	value_type : determins what kind of the value of the attrib, maybe numberic, string, pointer or anything else
	min     : only valid in NUMBER
	max     : only valid in NUMBER
	default : only valid in NUMBER or TEMPORARY
	setter  : except DATA
	initer  : DATA
--]]

-- setup a number asset attribute
function AssetAttrib_SetNumber( params )
	return 
	{ 
		id         = params.id,
		type       = params.type,
		value_type = AssetAttribType.NUMBER,
		min        = params.min, 
		max        = params.max,
		default    = params.default or 0,
		setter     = params.setter,
		enum       = params.enum,
	}
end

-- setup a string asset attribute
function AssetAttrib_SetString( params )
	return 
	{ 
		id         = params.id,
		type       = params.type,
		value_type = AssetAttribType.STRING,
		default    = "",
		setter     = params.setter,
	}
end

-- setup a list asset attribute
function AssetAttrib_SetList( params )
	return 
	{ 
		id         = params.id,
		type       = params.type,
		value_type = AssetAttribType.LIST,
		setter     = params.setter,
		changer    = params.changer,
	}
end

function AssetAttrib_SetDict( params )
	return 
	{ 
		id         = params.id,
		type       = params.type,
		value_type = AssetAttribType.DICT,
		setter     = params.setter,
		changer    = params.changer,
	}
end

function AssetAttrib_SetPointerList( params )
	return 
	{ 
		id         = params.id,
		type       = params.type,
		value_type = AssetAttribType.POINTER_LIST,
		setter     = params.setter,
		changer    = params.changer,
	}
end

function AssetAttrib_SetPointerDict( params )
	return 
	{ 
		id         = params.id,
		type       = params.type,
		value_type = AssetAttribType.POINTER_DICT,
		setter     = params.setter,
		changer    = params.changer,
	}
end

-- setup a pointer assset attribute
function AssetAttrib_SetPointer( params )
	return 
	{ 
		id         = params.id,
		type       = params.type,
		value_type = AssetAttribType.POINTER,
		setter     = params.setter,
	}
end

-- setup a pointer assset attribute
function AssetAttrib_SetData( params )
	return 
	{ 
		id         = params.id,
		type       = params.type,
		value_type = AssetAttribType.DATA,
		initer     = params.initer,
	}
end

-- setup a temporary asset attribute
function AssetAttrib_SetTemporary( params )
	return
	{
		id         = params.id,
		type       = params.type,
		value_type = AssetAttribType.TEMPORARY,
		default    = 0,
		setter     = params.setter,
	}
end

----------------------------------

local function Asset_SetRaw( entity, id, value )
	entity[id] = value
end

local function Asset_GetRaw( entity, id )
	local ret = entity[id]
	if not ret then	
		local attrib = Entity_GetAssetAttrib( entity, id )
		if attrib then
			if attrib.value_type == AssetAttribType.DATA then
				ret = attrib.initer and attrib.initer() or nil
			else
				ret = attrib.default
			end
			Asset_SetRaw( entity, id, ret )
		end
	end
	return ret
end

----------------------------------

function Asset_Clear( entity, id )
	if not id then error( "id is invalid" ) end
	if typeof( entity ) == "number" then
		print( "entity=", entity, "type=", typeof(entity), " or id=", id, " is invalid" )
		return
	end
	entity[id] = {}
	if _defaultAssetWatcher then _defaultAssetWatcher( entity, id, "clear list" ) end
end

function Asset_Foreach( entity, id, fn )
	local datas = entity[id]
	if not datas then return end
	for id, item in pairs( datas ) do
		fn( item, id )
	end
end

----------------------------------
-- Asset Attrib : List 
----------------------------------

function Asset_GetList( entity, id )
	if ASSET_DEBUG then
		if not id then
			error( "id is invalid" )
		end
		if typeof( entity ) == "number" then
			print( "entity=", entity, " is ", typeof(entity) )
			return nil
		end
	end
	local list = entity[id]
	if not list then
		local attrib = Entity_GetAssetAttrib( entity, id )
		if attrib and ( attrib.value_type == AssetAttribType.LIST or attrib.value_type == AssetAttribType.POINTER_LIST ) then
			entity[id] = {}
			list = entity[id]
		elseif attrib and ( attrib.value_type == AssetAttribType.DICT or attrib.value_type == AssetAttribType.POINTER_DICT ) then
			error( "use wrong method, please check it, maybe use Asset_GetDict() insted of." )
		else
			error( "what's wrong?" .. entity.type .. "," .. id .. " attrib.type=" .. attrib.value_type )
		end
	end
	return list
end

function Asset_GetListSize( entity, id )
	local list = Asset_GetList( entity, id )
	return list and #list or 0
end

function Asset_GetListItem( entity, id, name )
	local list = Asset_GetList( entity, id )
	return list and list[name] or nil
end

function Asset_GetListByIndex( entity, id, index )
	local list = Asset_GetList( entity, id )
	if not list then return nil end
	for idx, data in pairs( list ) do
		if idx == index then
			return data
		end
	end
	return nil
end

-- list is just a list, not dictionary
function Asset_CopyList( entity, id, source, fn )
	if not source then return end
	
	Asset_Clear( entity, id )

	local list = Asset_GetList( entity, id )

	local attrib = Entity_GetAssetAttrib( entity, id )
	local setter
	if attrib and attrib.setter and typeof( item ) == "number" then
		setter = attrib.setter
	end
	local changer = attrib and attrib.changer or nil

	--only copy list, not dict
	for id, item in ipairs( source ) do		
		local value = fn and fn( item ) or item
		if setter then
			value = attrib.setter( entity, id, value )
		end
		if changer then
			attrib.changer( entity, id, value )
		end
		table.insert( list, value )
	end	
	if _defaultAssetWatcher then _defaultAssetWatcher( entity, id, "copy list" ) end
end

function Asset_SetList( entity, id, list )
	if not id then error( "id invalid" ) end
	--checker
	if typeof( entity ) == "number" then
		error( "entity invalid" )
		return false
	end		
	entity[id] = list
end

-- Use this to add item into the list
function Asset_AppendList( entity, id, item, checker )
	if checker then
		error( "use wrong method, please check it, maybe use Asset_SetListItem() insted of." )
	end
	if not item then return end
	local list = Asset_GetList( entity, id )	
	local attrib = Entity_GetAssetAttrib( entity, id )
	if attrib and attrib.setter and typeof( item ) == "number" then
		item = attrib.setter( entity, id, item )
	end
	if attrib and attrib.changer then
		attrib.changer( entity, id, item )
	end

	--sanity checker
	if ASSET_CHECKER then
		if Asset_HasItem( entity, id, item ) then
			error( ( item[name] or "" ) .. " already in " .. ( entity[name] or "" ) )
		end
	end

	table.insert( list, item )
	if _defaultAssetWatcher then _defaultAssetWatcher( entity, id, "append item=", ( item or "" ) ) end
end

-- Use this to add item into the dictionary
function Asset_SetListItem( entity, id, index, item )
	local list = Asset_GetList( entity, id )
	
	local attrib = Entity_GetAssetAttrib( entity, id )
	if attrib and attrib.type == AssetAttribType.DICT then
		error( entity.type, entity.id )
	end
	if attrib then
		if attrib.setter and typeof( item ) == "number" then
			item = attrib.setter( entity, id, item )
		end
		if attrib.changer then
			attrib.changer( entity, id, item )
		end
	end

	if typeof(index) ~= "number" then
		error( "index should be number" )
	end

	entity[id][index] = item

	if _defaultAssetWatcher then _defaultAssetWatcher( entity, id, "set index=", index ) end	
end

-- Use this to remove item from the list
function Asset_RemoveListItem( entity, id, item, name )
	if not item then
		--error( "item invalid" )
		return false
	end
	if not id then error( "id invalid" ) end
	if typeof( entity ) == "number" then error( "entity invalid" ) return false end
	if not entity[id] then return false end

	local list = entity[id]
	for id, data in ipairs( list ) do
		if data == item or ( name and data[name] == item ) then			
			if _defaultAssetWatcher then _defaultAssetWatcher( entity, id, "remove index=", index ) end
			table.remove( list, id )
			return true
		end
	end
	return false
end

-- Use this to remove item from the dictionary
function Asset_RemoveIndexItem( entity, id, index )
	if not id then error( "id is invalid" ) end
	if typeof( entity ) == "number" then return end
	if not entity[id] then return end	

	entity[id] = nil
	if _defaultAssetWatcher then _defaultAssetWatcher( entity, id, "remove index=", index ) end
end

function Asset_FindItem( entity, id, fn )
	local datas = Asset_GetRaw( entity, id )
	if not datas then return nil end
	--pairs should be ipairs
	for k, item in pairs( datas ) do
		if fn( item, k ) == true then
			return item
		end
	end
	return nil
end

--[[
	@return true/false
--]]
function Asset_HasItem( entity, id, value, name )
	return Asset_FindItem( entity, id, function( item, k )
		if name then return item[name] == value end
		return item == value
	end ) ~= nil
end

function Asset_VerifyList( entity, id )
	if not id then error( "id is invalid" ) end
	if typeof( entity ) == "number" then return end

	if not entity[id] then return false end
	
	local attrib = Entity_GetAssetAttrib( entity, id )
	if not attrib or not attrib.setter then return false end

	--print( "verifylist", entity.type, id )
	local list = entity[id]
	for k, value in pairs( list ) do
		if typeof( value == "number" ) then
			local ret = attrib.setter( entity, id, value )
			--print( value, ret )
			list[k] = ret
		end
	end
end

----------------------------------
-- Asset Attrib : Dict
----------------------------------

--simply 
function Asset_CopyDict( entity, id, source, fn )
	if not source then return end
	
	Asset_Clear( entity, id )

	local dict = Asset_GetDict( entity, id )

	local attrib = Entity_GetAssetAttrib( entity, id )
	local setter = attrib and attrib.setter or nil

	for key, value in pairs( source ) do
		if setter then
			local newValue, newKey = setter( entity, id, value, key )
			if not newKey then newKey = key end
			dict[newKey] = newValue
		else
			dict[key] = value
		end
	end
end

function Asset_GetDict( entity, id )
	if ASSET_DEBUG then
		if not id then
			error( "id is invalid" )
		end
		if typeof( entity ) == "number" then
			print( "entity=", entity, " is ", typeof(entity) )
			return nil
		end
	end
	local list = entity[id]
	if not list then
		local attrib = Entity_GetAssetAttrib( entity, id )
		if attrib and ( attrib.value_type == AssetAttribType.DICT or attrib.value_type == AssetAttribType.POINTER_DICT ) then
			entity[id] = {}
			list = entity[id]
		else
			error( "what's wrong?" .. entity.type .. "," .. id )
		end
	end
	return list
end

-- Use this to add item into the dictionary
function Asset_SetDictItem( entity, id, name, item )
	if ASSET_DEBUG then
		if not name then
			error( "name is invalid" )
		end
		if typeof( name ) == "table" or typeof( name ) == "object" then
			error( "keyname should be number" )
		end
	end

	local dict = Asset_GetDict( entity, id )
	
	local attrib = Entity_GetAssetAttrib( entity, id )
	if attrib then
		if attrib.setter and typeof( item ) == "number" then
			item = attrib.setter( entity, id, item )
		end
		if attrib.changer then
			attrib.changer( entity, id, item )
		end
	end

	entity[id][name] = item

	if _defaultAssetWatcher then _defaultAssetWatcher( entity, id, item ) end	
end

function Asset_GetDictItem( entity, id, name )
	if ASSET_DEBUG then
		if typeof( name ) == "table" or typeof( name ) == "object" then
			error( "keyname should be number" )
		end
	end
	local dict = Asset_GetDict( entity, id )
	return dict and dict[name] or nil
end

function Asset_GetDictSize( entity, id )
	local dict = Asset_GetDict( entity, id )
	local size = 0
	for _, _ in pairs( dict ) do
		size = size + 1
	end
	return size
end

function Asset_FindDictItem( entity, id, fn )
	local dict = Asset_GetDict( entity, id )
	if not dict then return nil end
	--pairs should be ipairs
	for name, item in pairs( dict ) do
		if fn( item, name ) == true then
			return item
		end
	end
	return nil
end

function Asset_GetListFromDict( entity, id )
	local dict = Asset_GetList( entity, id )
	if not dict then return end
	local list = {}
	for id, item in pairs( dict ) do
		table.insert( list, item )
	end
	return list
end

----------------------------------
--	Asset Attrib : Pointer
----------------------------------

function Asset_ConvertID2Pointer( entity, id, fn )
	if not id then error( "id is invalid" ) end
	if entity[id] then
		for key, item in pairs( entity[id] ) do
			entity[id][key] = fn( item )
		end
	end
end

----------------------------------
--	Asset Attrib : All
----------------------------------

-- Use to reset pointer from number
function Asset_VerifyData( entity, id )
	if not entity then return end
	if not id then error( "id is invalid" ) end
	if typeof( entity ) == "number" then return end

	local attrib = Entity_GetAssetAttrib( entity, id )
	if attrib then
		value = entity[id]
		if typeof( value == "number" ) then
			if attrib.setter and typeof( value ) == "number" then
				local v = attrib.setter( entity, id, value )
				if v == value then
					print( "Entity verify data failed!" .." type=" .. entity.type .. " id=" .. id .. ", value=" .. value )
				else
					entity[id] = v
				end
			end
		end
	end
end

-- Most useful function, to set asset data
function Asset_Set( entity, id, value )
	if not entity then error( "entity invalid" ) return end
	if not id then error( "id is invalid" ) end
	if typeof( entity ) == "number" then return end
	local attrib = Entity_GetAssetAttrib( entity, id )
	if attrib then
		if not value then
			value = attrib.default
		end		
		if attrib.value_type == AssetAttribType.NUMBER then
			if attrib.min ~= nil and value < attrib.min then
				value = attrib.min
			elseif attrib.max ~= nil and value > attrib.max then
				value = attrib.max
			end
		elseif attrib.value_type == AssetAttribType.POINTER then
			if value == 0 then value = nil end
		elseif attrib.value_type == AssetAttribType.LIST or attrib.value_type == AssetAttribType.POINTER_LIST then
			if typeof( value ) == "number" then
				error( "cann't set number to list" .." type=" .. entity.type .. " id=" .. id )
			else
				error( "shouldn't set value to list/pointer_list, use Asset_SetListItem() instead." )
			end
		end
		if attrib.setter and typeof( value ) == "number" then
			local v = attrib.setter( entity, id, value )
			if v == value then
				print( "Entity verify data failed!" .." type=" .. entity.type .. " id=" .. id .. ", value=" .. value )
			end
			value = v
		end
	end
	if _defaultAssetWatcher then _defaultAssetWatcher( entity, id, "set value=" .. ( typeof( value ) == "number" and value or "" ) ) end
	Asset_SetRaw( entity, id, value )
end

function Asset_Get( entity, id )
	if ASSET_DEBUG then
		if not entity then
			error( "invalid entity in Asset_Get()" )
		end
		local attrib = Entity_GetAssetAttrib( entity, id )
		if not attrib then
			return
		end
		if attrib.value_type == AssetAttribType.LIST or attrib.value_type == AssetAttribType.POINTER_LIST then
			error( "please use Asset_GetList()" )
		end
		if attrib.value_type == AssetAttribType.DICT or attrib.value_type == AssetAttribType.POINTER_DICT then
			error( "please use Asset_GetDict()" )
		end
		if not id then
			error( "id is invalid" )
		end
		if typeof( entity ) == "number" then
			return
		end
	end
	return Asset_GetRaw( entity, id )
end


--
-- 
--
function Asset_Plus( entity, id, value )
	if not entity then return false end
	if not id then error( "id is invalid" ) return false end
	if typeof( entity ) == "number" then return false end
	local ret = Asset_Get( entity, id )
	if not ret then return false end
	Asset_Set( entity, id, ret + value )
	if _defaultAssetWatcher then _defaultAssetWatcher( entity, id, "plus value=" .. ret .. "+" ..value.."->" .. entity[id] ) end
	return true
end


--
-- 
--
function Asset_Reduce( entity, id, value )
	return Asset_Plus( entity, id, -value )
end


----------------------------------
--	Assert Debug
----------------------------------