MapAssetID = 
{
	WIDTH  = 1,
	HEIGHT = 2,
	PLOTS  = 3,	
}

MapAssetAttrib =
{
	AssetAttrib_SetNumber ( { id = MapAssetID.WIDTH,   nil, min = 1, max = 4000 } ),
	AssetAttrib_SetNumber ( { id = MapAssetID.HEIGHT,  nil, min = 1, max = 4000 } ),
	AssetAttrib_SetList   ( { id = MapAssetID.PLOTS,   nil } ),
}

PlotRouteOffsets = 
{
	{ x = -1, y = -1, distance = 1, },
	{ x = 0,  y = -1, distance = 1, },
	{ x = 1,  y = 0,  distance = 1, },
	{ x = 0,  y = 1,  distance = 1, },
	{ x = -1, y = 1,  distance = 1, },
	{ x = -1, y = 0,  distance = 1, },	
}

PlotAdjacentOffsets = {
	{ x = -1, y = -1, distance = 1, },
	{ x = 0,  y = -1, distance = 1, },
	{ x = 1,  y = 0,  distance = 1, },
	{ x = 0,  y = 1,  distance = 1, },
	{ x = -1, y = 1,  distance = 1, },
	{ x = -1, y = 0,  distance = 1, },	
	
	{ x = -1, y = -2, distance = 2, },
	{ x = 0,  y = -2, distance = 2, },
	{ x = 1,  y = -2, distance = 2, },	
	{ x = 1,  y = -1, distance = 2, },
	{ x = 2,  y = 0,  distance = 2, },
	{ x = 1,  y = 1,  distance = 2, },	
	{ x = 1,  y = 2,  distance = 2, },
	{ x = 0,  y = 2,  distance = 2, },
	{ x = -1, y = 2,  distance = 2, },	
	{ x = -2, y = 0,  distance = 2, },
	{ x = -2, y = -1, distance = 2, },
	
	{ x = -2, y = -3, distance = 3, },
	{ x = -1, y = -3, distance = 3, },
	{ x = 0,  y = -3, distance = 3, },
	{ x = 1,  y = -3, distance = 3, },	
	{ x = 2,  y = -2, distance = 3, },
	{ x = 2,  y = -1, distance = 3, },
	{ x = 3,  y = 0,  distance = 3, },
	{ x = 2,  y = 1,  distance = 3, },
	{ x = 2,  y = 2,  distance = 3, },	
	{ x = 1,  y = 3,  distance = 3, },
	{ x = 0,  y = 3,  distance = 3, },
	{ x = -1, y = 3,  distance = 3, },	
	{ x = -2, y = 3,  distance = 3, },	
	{ x = -2, y = 2,  distance = 3, },
	{ x = -3, y = 1,  distance = 3, },	
	{ x = -3, y = 0,  distance = 3, },
	{ x = -3, y = -1, distance = 3, },
	{ x = -2, y = -2, distance = 3, },	
}

-------------------------------------------
--
--
--
-------------------------------------------

Map = class()

function Map:__init()
	Entity_Init( self, EntityType.MAP, MapAssetAttrib )
end

function Map:CreateKey( x, y )
	return self._size * ( y - 1 ) + x
end

function Map:GetPlot( x, y )
	local key = self:CreateKey( x, y )
	return Asset_GetListItem( self, MapAssetID.PLOTS, key )
end

-------------------------------------------
-- Generate the map
-------------------------------------------
function Map:MatchCondition( plot, condition )
	local x = Asset_Get( plot, PlotAssetID.X )
	local y = Asset_Get( plot, PlotAssetID.Y )

	function CheckNearPlot( distance, fn )
		distance = distance or 1
		local matchCondition = false
		for k, offset in ipairs( PlotAdjacentOffsets ) do
			if offset.distance <= distance then
				local adjaPlot = self:GetPlot( x + offset.x, y + offset.y )
				if adjaPlot and fn( adjaPlot ) then matchCondition = true break end
			end
		end
		if not matchCondition then return false end
		return true
	end
	function CheckAwayFromPlot( distance, fn )
		distance = distance or 1
		local matchCondition = true
		for k, offset in ipairs( PlotAdjacentOffsets ) do
			if offset.distance <= distance then
				local adjaPlot = self:GetPlot( x + offset.x, y + offset.y )
				if adjaPlot and fn( adjaPlot ) then matchCondition = false break end
			end
		end
		if not matchCondition then return false end
		return true
	end

	if condition.type == ResourceCondition.CONDITION_BRANCH then
		for k, subCond in ipairs( condition.value ) do
			if not self:MatchCondition( plot, subCond ) then				
				return false
			end
		end
	elseif condition.type == ResourceCondition.PROBABILITY then
		if g_synRandomizer:GetInt( 1, 10000 ) > condition.value then return false end
	elseif condition.type == ResourceCondition.PLOT_TYPE then
		if condition.value == "LIVING" then				
			if plot:GetPlotType() ~= PlotType.HILLS and plot:GetPlotType() ~= PlotType.LAND then					
				return false
			end
		elseif plot:GetPlotType() ~= PlotType[condition.value] then
			return false
		end
	elseif condition.type == ResourceCondition.PLOT_TERRAIN_TYPE then
		if plot:GetTerrain() ~= PlotTerrainType[condition.value] then return false end
	elseif condition.type == ResourceCondition.PLOT_FEATURE_TYPE then
		if plot:GetFeature() ~= PlotFeatureType[condition.value] then return false end
	elseif condition.type == ResourceCondition.PLOT_TYPE_EXCEPT then
		if condition.value == "LIVING" then				
			if plot:GetPlotType() == PlotType.HILLS or plot:GetPlotType() == PlotType.LAND then
				return false
			end
		elseif plot:GetPlotType() == PlotType[condition.value] then
			return false
		end
	elseif condition.type == ResourceCondition.PLOT_TERRAIN_TYPE_EXCEPT then
		if plot:GetTerrain() == PlotTerrainType[condition.value] then return false end
	elseif condition.type == ResourceCondition.PLOT_FEATURE_TYPE_EXCEPT then				
		if condition.value == "ALL" then
			if plot:GetFeature() ~= PlotFeatureType.NONE then
				return false
			end
		elseif plot:GetFeature() == PlotFeatureType[condition.value] then
			return false
		end
	elseif condition.type == ResourceCondition.NEAR_PLOT_TYPE then
		CheckNearPlot( 1, function( adjaplot )
			return adjaplot:GetPlotType() == PlotType[condition.value]
		end )
	elseif condition.type == ResourceCondition.NEAR_TERRAIN_TYPE then
		return CheckNearPlot( 1, function( adjaplot )
			return adjaplot:GetTerrain() == PlotTerrainType[condition.value]
		end )
	elseif condition.type == ResourceCondition.NEAR_FEATURE_TYPE then
		return CheckNearPlot( 1, function( adjaplot )
			return adjaplot:GetFeature() == PlotFeatureType[condition.value]
		end )
	elseif condition.type == ResourceCondition.AWAY_FROM_PLOT_TYPE then
		return CheckAwayFromPlot( 1, function( adjaplot )
			return adjaplot:GetPlotType() == PlotType[condition.value]
		end )
	elseif condition.type == ResourceCondition.AWAY_FROM_TERRAIN_TYPE then
		return CheckAwayFromPlot( 1, function( adjaplot )
			return adjaplot:GetTerrain() == PlotTerrainType[condition.value]
		end )
	elseif condition.type == ResourceCondition.AWAY_FROM_FEATURE_TYPE then
		return CheckAwayFromPlot( 1, function( adjaplot )
			return adjaplot:GetFeature() == PlotFeatureType[condition.value]
		end )
	else
		return false
	end
	return true
end	

local function GeneratePlotType( plotTypes )
	local totalProb = Cache_Get( plotTypes )
	if not totalProb then
		totalProb = 0
		for k, item in ipairs( plotTypes ) do
			totalProb = totalProb + item.prob
		end
	end
	local rand = Random_GetInt_Sync( 1, totalProb )
	for k, item in ipairs( plotTypes ) do
		if rand < item.prob then
			return item.id
		end
		rand = rand - item.prob
	end
	return plotTypes[1].id
end

function Map:FindPlotSuitable( conditions )
	local plotList = {}
	Asset_ForeachList( self, MapAssetID.PLOTS, function ( plot )
		local res = Asset_Get( plot, PlotAssetID.RESOURCE )
		if res then return end
		local matchCondition = true
		if conditions and #conditions > 0 then
			matchCondition = false						
			for k, condition in pairs( conditions ) do
				if self:MatchCondition( plot, condition ) then					
					matchCondition = true
				end
			end
		end
		if matchCondition then
			table.insert( plotList, plot )
		end
	end )
	return plotList
end

function Map:GeneratePlotResource( items )
	local plotNunmber = self._size

	for k, item in pairs( items ) do
	
		-- calculate how many item need can been put into the map
		local percent = item.percent or 0
		item.count = math.ceil( plotNunmber * percent * 0.01 )

		-- put resource into the map
		local resource = ResourceTable_Get( item.id )
		if resource then
			local plotList = self:FindPlotSuitable( resource.conditions )
			plotList = MathUtil_Shuffle_Sync( plotList, g_synRandomizer )
			for number = 1, #plotList do
				if number > item.count then break end
				local plot = plotList[number]
				Asset_Set( plot, PlotAssetID.RESOURCE, item.id )
				--print( "put ", resource.name, "on", Asset_Get( plot, PlotAssetID.X ), Asset_Get( plot, PlotAssetID.Y ) )
			end
		end
	end
end

function Map:Generate( datas )
	-- initialize
	Asset_ClearList( self, MapAssetID.PLOTS )
	Asset_Set( self, MapAssetID.WIDTH,  datas.width )
	Asset_Set( self, MapAssetID.HEIGHT, datas.height )
	self._size = datas.width * datas.height
	for y = 1, datas.height do
		for x = 1, datas.width do
			local plot = Entity_New( EntityType.PLOT )			
			Asset_Set( plot, PlotAssetID.X, x )
			Asset_Set( plot, PlotAssetID.Y, y )
			local key = self:CreateKey( x, y )
			Asset_SetListItem( self, MapAssetID.PLOTS, key, plot )
		end
	end

	--set plot type
	Asset_ForeachList( self, MapAssetID.PLOTS, function ( plot )		
		Asset_Set( plot, PlotAssetID.TEMPLATE, GeneratePlotType( datas.plotTypes ) )
		plot:InitName()
	end )
	
	-- set resource
	self:GeneratePlotResource( datas.strategicResources )
	self:GeneratePlotResource( datas.bonusResources )
	self:GeneratePlotResource( datas.luxuryResources )
	--self:GeneratePlotResource( artificialResourceItems )	
end

function Map:AllocateToCity()
	--
	--   07 08 09
    --  18 01 02 10
    --17 06 00 03 11
    --  16 05 04 12
	--   15 14 13
	--
	local maxDistance = 3
	local settlement = {}	
	
	function AddPlotToCity( plot, city, plots )
		local x = Asset_Get( plot, PlotAssetID.X )
		local y = Asset_Get( plot, PlotAssetID.Y )
		local adjaCityPlot = 0			
		for k, offset in ipairs( PlotAdjacentOffsets ) do
			if offset.distance == 1 then
				for _, adjaPlot in ipairs( plots ) do
					local adjax = Asset_Get( adjaPlot, PlotAssetID.X )
					local adjay = Asset_Get( adjaPlot, PlotAssetID.Y )
					if adjax == offset.x + x and adjay == offset.y + y then
						adjaCityPlot = adjaCityPlot + 1						
					end
				end
			end
		end
		Asset_Set( plot, PlotAssetID.CITY, city )
		--print( Asset_Get( city, CityAssetID.NAME ), "add plot", x, y )
	end

	--1st, allocate plots to city
	Entity_Foreach( EntityType.CITY, function ( city )
		local plots = {}
		local x = Asset_Get( city, CityAssetID.X )
		local y = Asset_Get( city, CityAssetID.Y )

		--allocate adjacent plot to the city
		local leftPlot = Asset_Get( city, CityAssetID.LEVEL ) - 1
		
		--ShowText( city.name, x, y, left, #PlotAdjacentOffsets )
		for k, offset in ipairs( PlotAdjacentOffsets ) do
			if leftPlot > 0 and offset.distance < maxDistance then
				local plot = self:GetPlot( x + offset.x, y + offset.y )
				if plot and not Asset_Get( plot, PlotAssetID.CITY ) then
					leftPlot = leftPlot - 1
					table.insert( plots, plot )
					settlement[plot] = ( maxDistance - offset.distance ) * 2
				end
			end
		end

		--add plot to city
		local plot = self:GetPlot( x, y )
			if plot then
			settlement[plot] = maxDistance * 2
			--set city center
			Asset_Set( city, CityAssetID.CENTER_PLOT, plot )
			AddPlotToCity( plot, city, plots, settlement[plot] )
			--set other plots		
			for k, plot in ipairs( plots ) do
				AddPlotToCity( plot, city, plots, settlement[plot] )
			end
		end

		--set city attribs
		Asset_AppendList( city, CityAssetID.PLOTS, plot )
		Asset_CopyList( city, CityAssetID.PLOTS, plots )
	end )	

	--2nd, init plot assets, gather people
	Asset_ForeachList( self, MapAssetID.PLOTS, function ( plot )
		plot:InitGrowth()
	end )
end

-------------------------------------------

function Map:Update( elapsedTime )
	Asset_ForeachList( self, MapAssetID.PLOTS, function ( plot )
		plot:Update( elapsedTime )
	end )
end
