-----------------------------------
-- Entity 
--
-- 1. Every entity should call Entity_Init() in __init()
-- 2. 
--
--
-----------------------------------
-- Entity Template
--[[

SampleAssetType = 
{
	BASE_ATTRIB = 1,
}

SampleAssetID = 
{
	LEVEL    = 10,
}

SampleAssetAttrib = 
{
	level      = AssetAttrib_SetNumber( { id = SampleAssetID.LEVEL,       type = SampleAssetType.BASE_ATTRIB } ),
}

-------------------------------------------

Sample = class()

function Sample:__init( ... )
	Entity_Init( self, EntityType.SAMPLE, SampleAssetAttrib )
end

function Sample:Load( data )
end

--]]

--Entity = nil--class()

---------------------------

local _entityManager = {}

-- Entity Data
--   Asset Manager
--   Attribs
-- [Type][Entity Data]
local _entityDatas = {}

-------------------------------------------------
-- Asset Manager

------------------------------------------------------------------------

function Entity_Setup( type, clz )
	if not _entityManager[type] then
		_entityManager[type] = Manager( type, "", clz )
	else
		_entityManager[type]:Init( type, nil, clz )
	end
end

-- Load entities from given datas, old entities will be cleared
function Entity_Load( type, datas, enum )
	if not _entityManager[type] then
		error( "no manager, you should call Entity_Setup() first." )
		return
	end
	local mng = _entityManager[type]
	mng:Clear()
	local number = mng:LoadFromData( datas )
	print( "Load [".. ( enum and MathUtil_FindName( enum , type ) or type ).."] Entity = " .. number .. "/" .. mng:GetCount() )
end

function Entity_Get( type, id )
	if not _entityManager[type] then
		_entityManager[type] = Manager( type )
	end
	local mng = _entityManager[type]
	return mng:GetData( id )
end

function Entity_Set( type, id, entity )
	if not _entityManager[type] then
		_entityManager[type] = Manager( type )
	end
	local mng = _entityManager[type]
	return mng:SetData( id, entity )
end

local function Entity_GetManager( type )
	if not _entityManager[type] then
		_entityManager[type] = Manager( type )
	end
	return _entityManager[type]
end

function Entity_Number( type )
	local mng = Entity_GetManager( type )
	return mng:GetCount()
end

function Entity_GetByIndex( type, index )
	local mng = Entity_GetManager( type )
	return mng:GetIndexData( index )
end

function Entity_Get( type, id )
	local mng = Entity_GetManager( type )
	return mng:GetData( id )
end

function Entity_New( type )
	local mng = Entity_GetManager( type )
	return mng:NewData()
end

function Entity_Add( entity )
	local mng = Entity_GetManager( entity.type )
	return mng:AddData( entity.id, entity )
end

--!!! Don't remove entity in Entity_Foreach() or Entity_Find()
function Entity_Remove( entity )
	local mng = Entity_GetManager( entity.type )
	if not mng then return false end
	if entity.Remove then entity:Remove() end
	return mng:RemoveData( entity.id )
end

function Entity_Clear( type )
	if not type then
		for _, mng in pairs( _entityManager ) do
			mng:Clear()
		end
	else
		local mng = Entity_GetManager( type )
		mng:Clear()
	end
end

function Entity_Foreach( type, fn )
	local mng = Entity_GetManager( type )
	mng:ForeachData( fn )
end

function Entity_Find( type, fn )
	local mng = Entity_GetManager( type )
	return mng:FindData( function ( entity )
		if fn( entity ) == true then
			return true
		end
	end )
end

-------------------------------------------------
-- Asset Attrib

function Entity_SetAssetAttrib( entity, attribs )
	if not attribs then return end
	local type = entity.type
	if not _entityDatas[type] then
		_entityDatas[type] = {}
	end
	if _entityDatas[type].attribs then
		return
	end
	_entityDatas[type].attribs = {}	
	for k, attrib in pairs( attribs ) do
		if not attrib.id then
			error( "set attrib failed" )
		end
		attrib.name = k
		_entityDatas[type].attribs[attrib.id] = attrib
	end
	_entityDatas[type].attribs["DUMP_LIST"] = attribs
end

function Entity_GetAssetAttrib( entity, id )
	if typeof( entity ) == "number" then
		error( "entity=" .. entity .. " is number" )
	end
	local type = entity.type
	if not _entityDatas[type] then
		return nil
	end
	if not _entityDatas[type].attribs then
		return nil
	end	
	if not id then
		return _entityDatas[type].attribs
	end
	return _entityDatas[type].attribs[id]
end

-------------------------------------------------

function Entity_Init( entity, type, attribs )
	local mng = Entity_GetManager( type )
	entity.type = type
	entity.id   = 1
	Entity_SetAssetAttrib( entity, attribs )
end

function Entity_InitAttrib( entity )
	local attribs = Entity_GetAssetAttrib( entity )
	if not attribs then
		return
	end
	for k, attrib in pairs( attribs ) do
		if attrib.default then
			Asset_Set( entity, attrib.id, attrib.default )
		elseif attrib.value_type == AssetAttribType.NUMBER then
			Asset_Set( entity, attrib.id, 0 )
		elseif attrib.value_type == AssetAttribType.STRING then
			Asset_Set( entity, attrib.id, "" )
		end
	end
end

function Entity_UpdateAttribPointer( entity )
	local attribs = Entity_GetAssetAttrib( entity )
	if not attribs then
		return
	end
	for k, attrib in pairs( attribs ) do
		if attrib.setter then
			if attrib.value_type == AssetAttribType.POINTER then
				Asset_VerifyData( entity, attrib.id )
			elseif attrib.value_type == AssetAttribType.POINTER_LIST then
				Asset_VerifyList( entity, attrib.id )
			end
		end
			--[[
			if attrib.value_type == AssetAttribType.POINTER then
				local value = Asset_Get( entity, attrib.id )
				if typeof( value ) == "number" then
					Asset_Set( entity, attrib.id, value )
				end
			elseif attrib.value_type == AssetAttribType.POINTER_LIST then
				local list = Asset_Get( entity, attrib.id )
				if list then
					for k, v in pairs( list ) do
						Asset_SetListItem( entity, attrib.id, k, v )
					end
				end
			end
			]]
	end
end

function Entity_VerifyData( entity )
	if entity.VerifyData then
		entity:VerifyData()
	end
end

function Entity_ForeachAttrib( entity, fn )	
	local attribs = Entity_GetAssetAttrib( entity )
	if not attribs then
		return
	end
	for k, attrib in pairs( attribs ) do
		fn( k, attrib )
	end
end

function Entity_Dump( entity, fn )
	local attribs = Entity_GetAssetAttrib( entity )
	if not attribs then
		return
	end	
	local list = attribs["DUMP_LIST"]
	print( "[" .. ( entity.name or "" ) .."]#" .. entity.id )
	local indent = "    "
	for k, attrib in pairs( list ) do
		if not fn or fn( attrib ) then
			local name = indent .. StringUtil_Trim( attrib.name, 12 )
			
			--list 
			if attrib.value_type == AssetAttribType.LIST then
				local content = ""
				local number = 0
				Asset_ForeachList( entity, attrib.id, function( item )
					number = number + 1
					if typeof( item ) == "table" then
						for itemName, itemValue in pairs( item ) do
							content = content .. itemName .. "=" .. itemValue .. ", "
						end
					elseif typeof( item ) == "boolean" then
						content = content .. ( item == true and "true" or "false" ) .. ", "
					elseif typeof( item ) == "object" then
						content = content .. "[obj], "
					end
				end )
				print( name .. " = " .. number .. " { " .. content .. " }" )		
			--pointer list
			elseif attrib.value_type == AssetAttribType.POINTER_LIST then
				local content = ""
				local number = 0
				Asset_ForeachList( entity, attrib.id, function( item )
					number = number + 1
					if typeof( item ) == "number" then
						content = content .. item .. ", "
					elseif item.Breif then
						content = content .. item:Breif() .. ", "
					else
						content = content .. ( item.name and item.name .. " " or "<?>" ) ..( item.id or "?" ).. ", "
					end
				end )
				print( name .. " = " .. number .. " { " .. content .. " }" )
			
			--other
			else
				local value = Asset_Get( entity, attrib.id )
				if typeof( value ) == "number" then
					if attrib.enum then
						print( name .. " = " .. MathUtil_FindName( attrib.enum, value ) )
					else
						print( name .. " = " .. value )
					end
				elseif value then
					if value.name or value.id then
						print( name .. " = " .. ( value.name or "-" ) .. ( value.id or "-" ) )
					else
						print( name .. " = ", value )
					end
				end
			end
		end
	end
end