----------------------------------------------
-- City population structure
--
-- Feature:
--
-- Abbreviate
--
-- AGRI * 100 -> POPULATION
-- AGRI * 65  -> FARMER
-- FARMER * 2 -> FOOD 
--

CityParams = 
{
	ISOLATE_DURATION_MODULUS = 10,
}

DefaultCitySupply =
{
	------------------------------
	--Agriculture

	--measure 1 argiculture can supply how many population
	AGRI_SUPPLY_POPU = 100,

	--measure how many food we can buy by 1 unit money
	FOOD_PER_MONEY   = 30,
}

----------------------------------------------
--Concept: 
--  1. Food Harvest/Consume Unit : 1 means 500 grams( per day )
--  2. One farmer can supply 2 population normally
DefaultCityPopuHarvest = 
{
	FARMER   = 360,
}

--should without SOLDIER
DefaultCityPopuConsumeFood = 
{
	RESERVES = 1,
	GUARD    = 1,
	SOLDIER  = 1,
}

--should without SOLDIER
DefaultCityPopuSalary = 
{
	RESERVES = 1,
	GUARD    = 1,
	SOLDIER  = 1,

	OFFICER  = 1,
	BACHELOR = 1,

	NOBLE    = 100,
}

DefaultCityPopuPersonalTax = 
{
	FARMER   = 1,
	WORKER   = 1,
	MERCHANT = 1,

	MIDDLE   = 2,
}

DefaultCityPopuCommerceTax = 
{
	FARMER   = 0.2,
	WORKER   = 0.5,
	MERCHANT = 1,
}

DefaultCityPopuTradeTax = 
{
	MERCHANT = 10,
}

DefaultCityPopuProduce = 
{
	WORKER   = 1,
}

DefaultCityPopuDevelopCost = 
{
	FARMER   = 0.5,
	WORKER   = 0.5,
	MERCHANT = 0.5,
}

DefaultCityPopuInit = 
{
	RESERVES = { min = 60,  max = 120 },	

	HOBO     = { min = 60,  max = 240 },
	CHILDREN = { min = 60,  max = 120 },
	OLD      = { min = 60,  max = 120 },

	FARMER   = { min = 100, max = 150 },
	WORKER   = { min = 60,  max = 120 },
	MERCHANT = { min = 60,  max = 120 },
	CORVEE   = { min = 40,  max = 80 },

	MIDDLE   = { min = 80,  max = 120 },

	BACHELOR = { min = 40,  max = 120 },
	OFFICER  = { min = 40,  max = 120 },
	GUARD    = { min = 20,  max = 80 },

	RICH     = { min = 20,  max = 120 },
	NOBLE    = { min = 20,  max = 120 },
}

--IMPT, affect initialize of the population structure
--  req   : means percent of population
--  limit : means maximum percent of population
DefaultCityPopuNeed = 
{
	PLEB     = { req = 0.5,   limit = 0.8 },

	RESERVES = { req = 0.005, limit = 0.02 },

	HOBO     = { req = 0.005, limit = 0.1 },
	CHILDREN = { req = 0.15,  limit = 0.35 },
	OLD      = { req = 0.05,  limit = 0.3 },	

	FARMER   = { req = 0.65,  limit = 0.8 },
	WORKER   = { req = 0.1,   limit = 0.3 },
	MERCHANT = { req = 0.05,  limit = 0.15 },
	CORVEE   = { req = 0.05,  limit = 0.1 },

	MIDDLE   = { req = 0.05,  limit = 0.2 },

	BACHELOR = { req = 0.005, limit = 0.01 },
	OFFICER  = { req = 0.005, limit = 0.01 },	
	GUARD    = { req = 0.005, limit = 0.01 },

	RICH     = { req = 0.005, limit = 0.01 },
	NOBLE    = { req = 0.001, limit = 0.005 },
}

DefaultCityPopuMental = 
{
	SOLDIER  = 400,

	--affect SECURITY
	HOBO     = -100,
	OFFICER  = 200,	

	--affect SATISFACTION
	MIDDLE   = 200,

	RICH     = 600,
	NOBLE    = 1000,
}

DefaultCityPopuMentalMax = 
{
	SOLDIER  = 35,

	--affect SECURITY
	HOBO     = 0,
	OFFICER  = 20,
	
	--affect SATISFACTION
	MIDDLE   = 20,

	RICH     = 20,
	NOBLE    = 20,
}

DefaultCityPopuMentalMin = 
{
	--affect SECURITY
	HOBO     = -20,
}


--[[
	need_popu
	prob


--]]
DefaultCityPopuConv = 
{
	--guard 
	{ from = "HOBO",     to = "GUARD",    need_popu = "GUARD", prob = 50, sec = -1 },

	{ from = "CHILDREN", to = "HOBO",     ratio = 0.018, force_conv = true },

	--low to high
	{ from = "HOBO",     to = "FARMER",   need_popu = "FARMER", sec_more_than = 40, prob = 90, sec = -1, debug = 1 },
	{ from = "HOBO",     to = "WORKER",   need_popu = "WORKER", sec_more_than = 40, prob = 80, sec = -1, debug = 1  },
	{ from = "HOBO",     to = "MERCHANT", need_popu = "MERCHANT", sec_more_than = 40, prob = 70, sec = -1, debug = 1  },
	{ from = "HOBO",     to = "CORVEE",   sec_more_than = 40, prob = 60, sec = -1, debug = 1 },

	{ from = "FARMER",   to = "MIDDLE",   sat_more_than = 60, prob = 30, sec = -1  },
	{ from = "WORKER",   to = "MIDDLE",   sat_more_than = 60, prob = 35, sec = -1  },
	{ from = "MERCHANT", to = "MIDDLE",   sat_more_than = 60, prob = 40, sec = -1  },

	{ from = "MIDDLE",   to = "OFFICER",  sat_more_than = 60, prob = 35 },
	{ from = "MIDDLE",   to = "BACHELOR", sat_more_than = 70, prob = 25 },
	{ from = "MIDDLE",   to = "RICH",     sat_more_than = 75, prob = 20 },	

	--high to low
	{ from = "FARMER",   to = "HOBO",     sec_less_than = 40, prob = 40, force_conv = true },
	{ from = "WORKER",   to = "HOBO",     sec_less_than = 40, prob = 40, force_conv = true },
	{ from = "MERCHANT", to = "HOBO",     sec_less_than = 40, prob = 40, force_conv = true },
	{ from = "MIDDLE",   to = "HOBO",     sec_less_than = 30, prob = 30, force_conv = true },
	{ from = "MIDDLE",   to = "CORVEE",   sec_more_than = 40, prob = 30, force_conv = true },

	{ from = "OFFICER",  to = "MIDDLE",   sat_less_than = 40, prob = 20, force_conv = true },
	{ from = "BACHELOR", to = "MIDDLE",   sat_less_than = 35, prob = 20, force_conv = true },
	{ from = "RICH",     to = "MIDDLE",   sat_less_than = 30, sec_less_than = 30, prob = 10, force_conv = true },
	{ from = "NOBLE",    to = "MIDDLE",   sat_less_than = 25, sec_less_than = 25, prob = 10, force_conv = true },
}

--rate unit is 1 per 10000
DefaultCityConscript = 
{
	{ from = "HOBO",     to = "RESERVES", prob = 100, min_rate = 10, max_rate = 20 },
	{ from = "FARMER",   to = "RESERVES", prob = 80,  min_rate = 10, max_rate = 20 },
	{ from = "WORKER",   to = "RESERVES", prob = 80,  min_rate = 10, max_rate = 20 },
	{ from = "MERCHANT", to = "RESERVES", prob = 80,  min_rate = 10, max_rate = 20 },
	{ from = "MIDDLE",   to = "RESERVES", prob = 50,  min_rate = 10, max_rate = 20 },
}

--rate unit is 1 per 1000
DefaultCityRecruit =
{
	{ from = "HOBO",     to = "RESERVES", prob = 100, min_rate = 5, max_rate = 15 },
	{ from = "FARMER",   to = "RESERVES", prob = 100, min_rate = 5, max_rate = 15 },
	{ from = "WORKER",   to = "RESERVES", prob = 100, min_rate = 5, max_rate = 15 },
	{ from = "MERCHANT", to = "RESERVES", prob = 100, min_rate = 5, max_rate = 15 },	
}

DefaultCityHireGuard =
{
	{ from = "HOBO",     to = "GUARD", prob = 100, min_rate = 5, max_rate = 15 },
	{ from = "FARMER",   to = "GUARD", prob = 50, min_rate = 5, max_rate = 15 },
	{ from = "WORKER",   to = "GUARD", prob = 50, min_rate = 5, max_rate = 15 },
	{ from = "MERCHANT", to = "GUARD", prob = 50, min_rate = 5, max_rate = 15 },	
	{ from = "MIDDLE",   to = "GUARD", prob = 20, min_rate = 5, max_rate = 15 },	
}

DefaultCityJobProb = 
{
	{ prob = 40, job = "COMMANDER",  max = 5 },
	{ prob = 30, job = "AFFAIRS",    max = 3 },
	{ prob = 30, job = "STAFF",      max = 2 },	
	{ prob = 20, job = "HR",         max = 2 },	
	{ prob = 20, job = "DIPLOMATIC", capital = 1 },
	{ prob = 20, job = "TECHNICIAN", capital = 1 },
}

DefaultCityPopuStructureParams = 
{
	[1] = 
	{
		POPU_SUPPLY       = DefaultCitySupply,
		POPU_HARVEST      = DefaultCityPopuHarvest,
		POPU_PRODUCE      = DefaultCityPopuProduce,
		POPU_PERSONAL_TAX = DefaultCityPopuPersonalTax,	
		POPU_COMMERCE_TAX = DefaultCityPopuCommerceTax,
		POPU_TRADE_TAX    = DefaultCityPopuTradeTax,
		POPU_SALARY       = DefaultCityPopuSalary,
		POPU_CONSUME_FOOD = DefaultCityPopuConsumeFood,
		POPU_DEVELOP_COST = DefaultCityPopuDevelopCost,

		--use to initialize population structure in city
		POPU_INIT         = DefaultCityPopuInit,
		POPU_NEED_RATIO   = DefaultCityPopuNeed,

		--reveal the manpower requirement of each job in the city		
		POPU_MENTAL_RATIO = DefaultCityPopuMental,		
		POPU_MENTAL_MAX   = DefaultCityPopuMentalMax,		
		POPU_MENTAL_MIN   = DefaultCityPopuMentalMin,

		POPU_CONV_COND    = DefaultCityPopuConv,
	},
}

DefaultCityDevelopResult =
{
	{
		conditions = { progress_min = 100 },
		methods = 
		{
			{ prob = 50, main = 6, agri = 0,  comm = 0, prod = 0, },
			{ prob = 50, main = 5, agri = 1,  comm = 1, prod = 0, },
			{ prob = 50, main = 5, agri = 1,  comm = 0, prod = 1, },
			{ prob = 50, main = 5, agri = 0,  comm = 1, prod = 1, },
			{ prob = 50, main = 7, agri = 0,  comm = -1, prod = -1, },
			{ prob = 50, main = 7, agri = -1, comm = 0, prod = -1, },
			{ prob = 50, main = 7, agri = -1, comm = -1, prod = 0, },
		},
	},
	{
		conditions = { progress_min = 50 },
		methods =
		{
			{ prob = 50, main = 4, agri = 0,  comm = 0, prod = 0, },
			{ prob = 50, main = 3, agri = 1,  comm = 1, prod = 0, },
			{ prob = 50, main = 3, agri = 1,  comm = 0, prod = 1, },
			{ prob = 50, main = 3, agri = 0,  comm = 1, prod = 1, },
			{ prob = 50, main = 5, agri = 0,  comm = -1, prod = -1, },
			{ prob = 50, main = 5, agri = -1, comm = 0, prod = -1, },
			{ prob = 50, main = 5, agri = -1, comm = -1, prod = 0, },
		},
	},
	{
		conditions = { progress_min = 0 },
		methods =
		{
			{ prob = 50, main = 2, agri = 0,  comm = 0, prod = 0, },
			{ prob = 50, main = 1, agri = 1,  comm = 1, prod = 0, },
			{ prob = 50, main = 1, agri = 1,  comm = 0, prod = 1, },
			{ prob = 50, main = 1, agri = 0,  comm = 1, prod = 1, },
			{ prob = 50, main = 3, agri = 0,  comm = -1, prod = -1, },
			{ prob = 50, main = 3, agri = -1, comm = 0, prod = -1, },
			{ prob = 50, main = 3, agri = -1, comm = -1, prod = 0, },
		},
	},
}

DefaultCityDevelopmentVaryResult = 
{
	{
		conditions = { security_more_than = 80, trigger_prob = 50, },
		methods = 
		{
			{ prob = 50, agri = 5, comm = -1, prod = -1, },
			{ prob = 50, agri = -1, comm = 5, prod = -1, },
			{ prob = 50, agri = -1, comm = -1, prod = 5, },

			{ prob = 50, agri = 1 },
			{ prob = 50, comm = 1 },
			{ prob = 50, prod = 1, },

			{ prob = 50, agri = 1, comm = 0, prod = 0, },
			{ prob = 50, agri = 0, comm = 1, prod = 0, },
			{ prob = 50, agri = 1, comm = 1, prod = 1, },
		},		
	},
	{
		conditions = { security_more_than = 60, trigger_prob = 100, },
		methods = 
		{
			{ prob = 50, agri = 2, comm = 1, prod = 0, },
			{ prob = 50, agri = 2, comm = 0, prod = 1, },
			{ prob = 50, agri = 1, comm = 2, prod = 0, },
			{ prob = 50, agri = 0, comm = 2, prod = 1, },
			{ prob = 50, agri = 1, comm = 0, prod = 2, },
			{ prob = 50, agri = 0, comm = 1, prod = 2, },

			{ prob = 50, agri = 0, comm = 0, prod = 2, },
		},
	},
	{
		conditions = { security_more_than = 40, trigger_prob = 100, },
		methods = 
		{
			-- -3 ~ 1
			{ prob = 50, agri = 3, comm = -1, prod = -1, },
			{ prob = 50, agri = -1, comm = 3, prod = -1, },
			{ prob = 50, agri = -1, comm = -1, prod = 3, },
			{ prob = 50, agri = -2, },
			{ prob = 50, comm = -2, },
			{ prob = 50, prod = -2, },
			{ prob = 50, agri = -1, comm = -1, prod = -1, },
		},		
	},
	{
		conditions = { security_more_than = 0, trigger_prob = 100, },
		methods = 
		{
			-- -6 ~ -5
			{ prob = 20, agri = -2, comm = -2, prod = -2, },
			{ prob = 40, agri = -3, comm = -1, prod = -1, },
			{ prob = 40, agri = -1, comm = -3, prod = -1, },
			{ prob = 40, agri = -1, comm = -1, prod = -3, },
		},
	},
	{
		conditions = { insiege = true, trigger_prob = 100, },
		methods = 
		{
			{ prob = 50, agri = -2, comm = -2, prod = -2, },
		},
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
	MIN_GRADE   = 1,
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
	GROWTH_MIN_RATE    = 16,
	GROWTH_MAX_RATE    = 48,

	DEAD_MIN_RATE      = 8,
	DEAD_MAX_RATE      = 24,
}

PlotParams = 
{
	-- [Discard]
	-- 360 * 100 means 1 agr support 100 popu
	-- it relate with CityPopuStructureParams.POPU_PER_UNIT
	--FOOD_PER_AGRICULTURE = 360 * 100,
}

CityLevelParams = 
{
	{
		lv = 1, guard = 100,
	},	
}

--------------------------------------------

--Development( agri / comm / prod )
--Management
--Military
--Defense
--FOREGIN
--
-- duration means how long to build the construction, same as HP
Default_CityBuildingData =
{
	[1000] = 
	{
		name = "Farm Lv1",
		type = "DEVELOPMENT",
		duration = 60,
		effects = {},
		prerequsite = { city_lv = 1, number = 5 },
	},
	[1001] = 
	{
		name = "Farm Lv2",
		type = "DEVELOPMENT",
		duration = 120,
		effects = { TRADE = 5, },
		prerequsite = { city_lv = 5, has_constr = 1000, },
	},
	[1010] = 
	{
		name = "Market Lv1",
		type = "DEVELOPMENT",
		duration = 120,
		effects = { TRADE = 5, },
		prerequsite = { number = 3, },
	},
	[1011] = 
	{
		name = "Market Lv2",
		type = "DEVELOPMENT",
		duration = 180,
		effects = { TRADE = 5, },
		prerequsite = { has_constr = 1010, number = 2 },
	},
	[1012] = 
	{
		name = "Market Lv3",
		type = "DEVELOPMENT",
		duration = 180,
		effects = {},
		prerequsite = { has_constr = 1011, singleton = 1 },
	},
	[1020] = 
	{
		name = "Workshop Lv1",
		type = "DEVELOPMENT",
		duration = 90,
		effects = {},
		prerequsite = { number = 1 },
	},
	[1021] = 
	{
		name = "Workshop Lv2",
		type = "DEVELOPMENT",
		duration = 120,
		effects = {},
		prerequsite = { has_constr = 1020, },
	},

	[2000] = 
	{
		name = "Administration Lv1",
		type = "MANAGEMENT",
		duration = 90,
		effects = {},
		prerequsite = { singleton = 1 },
	},
	[2001] = 
	{
		name = "Administration Lv2",
		type = "MANAGEMENT",
		duration = 320,
		effects = {},
		prerequsite = { has_constr = 2000, singleton = 1 },
	},
	[2003] = 
	{
		name = "Administration Lv2",
		type = "MANAGEMENT",
		duration = 1080,
		effects = {},
		prerequsite = { has_constr = 2001, singletonsingleton = 1 },
	},
	[2010] = 
	{
		name = "Watch Tower",
		type = "MANAGEMENT",
		duration = 120,
		effects = {},
		prerequsite = {},
	},
	[2020] = 
	{
		name = "Inspect Tower",
		type = "MANAGEMENT",
		duration = 120,
		effects = {},
		prerequsite = {},
	},
	[2030] = 
	{
		name = "Prison",
		type = "MANAGEMENT",
		duration = 180,
		effects = {},
		prerequsite = {},
	},
	[2040] = 
	{
		name = "Execution Grand",
		type = "MANAGEMENT",
		duration = 180,
		effects = {},
		prerequsite = {},
	},
	[2050] = 
	{
		name = "Tax Station",
		type = "MANAGEMENT",
		duration = 90,
		effects = {},
		prerequsite = { has_constr = 1020, },
	},

	[3000] = 
	{
		name = "Barrack Lv1",
		type = "MILITARY",
		duration = 15,
		effects = {},
		prerequsite = {},
	},
	[3001] = 
	{
		name = "Barrack Lv1",
		type = "MILITARY",
		duration = 90,
		effects = {},		
		prerequsite = {},
	},
	[3002] = 
	{
		name = "Barrack Lv2",
		type = "MILITARY",
		duration = 180,
		effects = {},		
		prerequsite = { has_constr = 3000 },
	},
	[3010] = 
	{
		name = "Drill Ground",
		type = "MILITARY",
		duration = 180,
		effects = {},		
		prerequsite = { has_constr = 3000 },
	},
	[3020] = 
	{
		name = "Firing Ground",
		type = "MILITARY",
		duration = 180,
		effects = {},
		prerequsite = { has_constr = 3000 },
	},
	[3030] = 
	{
		name = "Jousting Ground",
		type = "MILITARY",
		duration = 180,
		effects = {},		
		prerequsite = { has_constr = 3000 },
	},

	--Defensive
	[4000] = 
	{
		name = "Earthen Wall Lv1",
		type = "DEFENSIVE",
		duration = 15,
		effects = { FORT = 5, },		
	},
	[4001] = 
	{
		name = "Earthen Wall Lv2",
		type = "DEFENSIVE",
		duration = 45,
		effects = { FORT = 10, },
		prerequsite = { has_constr = 4000, },
	},

	[4010] = 
	{
		name = "Stone Wall Lv1",
		type = "DEFENSIVE",
		duration = 90,
		effects = { FORT = 15, },
	},
	[4011] = 
	{
		name = "Stone Wall Lv2",
		type = "DEFENSIVE",
		duration = 180,
		effects = { FORT = 30, },
		prerequsite = { has_constr = 4010, },
	},
	[4012] = 
	{
		name = "Stone Wall Lv3",
		type = "DEFENSIVE",
		duration = 360,
		effects = { FORT = 60, },
		prerequsite = { has_constr = 4011, },
	},

	--Foregin
	[5000] = 
	{
		name = "Embassy Lv1",
		type = "FOREIGN",
		duration = 180,
		effects = {},
		prerequsite = { has_constr = 3000, },
	},
	[5010] = 
	{
		name = "Intelligent Agency Lv1",
		type = "FOREIGN",
		duration = 180,
		effects = {},
		prerequsite = {},
	},
}

CityBuildMethod = 
{
	
}

--def means default value
--min, max means the value range
--normal means the value will approach to it
CitySecurityData = 
{
	OFFICER = { def = 20, min = 0, max = 40, popu_need = "OFFICER" },
	GUARD   = { def = 20, min = 0, max = 40, popu_need = "GUARD" },
	SOLDIER = { def = 20, min = 0, max = 40, popu_bonus = { popu = "SOLDIER", value = 0.01 } },

	PATROL  = { def = 0, normal = 0 },
	EVENT   = { def = 0, normal = 0 },
}

CityDissData = 
{
	FRONTIER    = { def = 0, increment = 1, min = 0, max = 10, status = "FRONTIER" },
	BATTLEFRONT = { def = 0, increment = 1, min = 0, max = 20, status = "BATTLEFRONT" },
	
	IN_SIEGE    = { def = 0, increment = 1, min = 0, max = 40, status = "IN_SIEGE" },
	STARVATION  = { def = 0, increment = 1, min = 0, max = 40, status = "IN_SIEGE" },
	
	LEVY_TAX      = { def = 0, normal = 0, min = 0, max = 100 },
	DEMONSTRATION = { def = 0, normal = 0, min = 0, max = 20 },
	STRIKE        = { def = 0, normal = 0, min = 0, max = 30 },
}