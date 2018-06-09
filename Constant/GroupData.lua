-------------------------------------------------------
--  Group government

GroupGovernmentData = 
{
	NONE          = {},
	KINGDOM       =
	{
		CAPITAL_CHARA_LIMIT = 12,
		TROOP_NUMBER_LV     = 2,
	},
	EMPIRE        =
	{
		CAPITAL_CHARA_LIMIT = 12,
		TROOP_NUMBER_LV     = 3,
	},
	REGION        =
	{
		CAPITAL_CHARA_LIMIT = 8,
		TROOP_NUMBER_LV     = 1,
	},
	FAMILY        =
	{
		CAPITAL_CHARA_LIMIT = 8,
		TROOP_NUMBER_LV     = 0,
	},
	GUERRILLA     =
	{
		CAPITAL_CHARA_LIMIT = 6,
		TROOP_NUMBER_LV     = 0,
	},
	WARZONE       =
	{
		CAPITAL_CHARA_LIMIT = 6,
		TROOP_NUMBER_LV     = 1,
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