--------------------------------------------------------------
--
-- Manager
--
--	e.g.
--		m = Manager()
--		m:Init( "name", clz, type_id )
--
--		data = { "test" }
--		m:AddData( 1, data )
--
--------------------------------------------------------------

Manager = class()

function Manager:__init( type, name, clz )
	self._name = name

	self._clz = clz

	self._type = type

	self._datas = {}

	self._count = 0
	
	self._alloateId = 0
end

function Manager:GetCount()
	return self._count
end

function Manager:GetData( id )
	if not id or id == 0 then
		return nil
	end
	if not self._datas then
		return nil
	end
	return self._datas[id]
end

function Manager:NewID()
	self._alloateId = self._alloateId + 1
	return self._alloateId
end

function Manager:Clear()
	self._datas     = {}	
	self._count     = 0
	self._alloateId = 0
end

--[[
	e.g
		enum_datamng = 
		{
			TYPE_PLAYER = 1
		}		

		Player = class()

		m = Manager()		
		m:Init( "test", Player, enum_datamng.TYPE_PLAYER )
--]]
function Manager:Init( type, name, clz )
	self._name = name or self._name

	self._clz  = clz or self._clz

	self._type = type or self._type
end

--[[
	[datas]
	  [ id=1, ... ]		
	  [ id=2, ... ]
--]]
function Manager:LoadFromData( datas )
	if not datas then
		print( "!!! Manager:LoadFromdata() Failed! Type = " .. ( self._type or "" ) .. " Name=" .. ( self._name or "" ) )
		return 0
	end

	if not self._clz then
		error( "no clz" )
		return 0
	end

	--load new datas
	local number = 0
	for k, data in pairs( datas ) do		
		local newData = self._clz()

		if data.id == nil then
			data.id = k
		end
		
		newData:Load( data )

		self:AddData( newData.id, newData )
		
		--set allocated id
		if self._alloateId <= data.id then
			self._alloateId = data.id
		end

		number = number + 1
	end

	return number
end

function Manager:NewData()
	if not self._clz() then
		return nil
	end
	local newId = self:NewID()
	local newData = self._clz()
	newData.id = newId	
	self:AddData( newId, newData )	
	return newData
end

function Manager:AddData( id, data )
	if not self._datas[id] then
		self._count = self._count + 1
	end
	self._datas[id] = data
	return true
end

function Manager:RemoveData( id, fn )
	if not self._datas[id] then
		return false
	end
	if not fn or fn( self._datas[id] ) then
		self._datas[id] = nil
		self._count = self._count - 1
		return true
	end	
	return false
end

function Manager:RemoveAllData( fn )
	for k, data in pairs( self._datas ) do
		if not fn or fn( data ) then
			self._datas[k] = nil
			self._count = self._count - 1
		end
	end
end

function Manager:ForeachData( fn )
	for k, data in pairs( self._datas ) do
		fn( data )
	end
end

--Filter data by given function, return true means find the right data
function Manager:FilterData( fn )
	for k, data in pairs( self._datas ) do
		if fn( data ) == true then
			return data
		end
	end
end