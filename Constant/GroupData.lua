--------------------------------------------------------

DefaultTechData = 
{
	{
		id = 100, name = "", type = TechType.WEAPON, workload = 1000,		
	},
	{
		id = 101, name = "", type = TechType.WEAPON, workload = 3000,
		prerequisite = { techs = { 100, 110 }, },
	},
	{
		id = 102, name = "", type = TechType.WEAPON, workload = 5000,
		prerequisite = { techs = { 101, 111 }, },
	},

	{
		id = 110, type = TechType.ARMOR, workload = 1000,
	},
	{
		id = 111, type = TechType.ARMOR, workload = 3000,
		prerequisite = { techs = { 100, 110 }, },
	},
	{
		id = 112, type = TechType.ARMOR, workload = 5000,
		prerequisite = { techs = { 101, 111 }, },
 	},
	
	{
		id = 120, type = TechType.ORGNIZATION, workload = 1000,		
	},
	{
		id = 121, type = TechType.ORGNIZATION, workload = 3000,
		prerequisite = { techs = { 120 } },
	},
	{
		id = 122, type = TechType.ORGNIZATION, workload = 5000,
		prerequisite = { techs = { 121 } },
	},

	{
		id = 200, type = TechType.AGRICULTURE, workload = 1000,
	},
	{
		id = 201, type = TechType.AGRICULTURE, workload = 3000,
		prerequisite = { techs = { 200 } },
	},
	{
		id = 202, type = TechType.AGRICULTURE, workload = 5000,
		prerequisite = { techs = { 201 } },
	},

	{
		id = 210, type = TechType.COMMERCE, workload = 1000,	
	},
	{
		id = 211, type = TechType.COMMERCE, workload = 3000,
		prerequisite = { techs = { 210 } },
	},
	{
		id = 212, type = TechType.COMMERCE, workload = 5000,
		prerequisite = { techs = { 211 } },
	},

	{
		id = 220, type = TechType.PRODUCTION, workload = 1000,
	},
	{
		id = 221, type = TechType.PRODUCTION, workload = 3000,
		prerequisite = { techs = { 220 } },
	},
	{
		id = 222, type = TechType.PRODUCTION, workload = 5000,
		prerequisite = { techs = { 221 } },
	},
}

GroupParamas = 
{
	INFLUENCE_GRADE =
	{		
		{ influ = 200,  grade = 1 },
		{ influ = 500,  grade = 2 },
		{ influ = 1000, grade = 3 },
		{ influ = 3000, grade = 4 },
		{ influ = 5000, grade = 5 },
	},

	REPUTATION = 
	{
		PARAMS = 
		{
			[10] = { max = 1000, },
			[11] = { max = 1000, },
			[12] = { max = 1000, },
			
			[20] = { max = 1000 },
			[21] = { max = 1000, value = 10 },
			[22] = { max = 1000, value = 10 },
			[23] = { max = 1000, value = 10 },
			
			[30] = { max = 1000, value = 10 },
			[31] = { max = 1000, value = 10 },
		},

		MODIFY = 
		{
			--goal
			ACHIEVE    = { min = 20, max = 50 },
			UNFINISHED = { min = -50, max = -20 },
			--military
			WIN_COMBAT   = { min = 20, max = 100 },
			LOSE_COMBAT  = { min = -100, max = -20 },
		},
	},
}

--government   : means what kinds of government this group grade can declared
--prerequisite: means what kinds of conditions to upgrade to this group grade
--limitation  : means what limitation under this group grade. 
GroupGradeParams = 
{
	{
	    grade        = GroupGrade.LOCAL,
		government   = { "FAMILY", "GUERRILLA", "WARZONE" },
		limitation   = { city = 3 },
	},
	{
		grade        = GroupGrade.REGION,
		government   = { "FAMILY", "WARZONE" },
		prerequisite = { reputation = 100, influence  = 100, grade = "LOCAL", province = 1, city = 3 },
		limitation   = { city = 10, province = 3 },
	},
	{
		grade        = GroupGrade.NATION,
		government   = { "REGION", "KINGDOM" },
		prerequisite = { reputation = 500, influence  = 500, grade = "REGION", province = 3, city = 10 },
		limitation   = { ally_city_ratio_in_continent = 35 },
	},
	{
		grade        = GroupGrade.CONTINENT,
		government   = { "KINGDOM", "EMPIRE" },
		prerequisite = { reputation = 2000, influence  = 2000, grade = "NATION", ally_city_ratio_in_continent = 35, },
		limitation   = { ally_city_ratio_in_world = 35 },
	},
	{
		grade        = GroupGrade.WORLD,
		government   = { "EMPIRE" },
		prerequisite = { reputation = 6000, influence  = 6000, grade = "CONTINENT", ally_city_ratio_in_world = 35, },
		limitation   = {},
	},
}

-------------------------------------------------------
--  Group government

GroupGovernmentData = 
{
	NONE          = {},
	
}