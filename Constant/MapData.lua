
---------------------------------------
-- Plot relative

DefaultPlotBonus = 
{
	--Land
	[1] = { { type="AGRICULTURE", value=100 }, { type="PRODUCTION", value=100 }, { type="COMMERCE", value=100 }, },
	--Hill
	[2] = { { type="AGRICULTURE", value=50 },  { type="PRODUCTION", value=50 }, { type="COMMERCE", value=50 }, },
	--Mountain
	[3] = {},
	--Water
	[4] = {},
}

DefaultPlotTerrainBonus =
{
	--Plains
	[1] = { { type="AGRICULTURE", value=200 }, { type="COMMERCE", value=50 }, },
	--Grassland
	[2] = { { type="AGRICULTURE", value=50 }, { type="COMMERCE", value=50 }, },
	--Desert
	[3] = { },
	--Tundra
	[4] = { { type="COMMERCE", value=20 }, },
	--Snow
	[5] = { },
	--Lake
	[6] = { { type="AGRICULTURE", value=100 }, { type="COMMERCE", value=50 },  },
	--Coast
	[7] = { { type="AGRICULTURE", value=200 }, { type="COMMERCE", value=100 }, },
	--Ocean
	[8] = { },
}

DefaultPlotFeatureBonus = 
{
	--Woods
	[1] = { { type="PRODUCTION",  value=100 }, { type="COMMERCE",  value=100 }, },
	--Rain forest
	[2] = { { type="PRODUCTION", value=50 }, { type="COMMERCE",  value=50 }, },
	--Marsh
	[3] = { { type="AGRICULTURE", value=50 }, { type="COMMERCE",  value=50 }, },
	--Oasis
	[4] = { { type="AGRICULTURE", value=100 }, { type="COMMERCE", value=100 }, },
	--Flood plain
	[5] = { { type="AGRICULTURE", value=200 }, },
	--Ice
	[6] = { },
	--Fallout
	[7] = { },
}

DefaultPlotTableData =
{
	--Land
	[1000] = 
	{
		type    = "LAND",
		terrain = "PLAINS",
		feature = "NONE",
	},	
	[1100] = 
	{
		type    = "LAND",
		terrain = "GRASSLAND",
		feature = "NONE",
	},	
	[1200] = 
	{
		type    = "LAND",
		terrain = "DESERT",
		feature = "NONE",
	},	
	[1300] = 
	{
		type    = "LAND",
		terrain = "TUNDRA",
		feature = "NONE",
	},	
	[1400] = 
	{
		type    = "LAND",
		terrain = "SNOW",
		feature = "NONE",
	},
	
	--Hills
	[2000] = 
	{
		type    = "HILLS",
		terrain = "PLAINS",
		feature = "NONE",
	},	
	[2100] = 
	{
		type    = "HILLS",
		terrain = "GRASSLAND",
		feature = "NONE",
	},	
	[2200] = 
	{
		type    = "HILLS",
		terrain = "DESERT",
		feature = "NONE",
	},	
	[2300] = 
	{
		type    = "HILLS",
		terrain = "TUNDRA",
		feature = "NONE",
	},
	[2400] = 
	{
		type    = "HILLS",
		terrain = "SNOW",
		feature = "NONE",
	},	
	
	--Mountains
	[3000] = 
	{
		type    = "MOUNTAIN",
		terrain = "PLAINS",
		feature = "NONE",
	},	
	[3100] = 
	{
		type    = "MOUNTAIN",
		terrain = "GRASSLAND",
		feature = "NONE",
	},	
	[3200] = 
	{
		type    = "MOUNTAIN",
		terrain = "DESERT",
		feature = "NONE",
	},
	[3300] = 
	{
		type    = "MOUNTAIN",
		terrain = "TUNDRA",
		feature = "NONE",
	},	
	[3400] = 
	{
		type    = "MOUNTAIN",
		terrain = "SNOW",
		feature = "NONE",
	},
	
	--Water
	[4000] = 
	{
		type    = "WATER",
		terrain = "LAKE",
		feature = "NONE",
	},
	[4100] = 
	{
		type    = "WATER",
		terrain = "COAST",
		feature = "NONE",
	},
	[4200] = 
	{
		type    = "WATER",
		terrain = "OCEAN",
		feature = "NONE",
	},
}

--------------------------------------------------------

DefaultResourceData = 
{
	-------------------------------
	--Strategic Resource
	[100] = 
	{
		name="Copper", category="STRATEGIC", bonuses={ { type="COMMERCE", value=50 }, { type="PRODUCTION", value=50 }, }, 
		conditions={ 
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TYPE", value="HILLS" },
					{ type="PLOT_TERRAIN_TYPE_EXCEPT", value="SNOW" },
					{ type="PLOT_FEATURE_TYPE_EXCEPT", value="ALL" },
				}
			},	
		}
	},
	[101] = 
	{
		name="Iron", category="STRATEGIC", bonuses={ { type="COMMERCE", value=50 }, { type="PRODUCTION", value=100 }, }, 
		conditions={
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TYPE", value="HILLS" },
					{ type="PLOT_TERRAIN_TYPE_EXCEPT", value="SNOW" },
					{ type="PLOT_FEATURE_TYPE_EXCEPT", value="ALL" },
				}
			},	
		}
	},
	[110] = { name="Aluminum", category="STRATEGIC" },
	[111] = { name="Uranium", category="STRATEGIC" },
	
	[120] = 
	{
		name="Horse", category="STRATEGIC", bonuses={ { type="COMMERCE", value=50 }, },
		conditions={ 
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TYPE", value="LAND" },
					{ type="PLOT_TERRAIN_TYPE", value="PLAINS" },
					{ type="PLOT_FEATURE_TYPE_EXCEPT", value="ALL" },
				}
			},
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TYPE", value="LAND" },
					{ type="PLOT_TERRAIN_TYPE", value="GRASSLAND" },
					{ type="PLOT_FEATURE_TYPE_EXCEPT", value="ALL" },
				}
			},	
		}
	},
	[130] = { name="Niter", category="STRATEGIC" },
	[140] = { name="Coal", category="STRATEGIC" },
	[141] = { name="Oil", category="STRATEGIC" },
	[142] = { name="Gas", category="STRATEGIC" },
	
	
	-------------------------------
	--Bonus Resource
	[200] = 
	{
		name="RICE", category="BONUS", bonuses={ { type="SUPPLY_FOOD", value=100 }, }, 
		conditions={ 
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TERRAIN_TYPE", value="PLAINS" },
					{ type="PLOT_FEATURE_TYPE_EXCEPT", value="ALL" },
				}
			},
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TERRAIN_TYPE", value="PLAINS" },
					{ type="PLOT_FEATURE_TYPE", value="MARSH" },
				}
			},
		}
	},
	[201] = 
	{
		name="WHEAT", category="BONUS", bonuses={ { type="SUPPLY_FOOD", value=100 }, }, 
		conditions={ 
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TERRAIN_TYPE", value="PLAINS" },
					{ type="PLOT_FEATURE_TYPE_EXCEPT", value="ALL" },
				}
			},
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TERRAIN_TYPE", value="DESERT" },
					{ type="PLOT_FEATURE_TYPE", value="FLOOD_PLAIN" },
				}
			},			
		}		
	},
	[202] = { name="CORN", category="BONUS", bonuses={ { type="SUPPLY_FOOD", value=150 } }, },
	[203] = { name="POTATO", category="BONUS", bonuses={ { type="SUPPLY_FOOD", value=150 }, }, },
	[204] = { name="FRUITS", category="BONUS", bonuses={ { type="SUPPLY_FOOD", value=50 }, { type="SUPPLY_MODULUS", value=1.05 }, }, },
	[205] =
	{
		name="SALT", category="BONUS", bonuses={ { type="SUPPLY_MODULUS", value=1.02 }, },
		conditions={
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TERRAIN_TYPE_EXCEPT", value="GRASSLAND" },
					{ type="PLOT_FEATURE_TYPE_EXCEPT", value="ALL" },
				}
			},
			--[[
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TYPE", value="LAND" },
					{ type="PLOT_TERRAIN_TYPE", value="PLAINS" },
					{ type="PLOT_FEATURE_TYPE_EXCEPT", value="ALL" },
					{ type="NEAR_PLOT_TYPE", value="WATER" },
				}
			},
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TYPE", value="HILLS" },
					{ type="PLOT_TERRAIN_TYPE", value="PLAINS" },
					{ type="PLOT_FEATURE_TYPE_EXCEPT", value="ALL" },
				}
			},
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TYPE", value="LAND" },
					{ type="PLOT_TERRAIN_TYPE", value="DESERT" },
					{ type="NEAR_FEATURE_TYPE", value="OASIS" },
				}
			},
			]]
		}
	},
	[206] = 
	{
		name="FERTILE", category="BONUS", bonuses={ { type="SUPPLY_MODULUS", value=1.2 }, },
		conditions={ 
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TYPE", value="LAND" },
					{ type="PLOT_TERRAIN_TYPE", value="PLAINS" },
					{ type="PLOT_FEATURE_TYPE_EXCEPT", value="ALL" },
					{ type="AWAY_FROM_TERRAIN_TYPE", value="DESERT" },
				}
			},
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TYPE", value="LAND" },
					{ type="PLOT_TERRAIN_TYPE", value="GRASSLAND" },
					{ type="PLOT_FEATURE_TYPE_EXCEPT", value="ALL" },
					{ type="AWAY_FROM_TERRAIN_TYPE", value="DESERT" },
				}
			},
		}
	},
	[207] =
	{
		name="INFERTILE", category="BONUS", bonuses={ { type="SUPPLY_MODULUS", value=0.75 }, },
		conditions={ 
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TYPE", value="LAND" },
					{ type="PLOT_TERRAIN_TYPE", value="PLAINS" },
					{ type="PLOT_FEATURE_TYPE_EXCEPT", value="ALL" },
					{ type="NEAR_TERRAIN_TYPE", value="DESERT" },
				}
			},
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TYPE", value="LAND" },
					{ type="PLOT_TERRAIN_TYPE", value="GRASSLAND" },
					{ type="PLOT_FEATURE_TYPE_EXCEPT", value="ALL" },
					{ type="NEAR_TERRAIN_TYPE", value="DESERT" },
				}
			},
		}
	},
	
	--Luxury Resource
	[300] = 
	{
		name="SILVER", category="LUXURY", bonuses={ { type="COMMERCE", value=200 }, }, 
		conditions={
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TYPE", value="LIVING" },
					{ type="PLOT_TERRAIN_TYPE", value="DESERT" },
					{ type="PLOT_FEATURE_TYPE_EXCEPT", value="ALL" },
				}
			},
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TYPE", value="LIVING" },
					{ type="PLOT_TERRAIN_TYPE", value="TUNDRA" },
					{ type="PLOT_FEATURE_TYPE_EXCEPT", value="ALL" },
				}
			},
		}
	},
	[301] = 
	{
		name="GOLD", category="LUXURY", bonuses={ { type="COMMERCE", value=500 }, }, 
		conditions={
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TYPE", value="LIVING" },
					{ type="PLOT_TERRAIN_TYPE", value="DESERT" },
					{ type="PLOT_FEATURE_TYPE_EXCEPT", value="ALL" },
				}
			},
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TYPE", value="LIVING" },
					{ type="PLOT_TERRAIN_TYPE", value="TUNDRA" },
					{ type="PLOT_FEATURE_TYPE_EXCEPT", value="ALL" },
				}
			},
		}
	},
	
	[400] = { name="Everest", category="NATURAL", },
	
	--Artificial Resource
	[500] =
	{
		name="Settlement", cateogory="ARTIFICIAL", bonuses={},
		conditions={
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TYPE", value="LIVING" },
					{ type="PLOT_TERRAIN_TYPE", value="PLAINS" },
					{ type="PLOT_FEATURE_TYPE_EXCEPT", value="ALL" },
				}
			},
		}
	},
}


----------------------------------------------------------

DefaultDistrictData = 
{
	[100] = 
	{
		name="village", category="VILLAGE", bonuses={ },
		conditions={
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TYPE", value="LAND" },
					{ type="PLOT_TERRAIN_TYPE_EXCEPT", value="PLAINS" },
					{ type="PLOT_FEATURE_TYPE_EXCEPT", value="ALL" },
				}
			},
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TYPE", value="LAND" },
					{ type="PLOT_TERRAIN_TYPE_EXCEPT", value="SNOW" },
					{ type="PLOT_FEATURE_TYPE_EXCEPT", value="ALL" },
				}
			},	
		}
	},
	[200] = 
	{
		name="Town", category="TOWN", bonuses={  },
		conditions={
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TYPE", value="HILLS" },
					{ type="PLOT_TERRAIN_TYPE_EXCEPT", value="SNOW" },
					{ type="PLOT_FEATURE_TYPE_EXCEPT", value="ALL" },
				}
			},
			{ type="CONDITION_BRANCH", value=
				{
					{ type="PLOT_TYPE", value="HILLS" },
					{ type="PLOT_TERRAIN_TYPE_EXCEPT", value="SNOW" },
					{ type="PLOT_FEATURE_TYPE_EXCEPT", value="ALL" },
				}
			},	
		}
	},
}
