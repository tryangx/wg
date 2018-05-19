
----------------------------------------------------------------------------------------
--
-- Plot & Terrain & Feature & Addition 
--
----------------------------------------------------------------------------------------

PlotType = 
{
	NONE     = 0,
	LAND     = 1,
	HILLS    = 2,
	MOUNTAIN = 3,
	WATER    = 4,
}

PlotTerrainType =
{
	NONE      = 0,
	PLAINS    = 1,
	GRASSLAND = 2,	
	DESERT    = 3,
	TUNDRA    = 4,
	SNOW      = 5,
	LAKE      = 6,
	COAST     = 7,
	OCEAN     = 8,
}

PlotFeatureType = 
{
	ALL         = -1,
	NONE        = 0,
	WOODS       = 1,
	RAIN_FOREST = 2,
	MARSH       = 3,
	OASIS       = 4,
	FLOOD_PLAIN = 5,
	ICE         = 6,
	FALLOUT     = 7,
}

PlotAddition = 
{
	NONE      = 0,
	RIVER     = 1,
	CLIFFS    = 2,
}


----------------------------------------------------------------------------------------
--
--
--
----------------------------------------------------------------------------------------

ResourceCategory = 
{
	NONE       = 0,
	STRATEGIC  = 1,	
	BONUS      = 2,
	LUXURY     = 3,
	NATURAL    = 4,
	ARTIFICIAL = 5,
}

ResourceCondition =
{
	CONDITION_BRANCH         = 1,
	PROBABILITY              = 2,
	PLOT_TYPE                = 10,	
	PLOT_TERRAIN_TYPE        = 11,	
	PLOT_FEATURE_TYPE        = 12,
	PLOT_TYPE_EXCEPT         = 13,
	PLOT_TERRAIN_TYPE_EXCEPT = 14,
	PLOT_FEATURE_TYPE_EXCEPT = 15,
	NEAR_PLOT_TYPE           = 20,
	NEAR_TERRAIN_TYPE        = 21,
	NEAR_FEATURE_TYPE        = 22,
	AWAY_FROM_CITY_TYPE      = 23,
	AWAY_FROM_TERRAIN_TYPE   = 24,
	AWAY_FROM_FEATURE_TYPE   = 25,
}

----------------------------------------------------------------------------------------
--
--
--
----------------------------------------------------------------------------------------

DistrictCategory = 
{
	NONE        = 0,
	SETTLEMENT  = 1,
}
