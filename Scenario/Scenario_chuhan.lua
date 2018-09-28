CHUHAN_BaseData = 
{
	start_date = { year  = 205, month = 1, day   = 1, beforeChrist = false },
}

CHUHAN_MapData = 
{
	width  = 32,
	height = 20,
	plots  = nil,

	plotTypes = 
	{
		{ id = 1000, desc = "landPlain",     prob = 3000 },	
		{ id = 1100, desc = "landGrass",     prob = 3000 },
		{ id = 1200, desc = "landDesert",    prob = 800 },
		{ id = 1300, desc = "landTundra",    prob = 400 },		
		{ id = 2000, desc = "hillPlain",     prob = 3500 },
		{ id = 2100, desc = "hillGrass",     prob = 3500 },
		{ id = 2200, desc = "hillDesert",    prob = 600 },
		{ id = 2300, desc = "hillTundra",    prob = 300 },		
		{ id = 3000, desc = "mountainPlain", prob = 1000 },
		{ id = 4000, desc = "lake",          prob = 500 },
	},

	strategicResources =
	{
		{ id=100, percent=8, },--copper
		{ id=101, percent=5, },--iron
		{ id=120, percent=5, },--horse
	},

	bonusResources =
	{
		{ id=200, percent=10, },--rice
		{ id=201, percent=8, },--wheat
		{ id=205, percent=3, },--salt
		{ id=206, percent=8, },--fertile
		{ id=207, percent=3, },--infertile
	},

	luxuryResources = 
	{
		{ id=300, percent=5, },--silver
		{ id=301, percent=2, },--gold
	},

	artificialResources = 
	{
		{ id=500, percent=20, }--settlement
	}
}

CHUHAN_CharaData =
{
	[100] = 
	{
		name = "Liu Bang",
		birth       = 150,
		ability     = 60,
		potential   = 85,
		grade       = "BEST",
		purpose     = 0,
		job         = "LEADER",
		skills      = {},
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
		traits      = { OPEN = 80, GENEROUS = 80, FRIENDSHIP = 80, CONFIDENCE = 80, CAREFUL = 60, GREED = 80, VOLUBLE = 80, },
	},
	[101] = 
	{
		name = "Zhang Liang",	
		birth       = 150,
		ability     = 60,
		potential   = 95,
		grade       = "PERFECT",
		purpose     = 0,
		job 		= "",
		skills      = { 1000, 1030 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},	
	[102] = 
	{
		name = "Han Xin",	
		birth       = 150,
		ability     = 60,
		potential   = 95,
		grade       = "PERFECT",
		purpose     = 0,
		job 		= "",
		skills      = { 7200, 7300, 7400, 7410, 7500, 10001 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
	[103] = 
	{
		name = "Xiao He",	
		birth       = 150,
		ability     = 60,
		potential   = 90,
		grade       = "BEST",
		purpose     = 0,
		job         = "",
		skills      = {  },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
		traits      = { SELFISH = 100 },
	},
	[104] = 
	{
		name = "Chen Pin",	
		birth       = 150,
		ability     = 60,
		potential   = 90,
		grade       = "BEST",
		purpose     = 0,
		job         = "",
		skills      = {  },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },		
	},

	[200] = 
	{
		name = "Xiang Yu",
		level       = 8,
		birth       = 150,
		ability     = 50,
		potential   = 95,	
		grade       = "PERFECT",	
		purpose     = 0,		
		job         = "LEADER",
		skills      = { 7000, 7020, 7200, 7400, 7410, 7500, 10000 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
		traits      = { AGGRESSIVE = 80, AMBITION = 80, STRENGTH = 80, AGILITY = 60, BRAVE = 80 },
	},
	[201] = 
	{
		name = "Fan Zeng",
		birth       = 150,
		ability     = 50,
		potential   = 90,
		grade       = "BEST",
		purpose     = 0,	
		skills      = {  },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
	[202] = 
	{
		name = "Long ju",
		birth       = 150,
		ability     = 50,
		potential   = 85,
		grade       = "BEST",
		purpose     = 0,	
		skills      = {  },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
	[203] = 
	{
		name = "Zhong Limei",		
		birth       = 150,
		ability     = 50,
		potential   = 85,
		grade       = "BEST",
		purpose     = 0,	
		skills      = { },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
	[204] = 
	{
		name = "Ji Bu",		
		birth       = 150,
		ability     = 50,
		potential   = 90,
		grade       = "BEST",
		purpose     = 0,	
		skills      = {  },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
}

CHUHAN_CityData = 
{
	--  1 --- 2
	-- /       \
	--3  --4--  5
	-- \       /
	--  6 --- 7
	--[[
	[1] = 
	{
		name = "XianYan",
		coordinate = { x = 12, y = 6 },
		--adjacents = { 2, 3 },
		adjacents = { 3 },
		level = 14,

		defenses = { 15000, 10000, 15000 },
		constrs  = { 4000, },
	},
	[2] = 
	{
		name = "LinZi",
		coordinate = { x = 24, y = 6 },
		--adjacents = { 1, 5 },
		adjacents = { 5 },
		level = 14,

		defenses = { 15000, 10000, 15000 },
		constrs  = { 4000, },
	},
	]]
	[3] = 
	{
		name = "GuanZhong",
		coordinate = { x = 6, y = 12 },
		--adjacents = { 1, 4, 6 },
		adjacents = { 4 },
		level = 12,		
		charas = { 100, 101, 102, 103, 104 },

		defenses = { 15000, 10000, 15000 },
		constrs  = { 4000, },
	},
	[4] = 
	{
		name = "PengChen",
		coordinate = { x = 18, y = 12 },
		adjacents = { 3, 5 },
		level = 13,

		defenses = { 15000, 10000, 15000 },
		constrs  = { 4000, },
	},
	[5] = 
	{
		name = "KuaiJi",
		coordinate = { x = 30, y = 12 },
		--adjacents = { 2, 4, 7 },
		adjacents = { 4 },
		level = 12,

		charas = { 200, 201, 202, 203 },
		defenses = { 15000, 10000, 15000 },
		constrs  = { 4000, },
	},
	--[[
	[6] = 
	{
		name = "JinZhou",
		coordinate = { x = 12, y = 18 },
		--adjacents = { 3, 7 },
		adjacents = { 3 },
		level = 12,

		defenses = { 15000, 10000, 15000 },
		constrs  = { 4000, },
	},
	[7] = 
	{
		name = "JiuJiang",
		coordinate = { x = 24, y = 18 },
		--adjacents = { 5, 6 },
		adjacents = { 5 },
		level = 10,

		defenses = { 15000, 10000, 15000 },
		constrs  = { 4000, },
	},
	]]
}

CHUHAN_GroupData =
{
	[1] =
	{
		name = "HAN",
		goals = { { type="TERRIORITY", target = 1 } },
		leader = 100,
		capital = 3,
		cities = { 3 },
		charas = { 100, 101, 102, 103, 104 },
		troops = {},
		corps = {},
		relations = {  },
		tags = {
			{ type = "MILITANT", value = 6 },
		}
	},
	[2] =
	{
		name = "CHU",
		goals = { { type="DOMINATION", target = 1 } },
		leader = 200,
		capital = 5,
		cities = { 5 },
		charas = { 200, 201, 202, 203 },
		troops = {},
		corps = {},
		relations = {  },
	},
}

CHUHAN_GroupRelationData = 
{
}

---------------------------------
--
--[[]]
CHUHAN_WeaponTable = 
{
	[10] = { name = "fork",      level = "1", dmg = "NORMAL",    range = "CLOSE",   power = 40, accuracy = 25,  duration = 30, },
	[20] = { name = "sword",     level = "3", dmg = "NORMAL",    range = "CLOSE",   power = 35, accuracy = 35,  duration = 30, },
	[30] = { name = "spear",     level = "3", dmg = "PIERCE",    range = "LONG",    power = 30, accuracy = 45,  duration = 30, },
	[31] = { name = "lance",     level = "4", dmg = "PIERCE",    range = "LONG",    power = 50, accuracy = 40,  duration = 30, },
	[40] = { name = "bow",       level = "4", dmg = "PIERCE",    range = "MISSILE", power = 20, accuracy = 25,  duration = 20, },
	[41] = { name = "slingshot", level = "2", dmg = "NORMAL",    range = "MISSILE", power = 10, accuracy = 30,  duration = 20, },
	[50] = { name = "stone",     level = "5", dmg = "FORTIFIED", range = "MISSILE", power = 80, accuracy = 80,  duration = 20, },
	[51] = { name = "ram",       level = "5", dmg = "FORTIFIED", range = "CLOSE",   power = 50, accuracy = 100, duration = 20, },
}
--]]
--[[
CHUHAN_WeaponTable = 
{
	[10] = { name = "fork",      level = "2", weight = 120, sharpness = 80,  attributes = {} },
	[20] = { name = "sword",     level = "4", weight = 100, sharpness = 100, attributes = {} },
	[30] = { name = "spear",     level = "4", weight = 150, sharpness = 50,  attributes = {} },
	[31] = { name = "lance",     level = "5", weight = 200, sharpness = 50,  attributes = {} },
	[40] = { name = "bow",       level = "4", weight = 40,  sharpness = 80,  attributes = {} },
	[41] = { name = "slingshot", level = "3", weight = 80,  sharpness = 20,  attributes = {} },
	[41] = { name = "stone",     level = "4", weight = 500, sharpness = 0,   attributes = { accuracy = 0.1 } },
	[41] = { name = "ram",       level = "4", weight = 600, sharpness = 0,   attributes = { accuracy = 0 } },
}
]]

---------------------------------

CHUHAN_TroopTable = 
{
}

CHUHAN_CorpsTemplate =
{
}


--[[
	Trigger
		it's conditions for trigger

		NO_CD: -1 means event won't trigger when it's in CD		
		PROB:  probability in ten thousands
		HAS_FLAG:
		NO_FLAG :
		SET_CD:    SPECIAL! it'll set a CD timer
		SET_FLAG:

	Effects
		It's effects after event triggered, 

		CD: -1 means self, other id means flag
		SECURITY: Affect city security
		SATISFACTION: Affect city satisfaction

	
--]]
CHUHAN_EventData = 
{
	[100] = 
	{
		type     = EventType.DISASTER,
		target   = "CITY",
		trigger  = { { NO_EVT_CD = -1 }, { PROB = 1000 }, { SET_EVT_CD = 30 }, },
		effects  = { { SECURITY = -10 }, { SATISFACTION = -10 }, { SET_EVT_CD = 100 }, { SET_EVT_FLAG = EventFlag.EVT_TRIGGER_THIS_TURN } },
	},
	[101] = 
	{
		type     = EventType.WARFARE,
		target   = "CITY",
		trigger  = { { NO_EVT_CD = -1 }, { PROB = 1000 }, { NO_EVT_FLAG = EventFlag.EVT_TRIGGER_THIS_TURN }, { SET_EVT_CD = 30 } },
		effects  = { { SECURITY = -10 }, { SATISFACTION = -5 }, { SET_EVT_CD = 100 } },
	},	
	[200] = 
	{
		type     = EventType.DISEASE,
		target   = "CHARA",
		triggers = { { NO_EVT_CD = -1 }, },
	},
}