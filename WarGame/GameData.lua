--------------------------------------------------------------
--
-- Game
--
--------------------------------------------------------------

-------------------------
-- Global Game Details
g_turnIdx  = 0
g_turnEnd  = 360 * 1
g_turnStep = 1

-------------------------
-- Game 

--Calendar
g_calendar = Calendar()

--Map
g_map = Map()


function Game_IsRunning()
	return g_turnIdx < ( g_turnEnd or g_turnIdx + 1 )
end

function Game_NextTurn()
	g_turnIdx = math.min( g_turnIdx + g_turnStep, g_turnEnd )

	--map
	g_map:Update( g_turnStep )

	--calendar
	g_calendar:ElapseDay( g_turnStep )

	print( "Turn=" .. g_turnIdx .. " Date=" .. g_calendar:CreateDesc( true ) )
	
	--InputUtil_Pause()
end

-------------------------------------------------

function Route_Make()
	Entity_Foreach( EntityType.CITY, function ( city )			
		Asset_ForeachList( city, CityAssetID.ADJACENTS, function( adjaCity )
			if not adjaCity or type( adjaCity ) == "number" then return end
			local path = Route_QueryPath( city, adjaCity )
			if not path then
				path = Route_MakeBetweenCity( city, adjaCity )
				for _, pos in pairs( path ) do
					--print( pos.x, pos.y )
					local plot = g_map:GetPlot( pos.x, pos.y )
					if plot then
						local city = Asset_Get( plot, PlotAssetID.CITY )
						if not city then
							Asset_Set( plot, PlotAssetID.ROAD, pos.weight )
						end
					end
				end
				local route = Entity_New( EntityType.ROUTE )
				Asset_Set( route, RouteAssetID.FROM, city )
				Asset_Set( route, RouteAssetID.TO, adjaCity )
				Asset_CopyList( route, RouteAssetID.NODES, path )
				--print( "find way", city.name .. "->", adjaCity.name )
			else
				--print( "route already exist between", city.name, adjaCity.name )
			end
		end )
	end )
end

function Route_MakeBetweenCity( fromCity, toCity )
	if not fromCity or not toCity then
		InputUtil_Pause( "invalid city, no route" )
		return
	end
	local cx, cy = Asset_Get( fromCity, CityAssetID.X ), Asset_Get( fromCity, CityAssetID.Y )
	local tx, ty = Asset_Get( toCity, CityAssetID.X ), Asset_Get( toCity, CityAssetID.Y )
	--print( "find", fromCity.name.."("..cx..","..cy..")" .. "->", toCity.name .."("..tx..","..ty..")" )

	PathFinder_SetEnviroment( PathDataType.NODE_GETTER, function( x, y )
		return g_map:GetPlot( x, y )
	end )
	PathFinder_SetEnviroment( PathDataType.OFFSET_LIST, PlotRouteOffsets )
	PathFinder_SetEnviroment( PathDataType.WIDTH, Asset_Get( g_map, MapAssetID.WIDTH ) )
	PathFinder_SetEnviroment( PathDataType.HEIGHT, Asset_Get( g_map, MapAssetID.HEIGHT ) )
	PathFinder_SetEnviroment( PathDataType.NODE_CHECKER, function( node )
		local weight = PathConstant.INVALID_WEIGHT
		local temp = Asset_Get( node, PlotAssetID.TEMPLATE )
		if temp then
			--weight = 10 * ( math.abs( Asset_Get( cur, PlotAssetID.X ) - Asset_Get( node, PlotAssetID.X ) ) + math.abs( Asset_Get( cur, PlotAssetID.Y ) - Asset_Get( node, PlotAssetID.Y ) ) )

			if temp.type == PlotType.LAND then
				weight = 10
			elseif temp.type == PlotType.HILLS then
				weight = 40
			elseif temp.type == PlotType.MOUNTAIN then
				weight = 100
			elseif temp.type == PlotType.WATER then
				weight = -20
			end

			if temp.terrain == PlotTerrainType.NONE then
			elseif temp.terrain == PlotTerrainType.PLAINS then
				weight = weight + 10
			elseif temp.terrain == PlotTerrainType.GRASSLAND then
				weight = weight + 10
			elseif temp.terrain == PlotTerrainType.DESERT then
				weight = weight + 50
			elseif temp.terrain == PlotTerrainType.TUNDRA then
				weight = weight + 50
			elseif temp.terrain == PlotTerrainType.SNOW then
				weight = weight + 50
			elseif temp.terrain == PlotTerrainType.COAST then
				weight = weight + 20
			elseif temp.terrain == PlotTerrainType.OCEAN then
				weight = weight - 10
			end

			if temp.feature == PlotFeatureType.ALL then
			elseif temp.feature == PlotFeatureType.WOODS then
				weight = weight + 10
			elseif temp.feature == PlotFeatureType.RAIN_FOREST then
				weight = weight + 20
			elseif temp.feature == PlotFeatureType.MARSH then
				weight = weight + 30
			elseif temp.feature == PlotFeatureType.OASIS then
				weight = weight + 0
			elseif temp.feature == PlotFeatureType.FLOOD_PLAIN then
				weight = weight + 0
			elseif temp.feature == PlotFeatureType.ICE then
				weight = weight + 30
			elseif temp.feature == PlotFeatureType.FALLOUT then
				weight = weight + 0
			end			
			--print( node.name, "weight=" .. weight )
		end
		return weight
	end )
	return PathFinder_FindPath( cx, cy, tx, ty )
end