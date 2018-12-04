GameMapDrawer = class()

function GameMapDrawer:__init()
	self.map = nil
	self.xInc = 1
	self.yInc = 1

	self.cityNameLen  = 4
	self.groupNameLen = 4

	--indent, at least 5( y = ??? )
	self.indentLength = 5	
	self.indent = string.rep( " ", self.indentLength )

	--item length, at least 4( x=?? )
	self.itemLength   = 1--4
	
	self.blank = string.rep( ".", self.itemLength )
end

local function DefaultDrawer( content )
	print( content )
end

function GameMapDrawer:SetMapData( map )
	self.map = map
end

function GameMapDrawer:DrawTextMapByTable( fn, printer )
	if not printer then
		printer = DefaultDrawer
	end	

	local width  = Asset_Get( self.map, MapAssetID.WIDTH )
	local height = Asset_Get( self.map, MapAssetID.HEIGHT )

	-- indent	
	local content = "x=" .. string.rep( " ", self.indentLength - 2 )
	for x = 1, width, self.xInc do
		content = content .. StringUtil_Abbreviate( "x="..x, self.itemLength )
	end

	-- draw header
	printer( content )

	-- draw rows
	for y = 1, height do
		local content = ""
		for x = 1, width do
			local data = self.map:GetPlot( x, y )
			if data then
				content = content .. StringUtil_Abbreviate( fn( data ), self.itemLength )
			else
				content = content .. self.blank
			end
		end
		printer( StringUtil_Abbreviate( "Y=".. y, self.indentLength ) .. content )
	end
end

function GameMapDrawer:UpdateMap()
	--self.map = {}
	Entity_Foreach( EntityType.CITY, function ( city )
		local y = Asset_Get( city, CityAssetID.Y )
		local x = Asset_Get( city, CityAssetID.X )
		if not self.map[y] then self.map[y] = {} end
		if self.map[y][x] then
			print( "Duplicate", city.name, self.map[y][x].name, "in " .. x .. ",", y )
		end
		self.map[y][x] = city
		if not self.map[y].length then
			self.map[y].length = x
		else
			self.map[y].length = math.max( self.map[y].length, x )
		end
	end )
end

function GameMapDrawer:Draw()
	if not self.map then return end

	--self:UpdateMap()
	self:DrawPlotMap()
	--self:DrawResourceMap( true )
	--self:DrawCityMap( true )
	--self:DrawGroupMap( true )
	--self:DrawCharaMap( true )
	--self:DrawPowerMap( true )
end

function GameMapDrawer:DrawPlotMap( invalidate )
	if not invalidate then self:UpdateMap() end
	print( "Plot Map" )
	local cityNum = 0
	self:DrawTextMapByTable( function ( plot )
		local content = ""
		local city = Asset_Get( plot, PlotAssetID.CITY )
		if city then
			if Asset_Get( city, CityAssetID.CENTER_PLOT ) == plot then
				content = content .. "C"
			end
		end
		local road = Asset_Get( plot, PlotAssetID.ROAD )
		if road > 0 then
			--if city then InputUtil_Pause( "wrong" ) end
			content = content .. "R"
		end
		--[[
		local table = Asset_Get( plot, PlotAssetID.TEMPLATE )
		if table then
			content = content .. StringUtil_Abbreviate( MathUtil_FindName( PlotType, table.type ), 1 )
			content = content .. StringUtil_Abbreviate( MathUtil_FindName( PlotTerrainType, table.terrain ), 1 )
			content = content .. StringUtil_Abbreviate( MathUtil_FindName( PlotFeatureType, table.feature ), 1 )			
		end
		--]]
		return content
	end)
	--print( "city=" .. cityNum )
end

function GameMapDrawer:DrawGroupMap( invalidate )
	if not invalidate then self:UpdateMap() end
	print( "Group Map" )
	self:DrawTextMapByTable( function( data )
		local city = data	
		if city then
			local content = " ".. StringUtil_Abbreviate( city.name, self.cityNameLen )
			local group = Asset_Get( city, CityAssetID.GROUP )
			content = content .. "@".. StringUtil_Abbreviate( group and group.name or "", self.groupNameLen ) .. " "
			return content
		end
		return self.blank
	end )
end

--[[
function GameMapDrawer:DrawData( data, desc, printer )
	print( desc )
	local tempMapData = {}
	for city, number in pairs( data ) do
		local pos = city.coordinate
		local y = pos.y
		local x = math.ceil( pos.x / self.xInc )
		if not tempMapData[y] then tempMapData[y] = {} end
		tempMapData[y][x] = city
		if not tempMapData[y].length then
			tempMapData[y].length = x
		else
			tempMapData[y].length = math.max( tempMapData[y].length, x )
		end
	end
	self:DrawTextMapByTable( function( x, y, c )
		local city = c	
		if city then			
			local content = ""
			content = content .. data[city]
			return content
		end
		return self.blank
	end, tempMapData, printer )
end

function GameMapDrawer:DrawCharaMap( invalidate )
	if not invalidate then self:UpdateMap() end
	print( "Chara Map" )
	self:DrawTextMapByTable( function( data )
		local city = data	
		if city then			
			local content = ""
			content = content .. #city.charas .. "/"
			--content = content .. g_statistic:CalcOutCharaNumber( city )
			return content
		end
		return self.blank
	end )
end

function GameMapDrawer:DrawPowerMap( invalidate )
	if not invalidate then self:UpdateMap() end
	print( "Power Map" )
	self:DrawTextMapByTable( function( data )
		local city = data	
		if city then			
			local content = ""
			if city:GetGroup() then
				local str = HelperUtil_CreateNumberDesc( city:GetPower() )--GuessCityPower( city ) )
				content = content .. StringUtil_Abbreviate( city:GetGroup().name, self.cityNameLen + 1 ) .. "=" .. StringUtil_Abbreviate( str, 4 )
			else
				local str = HelperUtil_CreateNumberDesc( city.guards )
				content = content .. StringUtil_Abbreviate( city.name, self.groupNameLen + 1 ) .. " " .. StringUtil_Abbreviate( str, 4 )
				--content = content .. StringUtil_Abbreviate( string.lower( city.name ), self.cityNameLen + 4 )
			end
			return content
		end
		return self.blank
	end )
end

function GameMapDrawer:DrawCityMap()
	if not invalidate then self:UpdateMap() end
	print( "City Map" )		
	self:DrawTextMapByTable( function( data )
		local city = data
		if city then return "<".. StringUtil_Abbreviate( city.name, self.blankLength ) ..">" end
		return self.blank
	end )
end

function GameMapDrawer:DrawResourceMap()
	if not invalidate then self:UpdateMap() end
	print( "Resource Map" )
	self:DrawTextMapByTable( function ( data )
		local plot = g_plotMap:GetPlot( x, y )
		if plot.resource then
			return "<".. StringUtil_Trim( plot.resource.name, self.blankLength ) ..">"
		end
		return self.blank
	end )
end
]]

--------------------------------------------

_gamemapDrawer = GameMapDrawer()

function GameMap_Draw( map )
	if 1 then return end
	--InputUtil_Pause()
	_gamemapDrawer:SetMapData( map )
	_gamemapDrawer:Draw()
end