
----------------------------------------------
-- City population structure

DefaultCityPopuPleb = 
{
	ALL      = 1,
	FARMER   = 1,
	WORKER   = 1,
	MERCHANT = 1,
}

DefaultCityPopuHarvest = 
{
	FARMER   = 100,
}
DefaultCityPopuConsumeFood = 
{
	RESERVES = 2,
	--SOLDIER  = 2,

	OFFICER  = 1,
	BACHELOR = 1,
	GUARD    = 1,

	NOBEL    = 100,
}

DefaultCityPopuSalary = 
{
	RESERVES = 10,
	--SOLDIER  = 10,

	OFFICER  = 5,
	BACHELOR = 5,
	GUARD    = 5,

	NOBLE    = 100,
}
DefaultCityPopuPersonalTax = 
{
	FARMER   = 1,
	WORKER   = 1,
	MERCHANT = 1,

	MIDDLE   = 2,

	RICH     = 20,
}
DefaultCityPopuCommerceTax = 
{
	FARMER   = 1,
	WORKER   = 1,
	MERCHANT = 1,
}
DefaultCityPopuTradeTax = 
{
	MERCHANT = 5,
}
DefaultCityPopuProduce = 
{
	WORKER   = 1,
}
DefaultCityPopuTransport = 
{
	WORKER   = 10,
}

DefaultCityPopuInit = 
{
	RESERVES = { min = 60, max = 120 },

	HOBO     = { min = 60, max = 240 },
	CHILDREN = { min = 60, max = 120 },
	OLD      = { min = 60, max = 120 },	

	MIDDLE   = { min = 80, max = 120 },

	BACHELOR = { min = 40, max = 120 },
	OFFICER  = { min = 40, max = 120 },

	RICH     = { min = 20, max = 120 },
	NOBLE    = { min = 20, max = 120 },
}


--IMPT, affect initialize of the population structure
DefaultCityPopuNeed = 
{
	RESERVES = { req = 0.02, max = 0.1 },

	HOBO     = { req = 0.05, max = 0.1 },
	CHILDREN = { req = 0.15, max = 0.3 },
	OLD      = { req = 0.05, max = 0.2 },	

	MIDDLE   = { req = 0.05, max = 0.2 },

	OFFICER  = { req = 0.05, max = 0.05 },
	BACHELOR = { req = 0.01, max = 0.05 },
	GUARD    = { req = 0.01, max = 0.02 },

	RICH     = { req = 0.005, max = 0.01 },
	NOBLE    = { req = 0.001, max = 0.005 },
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

DefaultCityPopuPerUnit =
{
	FARMER   = 40,  --need farmer per agriculture
	WORKER   = 20,  --need worker per production
	MERCHANT = 10,  --need merchant per commerce
}

DefaultCityPopuConv = 
{
	{ from = "CHILDREN", to = "HOBO",     ratio = 0.018, force_conv = true },

	--low to high
	{ from = "HOBO",     to = "FARMER",   sec_more_than = 40, prob = 90, sec = -1 },
	{ from = "HOBO",     to = "WORKER",   sec_more_than = 40, prob = 80, sec = -1 },
	{ from = "HOBO",     to = "MERCHANT", sec_more_than = 40, prob = 70, sec = -1 },

	{ from = "FARMER",   to = "MIDDLE",   sat_more_than = 60, prob = 30, sec = -1  },
	{ from = "WORKER",   to = "MIDDLE",   sat_more_than = 60, prob = 35, sec = -1  },
	{ from = "MERCHANT", to = "MIDDLE",   sat_more_than = 60, prob = 40, sec = -1  },

	{ from = "MIDDLE",   to = "OFFICER",  sat_more_than = 60, prob = 35 },
	{ from = "MIDDLE",   to = "BACHELOR", sat_more_than = 70, prob = 25 },
	{ from = "MIDDLE",   to = "RICH",     sat_more_than = 75, prob = 20 },

	--high to low
	{ from = "FARMER",   to = "HOBO", sec_less_than = 40, prob = 40, force_conv = true },
	{ from = "WORKER",   to = "HOBO", sec_less_than = 40, prob = 40, force_conv = true },
	{ from = "MERCHANT", to = "HOBO", sec_less_than = 40, prob = 40, force_conv = true },
	{ from = "MIDDLE",   to = "HOBO", sec_less_than = 30, prob = 30, force_conv = true },

	{ from = "OFFICER",  to = "MIDDLE", sat_less_than = 40, prob = 20, force_conv = true },
	{ from = "BACHELOR", to = "MIDDLE", sat_less_than = 35, prob = 20, force_conv = true },
	{ from = "RICH",     to = "MIDDLE", sat_less_than = 30, sec_less_than = 30, prob = 10, force_conv = true },
	{ from = "NOBLE",    to = "MIDDLE", sat_less_than = 25, sec_less_than = 25, prob = 10, force_conv = true },
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

DefaultCityPopuStructureParams = 
{
	[1] = 
	{
		IS_PLEB      = DefaultCityPopuPleb,
		POPU_HARVEST = DefaultCityPopuHarvest,
		POPU_PRODUCE = DefaultCityPopuProduce,
		POPU_TRANSPORT    = DefaultCityPopuTransport,
		POPU_PERSONAL_TAX = DefaultCityPopuPersonalTax,	
		POPU_COMMERCE_TAX = DefaultCityPopuCommerceTax,
		POPU_TRADE_TAX    = DefaultCityPopuTradeTax,
		POPU_SALARY       = DefaultCityPopuSalary,
		POPU_CONSUME_FOOD = DefaultCityPopuConsumeFood,

		--use to initialize population structure in city
		POPU_INIT         = DefaultCityPopuInit,
		
		--reveal the productive of the scenario time
		POPU_PER_UNIT     = DefaultCityPopuPerUnit,
		
		--reveal the manpower requirement of each job in the city
		POPU_NEED_RATIO   = DefaultCityPopuNeed,
		POPU_MENTAL_RATIO = DefaultCityPopuMental,		
		POPU_MENTAL_MAX   = DefaultCityPopuMentalMax,		
		POPU_MENTAL_MIN   = DefaultCityPopuMentalMin,

		POPU_CONV_COND    = DefaultCityPopuConv,
	},
}

DefaultCityDevelopParams =
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

DefaultCityDevelopmentVaryParams = 
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
