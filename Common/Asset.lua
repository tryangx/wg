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

ASSET_DEBUG_SWITCH = true

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
-- Asset Attrib : List 
----------------------------------

function Asset_GetList( entity, id )
	if ASSET_DEBUG_SWITCH then
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
		else
			error( "what's wrong?" .. entity.type .. "," .. id )
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

--simply 
function Asset_CopyDict( entity, id, source, fn )
	if not source then return end
	Asset_ClearList( entity, id )
	local list = Asset_GetList( entity, id )
	for k, v in pairs( source ) do
		list[k] = v
	end
end

-- list is just a list, not dictionary
function Asset_CopyList( entity, id, source, fn )
	if not source then return end
	Asset_ClearList( entity, id )
	local list = Asset_GetList( entity, id )

	local attrib = Entity_GetAssetAttrib( entity, id )
	local setter = nil		
	if attrib and attrib.setter and typeof( item ) == "number" then
		setter = attrib.setter
	end

	--only copy list, not dict
	for k, item in ipairs( source ) do		
		local value
		if fn then
			value = fn( item )
		else
			value = item
		end
		if setter then
			value = attrib.setter( entity, id, value )
		end
		if attrib and attrib.changer then
			attrib.changer( entity, id, value )
		end
		table.insert( list, value )
	end	
	if _defaultAssetWatcher then _defaultAssetWatcher( entity, id, "copy list" ) end
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
	table.insert( list, item )
	if _defaultAssetWatcher then _defaultAssetWatcher( entity, id, "append item=", ( item or "" ) ) end
end

-- Use this to add item into the dictionary
function Asset_SetListItem( entity, id, index, item )
	local list = Asset_GetList( entity, id )
	
	local attrib = Entity_GetAssetAttrib( entity, id )
	if attrib and attrib.setter and typeof( item ) == "number" then
		item = attrib.setter( entity, id, item )
	end
	if attrib and attrib.changer then
		attrib.changer( entity, id, item )
	end
	entity[id][index] = item

	if _defaultAssetWatcher then _defaultAssetWatcher( entity, id, "set index=", index ) end	
end

-- Use this to remove item from the list
function Asset_RemoveListItem( entity, id, item )
	if not item then error( "item invalid" ) return false end
	if not id then error( "id invalid" ) end
	if typeof( entity ) == "number" then error( "entity invalid" ) return false end
	if not entity[id] then return false end

	local list = entity[id]
	for k, data in pairs( list ) do
		if data == item then
			if _defaultAssetWatcher then _defaultAssetWatcher( entity, id, "remove item=", k ) end
			table.remove( list, k )
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

function Asset_ClearList( entity, id )
	if not id then error( "id is invalid" ) end
	if typeof( entity ) == "number" then
		print( "entity=", entity, "type=", typeof(entity), " or id=", id, " is invalid" )
		return
	end
	entity[id] = {}
	if _defaultAssetWatcher then _defaultAssetWatcher( entity, id, "clear list" ) end
end

function Asset_Foreach( entity, id, fn )
	local list = Asset_GetList( entity, id )
	if not list then return end
	for k, item in pairs( list ) do
		fn( item, k )
	end
end

function Asset_FindListItem( entity, id, fn )
	local list = Asset_GetList( entity, id )
	if not list then return nil end
	--pairs should be ipairs
	for k, item in pairs( list ) do if fn( item, k ) == true then return item end end
	return nil
end

function Asset_FindDictItem( entity, id, fn )
	local list = Asset_GetDict( entity, id )
	if not list then return nil end
	--pairs should be ipairs
	for k, item in pairs( list ) do if fn( item, k ) == true then return item end end
	return nil
end

function Asset_GetListFromDict( entity, id )
	local list = Asset_GetList( entity, id )
	if not list then return end
	local ret = {}
	for k, item in pairs( list ) do
		table.insert( ret, item )
	end
	return ret
end

--[[
	@return true/false
--]]
function Asset_HasItem( entity, id, value, name )
	return Asset_FindListItem( entity, id, function( item, k )
		if name then return item[name] == value end
		return item == value
	end ) ~= nil
	--[[
	if not item then return false end
	if not id then error( "id is invalid" ) end
	if typeof( entity ) == "number" then return end
	if not entity[id] then entity[id] = {} return false end	
	
	local list = entity[id]
	for k, data in pairs( list ) do
		if isValue then
			if data == item then return true end
		else
			if k == item then return true end
		end
	end
	return false
	]]
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

function Asset_GetDict( entity, id )
	if ASSET_DEBUG_SWITCH then
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
	if ASSET_DEBUG_SWITCH then
		if not name then
			error( "name is invalid" )
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

	if _defaultAssetWatcher then _defaultAssetWatcher( entity, id, "set name=", index ) end	
end

function Asset_GetDictItem( entity, id, name )
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

----------------------------------
--	Asset Attrib : Pointer
----------------------------------

function Asset_ConvertID2Pointer( entity, id, fn )
	if not id then error( "id is invalid" ) end
	if entity[id] then
		for k, item in pairs( entity[id] ) do
			entity[id][k] = fn( item )
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
	if not entity then return end
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
	entity[id] = value
end


function Asset_Get( entity, id )
	if ASSET_DEBUG_SWITCH then
		if not entity then
			error( "invalid entity in Asset_Get()" )
		end
		local attrib = Entity_GetAssetAttrib( entity, id )
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
			return nil
		end
	end

	local ret = entity[id]
	if not ret then	
		local attrib = Entity_GetAssetAttrib( entity, id )
		if attrib then
			if attrib.value_type == AssetAttribType.DATA then
				ret = attrib.initer and attrib.initer() or nil
			else
				ret = attrib.default
			end
			Asset_Set( entity, id, ret )
		end
	end
	return ret
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