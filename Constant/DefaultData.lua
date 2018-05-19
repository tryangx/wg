GlobalTime = 
{
	TIME_PER_YEAR  = 360,
	TIME_PER_MONTH = 30,
	MONTH_PER_YEAR = 12,
}


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

--------------------------------------------------------
--  Character Relative

DefaultCharaFamilyName = 
{
	{ name="Zhao", prob=15 },
	{ name="Qian", prob=10 },
	{ name="Sun",  prob=20 },
	{ name="Li",   prob=25 },
	{ name="Zhou", prob=15 },
	{ name="Wu",   prob=15 },
	{ name="Zhen", prob=10 },
	{ name="Wang", prob=20 },	
}

DefaultCharaGivenName = 
{
	{ name="I", prob=10 },
	{ name="II", prob=10 },
	{ name="III", prob=10 },
	{ name="IV", prob=10 },
	{ name="V", prob=10 },
	{ name="VI", prob=10 },
	{ name="VII", prob=10 },
	{ name="VIII", prob=10 },
	{ name="IX", prob=10 },
	{ name="XI", prob=10 },	
	{ name="XII", prob=10 },
	{ name="XIII", prob=10 },
	{ name="XIV", prob=10 },
	{ name="XV", prob=10 },
	{ name="XVI", prob=10 },
	{ name="XVII", prob=10 },
	{ name="XVIII", prob=10 },
	{ name="XIX", prob=10 },
	{ name="XX", prob=10 },
	--[[
	{ name="YI", prob=10 },
	{ name="ER", prob=10 },
	{ name="SAN", prob=10 },
	{ name="SI", prob=10 },
	{ name="WU", prob=10 },
	{ name="LIU", prob=10 },
	{ name="QI", prob=10 },
	{ name="BA", prob=10 },
	{ name="JIU", prob=10 },
	{ name="SHI", prob=10 },	
	{ name="SHIYI", prob=10 },
	{ name="ERER", prob=10 },
	{ name="SANSAN", prob=10 },
	{ name="SISI", prob=10 },
	{ name="WUWU", prob=10 },
	{ name="LIULIU", prob=10 },
	{ name="QIQI", prob=10 },
	{ name="BABA", prob=10 },
	{ name="JIUJIU", prob=10 },
	]]
}

-------------------------------------------------------
--  Group government

GroupGovernmentData = 
{
	NONE          = {},
	KINGDOM       =
	{
		CAPITAL_CHARA_LIMIT = 12,
	},
	EMPIRE        =
	{
		CAPITAL_CHARA_LIMIT = 12,
	},
	REGION        =
	{
		CAPITAL_CHARA_LIMIT = 8,
	},
	FAMILY        =
	{
		CAPITAL_CHARA_LIMIT = 8,
	},
	GUERRILLA     =
	{
		CAPITAL_CHARA_LIMIT = 6,
	},
	WARZONE       =
	{
		CAPITAL_CHARA_LIMIT = 6,
	},
}

--------------------------------------------------------
--  City Params

CitySpyParams = 
{
	--G1 known base intel popu, charas
	--G2 known roughly charas info
	--G3 known roughly military intel, exactly charas info( like loyality etc )
	--G4 known everything 
	--G5 improve op success probability
	INIT_GRADE  = 1,
	REQ_GRADE   = 3,
	MAX_GRADE   = 5,	
	GRADE_INTEL = { 100, 200, 400, 1000 },

	--Grade Level
	--3 Know everything
	--2 Know 50~90% exactly
	--1 know 20~50%
	--0 unknown
	GRADE_DATA  = 
	{
		[1] = { BASE = 1, GROWTH = 0, MILITARY = 1 },
		[2] = { BASE = 2, GROWTH = 1, MILITARY = 1 },
		[3] = { BASE = 3, GROWTH = 1, MILITARY = 2 },
		[4] = { BASE = 3, GROWTH = 2, MILITARY = 3 },
		[5] = { BASE = 3, GROWTH = 3, MILITARY = 3 },
	},
	GRADE_OP_BONUS = { 0, 0, 5, 10, 25 }
}

PopulationParams =
{
	-- Growth rate per Year, rate one per thousand
	GROWTH_MIN_RATE    = 12,
	GROWTH_MAX_RATE    = 24,
}

PlotParams = 
{
	-- 360 * 100 means 1 agr support 100 popu
	-- it relate with CityPopuStructureParams.POPU_PER_UNIT
	FOOD_PER_AGRICULTURE = 360 * 100,
}

FoodParams = 
{
	--unit is 50 grams
	CONSUME_PER_MAN = 10,
}

--------------------------------------------
--

DefaultJobPromoteData = 
{
	--[[
	OFFICER           = { contribution = 0, service = 0 },
	CIVIAL_OFFICIAL   = { contribution = 100, service = 0 },
	MILITARY_OFFICER  = { contribution = 100, service = 0 },
	SPY               = { contribution = 0, service = 0, has_skill = { { 0 } }, },
	TRADER            = { contribution = 0, service = 0, has_skill = { { 0 } }, },
	BUILDER           = { contribution = 0, service = 0, has_skill = { { 0 } }, },
	MISSIONARY        = { contribution = 0, service = 0, has_skill = { { 0 } }, },

	ASSISTANT_MINISTER= { contribution = 1000, service = 720 },
	DIPLOMATIC        = { contribution = 1000, service = 720 },
	GENERAL           = { contribution = 1000, service = 720 },
	CAPTAIN           = { contribution = 1000, service = 720 },
	AGENT             = { contribution = 1000, service = 720 },
	MERCHANT          = { contribution = 1000, service = 720 },
	TECHNICIAN        = { contribution = 1000, service = 720 },
	APOSTLE           = { contribution = 1000, service = 720 },
		
	IMPORTANT_JOB     = { contribution = 10000, service = 1800 },
	PREMIER           = { contribution = 10000, service = 1800 },
	CABINET_MINISTER  = { contribution = 10000, service = 1800 },
	MARSHAL           = { contribution = 10000, service = 1800 },
	ADMIRAL           = { contribution = 10000, service = 1800 },
	SPYMASTER         = { contribution = 10000, service = 1800 },
	ASSASSIN          = { contribution = 10000, service = 1800 },
	MONOPOLY          = { contribution = 10000, service = 1800 },
	SCIENTIST         = { contribution = 10000, service = 1800 },
	INQUISITOR        = { contribution = 10000, service = 1800 },
	]]
}

DefaultCharaPromoteMethod = 
{
	OFFICER           = { "CIVIAL_OFFICIAL", "MILITARY_OFFICER" },
	CIVIAL_OFFICIAL   = { "ASSISTANT_MINISTER", "DIPLOMATIC" },
	MILITARY_OFFICER  = { "GENERAL", "CAPTAIN" },
	SPY               = { "AGENT", "MILITARY_OFFICER" },
	TRADER            = { "MERCHANT", "CIVIAL_OFFICIAL" },
	BUILDER           = { "TECHNICIAN", "CIVIAL_OFFICIAL" },
	MISSIONARY        = { "APOSTLE", "CIVIAL_OFFICIAL" },
	
	ASSISTANT_MINISTER= { "PREMIER", "CABINET_MINISTER" },
	DIPLOMATIC        = { "PREMIER", "CABINET_MINISTER" },
	GENERAL           = { "MARSHAL", },
	CAPTAIN           = { "ADMIRAL", },
	AGENT             = { "SPYMASTER", "ASSASSIN" },	
	MERCHANT          = { "MONOPOLY", },	
	TECHNICIAN        = { "SCIENTIST", },
	APOSTLE           = { "INQUISITOR", },

	PREMIER           = {},
	CABINET_MINISTER  = {},
	MARSHAL           = {},
	ADMIRAL           = {},
	SPYMASTER         = {},
	ASSASSIN          = {},
	MONOPOLY          = {},
	SCIENTIST         = {},
	INQUISITOR        = {},
	
	MAYOR             = {},
	EMPEROR           = {},
	KING              = {},
	LORD              = {},
	LEADER            = {},
	CHIEF             = {},
	PRESIDENT         = {},
}

--------------------------------------------------------

--------------------------------------------------------
-- Task

DefaultTaskSteps = 
{
	HARASS_CITY     = { "PREPARE", "EXECUTE", "FINISH", "REPLY" },
	ATTACK_CITY     = { "PREPARE", "EXECUTE", "FINISH", "REPLY" },
	INTERCEPT       = { "PREPARE", "EXECUTE", "FINISH", "REPLY" },
	
	ESTABLISH_CORPS = { "PREPARE", "EXECUTE", "FINISH", "REPLY" },
	REINFORCE_CORPS = { "EXECUTE", "FINISH", "REPLY" },
	DISMISS_CORPS   = { "EXECUTE", "FINISH", "REPLY" },
	TRAIN_CORPS     = { "EXECUTE", "FINISH", "REPLY" },
	DISPATCH_CORPS  = { "PREPARE", "EXECUTE", "FINISH", "REPLY" },
	ENROLL_CORPS    = { "EXECUTE", "FINISH", "REPLY" },
	CONSCRIPT       = { "EXECUTE", "FINISH", "REPLY" },
	RECRUIT         = { "EXECUTE", "FINISH", "REPLY" },

	DEV_AGRICULTURE = { "EXECUTE", "FINISH", "REPLY" },
	DEV_COMMERCE    = { "EXECUTE", "FINISH", "REPLY" },
	DEV_PRODUCTION  = { "EXECUTE", "FINISH", "REPLY" },
	BUILD_CITY      = { "EXECUTE", "FINISH", "REPLY" },
	LEVY_TAX        = { "EXECUTE", "FINISH", "REPLY" },

	HIRE_CHARA      = { "EXECUTE", "FINISH", "REPLY" },
	PROMOTE_CHARA   = { "FINISH", "REPLY" },
	DISPATCH_CHARA  = { "PREPARE", "EXECUTE", "FINISH", },
	CALL_CHARA      = { "PREPARE", "EXECUTE", "FINISH", },

	RECONNOITRE     = { "EXECUTE", "FINISH", "REPLY" },
	SABOTAGE        = { "EXECUTE", "FINISH", "REPLY" },

	RESEARCH        = { "EXECUTE", "FINISH", "REPLY" },

	IMPROVE_RELATION = { "EXECUTE", "FINISH", "REPLY" },
	DECLARE_WAR      = { "PREPARE", "FINISH", "REPLY" },	
	SIGN_PACT        = { "EXECUTE", "FINISH", "REPLY" },
}

DefaultTaskContribution = 
{
	HARASS_CITY     = { success = 200, failed = 0, city_level_ratio = 20 },
	ATTACK_CITY     = { success = 400, failed = 0, city_level_ratio = 20 },
	INTERCEPT       = { success = 300, failed = 0, city_level_ratio = 20 },
	DISPATCH_CORPS  = { success = 20,  failed = 0 },

	ESTABLISH_CORPS = { success = 40, failed = 0, },
	REINFORCE_CORPS = { success = 20, failed = 0 },
	DISMISS_CORPS   = { success = 10, failed = 0 },
	TRAIN_CORPS     = { success = 40, failed = 0 },
	UPGRADE_CORPS   = { success = 40, failed = 0 },
	ENROLL_CORPS    = { success = 20, failed = 0 },
	REGROUP_CORPS   = { success = 40, failed = 0 },

	CONSCRIPT       = { success = 20, failed = 0 },
	RECRUIT         = { success = 20, failed = 0 },

	DEV_AGRICULTURE = { success = 30, failed = 0, work = 1 },
	DEV_COMMERCE    = { success = 30, failed = 0, work = 1 },
	DEV_PRODUCTION  = { success = 30, failed = 0, work = 1 },
	BUILD_CITY      = { success = 50, failed = 0, work = 1 },
	LEVY_TAX        = { success = 40, failed = 0, work = 1 },

	HIRE_CHARA      = { success = 40, failed = 0 },
	PROMOTE_CHARA   = { success = 20, failed = 0 },
	DISPATCH_CHARA  = { success = 20, failed = 0 },
	CALL_CHARA      = { success = 20, failed = 0 },

	RECONNOITRE     = { success = 30, failed = 0 },
	SABOTAGE        = { success = 30, failed = 0 },

	RESEARCH        = { success = 50, failed = 0 },

	IMPROVE_RELATION = { success = 40, failed = 0 },
	DECLARE_WAR      = { success = 10, failed = 0 },
	SIGN_PACT        = { success = 40, failed = 0 },
}

--------------------------------------------------------
-- Relation

DefaultRelationOpinion =
{
	TRUST      = { increment = -1,  def = 500,   min = -500,   max = 1000, time = -1 },

	WAS_AT_WAR = { increment = 1,   def = -400,  min = -1000,  max = 0,    time = 1800 },
	AT_WAR     = { increment = 1,   def = -300,  min = -1000,  max = 0,    time = -1 },
	OLD_ENEMY  = { increment = 1,   def = -500,  min = -500,   max = 0,    time = 3600 },

	NO_WAR     = { increment = -1,  def = 0,     min = 0,      max = 500,  time = 1 },
	TRADE      = { increment = -1,  def = 0,     min = 200,    max = 500,  time = 1 },	
	PROTECT    = { increment = -1,  def = 0,     min = 300,    max = 500,  time = 1 },	
	ALLY       = { increment = -1,  def = 0,     min = 600,    max = 1000, time = 1 },	
}


--pact, time
--prob, has_opinion, no_opinion, duration_above, has_pact, attitude_above
DefaultPactCond = 
{
	{
		pact  = "PEACE",
		time  = 180,
		has_opinion    = "AT_WAR",
		duration_above = 180,
		prob           = 35,
	},
	{
		pact  = "PEACE",
		time  = 180,
		has_opinion    = "AT_WAR",
		duration_above = 360,
		prob           = 70,
	},
	{
		pact  = "PEACE",
		time  = 180,
		has_opinion    = "AT_WAR",
		duration_above = 1080,
		prob           = 95,
	},

	{
		pact  = "NO_WAR",
		time  = 360,
		attitude_above = 300,
		no_opinion = "AT_WAR",
		no_pact = "NO_WAR",
		prob = 80,
	},
	
	{
		pact  = "TRADE",
		time  = 360,
		attitude_above = 300,
		no_opinion = "AT_WAR",
		no_pact = "TRADE",
		prob = 80,
	},

	{
		pact  = "PROTECT",
		time  = 36000,
		attitude_above = 500,
		no_opinion = "AT_WAR",
		no_pact = "PROTECT",
		prob = 80,
	},

	{
		pact  = "ALLY",
		time  = 1080,
		attitude_above = 600,
		no_opinion = "AT_WAR",
		no_pact = "ALLY",
		prob = 80,
	},
}

--------------------------------------------------------
--Chara

DefaultCharaTrait = 
{
	LIBIDO       =
	{
		SELFISH       = 40,
		IRRITABLE     = 40,
		INSIDIOUS     = 40,
		DISPASSIONATE = -40,		
		LOVE_MONEY    = 40,
		LOVE_HONOR    = 40,
	},
	SEXLESS     =
	{
		SELFISH       = 40,
		AGGRESSIVE    = 60,
		CONSERVATIVE  = 100,
		IRRITABLE     = -40,
		INSIDIOUS     = 40,
		IRRITABLE     = -40,
		DISPASSIONATE = 40,
		LOVE_MONEY    = -40,
		LOVE_HONOR    = -40,
	},

	IDEAL        =
	{
		AGGRESSIVE    = 20,
		HARDWORK      = 40,
		CAREFUL       = -50, 
		CARELESS      = 50,
		INSIDIOUS     = -40,
		NOBEL         = 50,
		INSIDIOUS     = 20,
		DISPASSIONATE = -40,
		LOVE_MONEY    = -40,
		LOVE_HONOR    = -40,
	},
	REALISM      =
	{
		CONSERVATIVE  = 20,
		HARDWORK      = 40,
		CAREFUL       = 50, 
		CARELESS      = -50,
		INSIDIOUS     = 40,
		NOBEL         = -50,
		INSIDIOUS     = -20,
		DISPASSIONATE = 40,
		LOVE_MONEY    = 50,
		LOVE_HONOR    = 50,
	},
	ACTIVELY     =
	{
		AGGRESSIVE   = 50,
		HARDWORK     = 20,
		IRRITABLE    = 30,
		CONSERVATIVE = -100,
		LOVE_MONEY    = 20,
		LOVE_HONOR    = 20,
		HARDWORK      = 40,
		LAZY          = -20,
	},
	PASSIVE      =
	{
		CONSERVATIVE  = 50,
		LAZY          = 20,
		DISPASSIONATE = 30,
		AGGRESSIVE    = -100,
		HARDWORK      = -100,
		LOVE_MONEY    = -20,
		LOVE_HONOR    = -20,
	},
	STRONG       =
	{
		CAREFUL       = -50,
		CARELESS      = 50,
		IRRITABLE     = 40,
		LOVE_MONEY    = 20,
		LOVE_HONOR    = 20,
		SMART         = -40,
		FOOLISH       = -40,
	},
	WEAK         =
	{
		CAREFUL       = 50,
		CARELESS      = -50,
		IRRITABLE     = -40,
		SMART         = 40,
		FOOLISH       = -40,
	},
	INTROVERT    =
	{
		CAREFUL       = 50,
		CARELESS      = -50,
		IRRITABLE     = -50,
		DISPASSIONATE = 50,
		LOVE_HONOR    = 40,
	},
	EXTROVERT    =
	{
		CARELESS      = 50,
		CAREFUL       = -50,
		IRRITABLE     = 40,
		DISPASSIONATE = -40,
		LOVE_MONEY    = 40,
		LOVE_HONOR    = 40,
	},
}

--"prerequisite" means these condition should always be satisfied
--"traits" means one of every subset conditions should be satisfied
DefaultCharaSkill = 
{
	{
		id=2000, name="HR expert",
		effects = { HIRE_CHARA_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits  = { { "OPEN" } },
	},

	{
		id=3010, name="Agri expert",
		effects = { AGRICULTURE_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits  = { { "HARDWORK" } },
	},
	{
		id=3020, name="Comm expert",
		effects = { COMMERCE_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits  = { { "HARDWORK" } },
	},
	{
		id=3030, name="Prod expert",
		effects = { PRODUCTION_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits  = { { "HARDWORK" } },
	},
	{
		id=3040, name="Builder expert",
		effects = { BUILD_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits = { { "HARDWORK" } },
	},
	{
		id=3050, name="Tax expert",
		effects = { LEVY_TAX_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits = { { "HARDWORK" } },
	},

	{
		id=4010, name="SCOUT expert",
		effects = { RECONNOITRE_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits = { { "HARDWORK" } },
	},
	{
		id=4020, name="SPY expert",
		effects = { SABOTAGE_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits = { { "INSIDIOUS" } },
	},

	{
		id=5010, name="dipl expert",
		effects = { IMPROVE_RELATION_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits = { { "SMART" } },
	},
	{
		id=5020, name="pact expert",
		effects = { SIGN_PACT_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits = { { "INSIDIOUS" } },
	},

	{
		id=6010, name="tech expert",
		effects = { RESEARCH_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits = { { "CAREFUL" } },
	},

	{
		id=7010, name="atk expert",
		effects = { ATTACK = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits = { { "AGGRESSIVE" } },
	},
	{
		id=7020, name="def expert",
		effects = { DEFEND = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits = { { "CONSERVATIVE" } },
	},
	{
		id=7110, name="field expert",
		effects = { FIELD_COMBAT_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits = { { "STRONG", "INSIDIOUS" } },
	},
	{
		id=7120, name="siege expert",
		effects = { SIEGE_COMBAT_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits = { { "STRONG", "CAREFUL" } },
	},
}

DefaultTraitData = 
{
	{

	},
}

--------------------------------------------------------

DefaultTechData = 
{
	{
		id = 100, type = TechType.WEAPON, workload = 1000,		
	},
	{
		id = 101, type = TechType.WEAPON, workload = 3000,
		prerequisite = { tech = { 100, 110 }, },
	},
	{
		id = 102, type = TechType.WEAPON, workload = 5000,
		prerequisite = { tech = { 101, 111 }, },
	},

	{
		id = 110, type = TechType.ARMOR, workload = 1000,
	},
	{
		id = 111, type = TechType.ARMOR, workload = 3000,
		prerequisite = { tech = { 100, 110 }, },
	},
	{
		id = 112, type = TechType.ARMOR, workload = 5000,
		prerequisite = { tech = { 101, 111 }, },
 	},
	
	{
		id = 120, type = TechType.ORGNIZATION, workload = 1000,		
	},
	{
		id = 121, type = TechType.ORGNIZATION, workload = 3000,
		prerequisite = { tech = { 120 } },
	},
	{
		id = 122, type = TechType.ORGNIZATION, workload = 5000,
		prerequisite = { tech = { 121 } },
	},

	{
		id = 200, type = TechType.AGRICULTURE, workload = 1000,
	},
	{
		id = 201, type = TechType.AGRICULTURE, workload = 3000,
		prerequisite = { tech = { 200 } },
	},
	{
		id = 202, type = TechType.AGRICULTURE, workload = 5000,
		prerequisite = { tech = { 201 } },
	},

	{
		id = 210, type = TechType.COMMERCE, workload = 1000,		
	},
	{
		id = 211, type = TechType.COMMERCE, workload = 3000,
		prerequisite = { tech = { 210 } },
	},
	{
		id = 212, type = TechType.COMMERCE, workload = 5000,
		prerequisite = { tech = { 211 } },
	},

	{
		id = 220, type = TechType.PRODUCTION, workload = 1000,
	},
	{
		id = 221, type = TechType.PRODUCTION, workload = 3000,
		prerequisite = { tech = { 220 } },
	},
	{
		id = 222, type = TechType.PRODUCTION, workload = 5000,
		prerequisite = { tech = { 221 } },
	},
}