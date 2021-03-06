RTK_BaseData = 
{
	start_date = { year  = 184, month = 1, day   = 1, beforeChrist = true },
}

RTK_MapData = 
{
	width  = 70,
	height = 70,
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

RTK_CharaData =
{
	[100] = 
	{
		name = "Liu Bei",
		birth       = 150,
		ability     = 60,
		potential   = 80,
		grade       = "BEST",
		purpose     = 0,
		job         = "LEADER",
		home        = 1000,
		skills      = { 1000, 1030 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
	[101] = 
	{
		name = "Zhuge Liang",	
		birth       = 150,
		ability     = 60,
		potential   = 80,
		grade       = "PERFECT",
		purpose     = 0,
		job 		= "",	
		home        = 1000,
		skills      = { 1000, 1030 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},	
	[102] = 
	{
		name = "Guan Yu",	
		birth       = 150,
		ability     = 60,
		potential   = 80,
		grade       = "PERFECT",
		purpose     = 0,
		job 		= "",		
		home        = 1000,
		skills      = { 1000, 1030 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
	[103] = 
	{
		name = "Zhang Fei",	
		birth       = 150,
		ability     = 60,
		potential   = 80,
		grade       = "BEST",
		purpose     = 0,
		job         = "",
		home        = 1000,
		skills      = { 1000, 1030 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
	--[[
	[200] = 
	{
		name = "Cao cao",
		birth       = 150,
		ability     = 50,
		potential   = 90,	
		grade       = "PERFECT",	
		purpose     = 0,		
		job         = "LEADER",
		home        = 201,
		skills      = { 1001, 1010, 1040 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
	[201] = 
	{
		name = "Xun Yu",
		birth       = 150,
		ability     = 50,
		potential   = 90,
		grade       = "BEST",
		purpose     = 0,	
		home        = 201,	
		skills      = { 1001, 1010, 1040 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
	[202] = 
	{
		name = "XiaHou Yuan",
		birth       = 150,
		ability     = 50,
		potential   = 90,
		grade       = "BEST",
		purpose     = 0,	
		home        = 201,	
		skills      = { 1001, 1010, 1040 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
	[203] = 
	{
		name = "XiaHou Dun",		
		birth       = 150,
		ability     = 50,
		potential   = 90,
		grade       = "BEST",
		purpose     = 0,	
		home        = 201,	
		skills      = { 1001, 1010, 1040 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
	
	[300] = 
	{
		name = "Sun Quan",
		birth       = 150,
		ability     = 50,
		potential   = 90,
		grade       = "BEST",
		purpose     = 0,	
		job         = "LEADER",	
		home        = 500,	
		skills      = { 1001, 1010, 1040 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
	[301] = 
	{
		name = "Zhou Yu",
		birth       = 150,
		ability     = 50,
		potential   = 90,
		grade       = "PERFECT",
		purpose     = 0,
		job         = "LEADER",	
		home        = 500,		
		skills      = { 1001, 1010, 1040 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},	
	[302] = 
	{
		name = "Taishi ci",
		birth       = 150,
		ability     = 50,
		potential   = 90,	
		grade       = "BEST",	
		purpose     = 0,	
		job         = "LEADER",	
		home        = 500,		
		skills      = { 1001, 1010, 1040 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
	[303] = 
	{
		name = "Gan Lin",
		birth       = 150,
		ability     = 50,
		potential   = 90,
		grade       = "BEST",
		purpose     = 0,	
		job         = "LEADER",	
		home        = 500,		
		skills      = { 1001, 1010, 1040 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
	--]]
}

RTK_CityData = 
{
	--North of HuangHe
	[100] = 
	{
		name = "Dai Xiang",
		coordinate = { x = 66, y = 6 },
		level = 10,
		
		adjacents = { 101 },
		defenses = { 15000, 10000, 15000 },
	},
	[101] = 
	{
		name = "Bei Ping",
		coordinate = { x = 66, y = 9 },
		level = 10,
		
		adjacents = { 100, 103 },
		defenses = { 1500, 1000, 1500 },
	},
	[102] = 
	{
		name = "Jing Yang",
		coordinate = { x = 42, y = 12 },
		level = 8,		
		
		adjacents = { 104 },
		defenses = { 1500, 1000, 1500 },
	},
	[103] = 
	{
		name = "Nan Pi",
		coordinate = { x = 54, y = 15 },
		level = 10,
		
		adjacents = { 101, 104 },
		defenses = { 1500, 1000, 1500 },
	},
	[104] = 
	{
		name = "Ye",
		coordinate = { x = 42, y = 18 },
		level = 11,
		
		adjacents = { 102, 103, 200 },
		defenses = { 1500, 1000, 1500 },
	},
	
	--Middle 
	[200] = 
	{
		name = "Chen Liu",
		coordinate = { x = 54, y = 27 },
		level     = 11,
		manpower  = 10000,
		officers  = { 200, 201, 202, 203 },
		adjacents = { 104, 201, 300, 400 },
		defenses  = { 1500, 1000, 1500 },
	},
	[201] = 
	{
		name = "Xu Chang",
		coordinate = { x = 54, y = 33 },
		level = 10,
		
		adjacents = { 200, 202, 401 },
		defenses = { 1500, 1000, 1500 },
	},
	[202] = 
	{
		name = "Shou Chun",
		coordinate = { x = 60, y = 39 },
		level = 10,
		
		adjacents = { 201, 301, 500, 601 },
		defenses = { 1500, 1000, 1500 },
	},
	
	--East 	
	[300] = 
	{
		name = "Xu Zhou",
		coordinate = { x = 66, y = 30 },
		level = 9,
		
		adjacents = { 200, 301, 302 },
		defenses = { 1500, 1000, 1500 },
	},
	[301] = 
	{
		name = "Xia Pi",
		coordinate = { x = 66, y = 33 },
		level = 7,
		
		adjacents = { 202, 300 },
		defenses = { 1500, 1000, 1500 },
	},
	[302] = 
	{
		name = "Bei Hai",
		coordinate = { x = 60, y = 27 },
		level = 8,
		
		adjacents = { 300 },
		defenses = { 1500, 1000, 1500 },
	},
	
	--Capital
	[400] = 
	{
		name = "Luo Yang",
		coordinate = { x = 42, y = 27 },
		level = 15,
		
		adjacents = { 200, 402 },
		defenses = { 1500, 1000, 1500 },
	},
	[401] = 
	{
		name = "Nan Yang",
		coordinate = { x = 42, y = 33 },
		level = 10,
		
		adjacents = { 201, 600 },
		defenses = { 1500, 1000, 1500 },
	},
	[402] = 
	{
		name = "Chang An",
		coordinate = { x = 30, y = 27 },
		level = 13,
		
		adjacents = { 400, 800, 900 },
		defenses = { 1500, 1000, 1500 },
	},	
	
	--South
	[500] = 
	{
		name = "Jian Ye",
		coordinate = { x = 60, y = 45 },
		level = 11,
		manpower  = 10000,
		officers  = { 300, 301, 302, 303 },
		adjacents = { 202, 501, 502 },
		defenses  = { 1500, 1000, 1500 },
	},
	[501] = 
	{
		name = "Cai Shang",
		coordinate = { x = 54, y = 48 },
		level = 9,
		
		adjacents = { 500, 601, 602, 700 },
		defenses = { 1500, 1000, 1500 },
	},
	[502] = 
	{
		name = "Gui Ji",
		coordinate = { x = 66, y = 51 },
		level = 10,
		
		adjacents = { 500, 503 },
		defenses = { 1500, 1000, 1500 },
	},
	[503] = 
	{
		name = "Wu",
		coordinate = { x = 66, y = 57 },
		level = 11,
		
		adjacents = { 502 },
		defenses = { 1500, 1000, 1500 },
	},
	
	--Center
	[600] = 
	{
		name = "Xiang Yang",
		coordinate = { x = 36, y = 42 },
		level = 13,
		
		adjacents = { 401, 601, 602, 1001 },
		defenses = { 1500, 1000, 1500 },
	},
	[601] = 
	{
		name = "Jiang Xia",
		coordinate = { x = 48, y = 42 },
		level = 8,
		
		adjacents = { 202, 501, 600, 602 },
		defenses = { 1500, 1000, 1500 },
	},
	[602] = 
	{
		name = "Jiang Ling",
		coordinate = { x = 42, y = 48 },
		level = 9,
		
		adjacents = { 501, 600, 601, 700, 701 },
		defenses = { 1500, 1000, 1500 },
	},
	
	--South Four state
	[700] = 
	{
		name = "Chang Sha",
		coordinate = { x = 48, y = 54 },
		level = 10,
		
		adjacents = { 501, 602, 701, 702 },
		defenses = { 1500, 1000, 1500 },
	},
	[701] = 
	{
		name = "Ling Ling",
		coordinate = { x = 36, y = 54 },
		level = 6,
		
		adjacents = { 602, 700, 702, 1001 },
		defenses = { 1500, 1000, 1500 },
	},
	[702] = 
	{
		name = "Gui Yang",
		coordinate = { x = 42, y = 60 },
		level = 6,
		
		adjacents = { 700, 701 },
		defenses = { 1500, 1000, 1500 },
	},
	
	[800] = 
	{
		name = "Hong Nong",
		coordinate = { x = 18, y = 21 },
		level = 7,
		
		adjacents = { 402, 801, 900 },
		defenses = { 1500, 1000, 1500 },
	},
	[801] = 
	{
		name = "Tian Shui",
		coordinate = { x = 12, y = 15 },
		level = 4,
		
		adjacents = { 800, 802 },
		defenses = { 1500, 1000, 1500 },
	},
	[802] = 
	{
		name = "An Ding",
		coordinate = { x = 6, y = 12 },
		level = 3,
		
		adjacents = { 801 },
		defenses = { 1500, 1000, 1500 },
	},
	
	[900] = 
	{
		name = "Han Zhong",
		coordinate = { x = 24, y = 33 },
		level = 11,
		
		adjacents = { 402, 800, 901 },
		defenses = { 1500, 1000, 1500 },
	},
	[901] = 
	{
		name = "Zhi Tong",
		coordinate = { x = 18, y = 36 },
		level = 6,
		
		adjacents = { 900, 1000 },
		defenses = { 1500, 1000, 1500 },
	},
	
	[1000] = 
	{
		name = "Cheng Du",
		coordinate = { x = 15, y = 42 },
		level = 13,
		manpower  = 10000,
		officers  = { 100, 101, 102, 103 },
		adjacents = { 901, 1001, 1002 },
		defenses  = { 1500, 1000, 1500 },
	},
	[1001] = 
	{
		name = "Jiang Zhou",
		coordinate = { x = 30, y = 48 },
		level = 8,
		
		adjacents = { 600, 701, 1000 },
		defenses = { 1500, 1000, 1500 },
	},
	[1002] = 
	{
		name = "Jian Ling",
		coordinate = { x = 12, y = 54 },
		level = 6,
		
		adjacents = { 1000, 1003 },
		defenses = { 1500, 1000, 1500 },
	},
	[1003] = 
	{
		name = "Yong An",
		coordinate = { x = 9, y = 57 },
		level = 5,
		
		adjacents = { 1002, 1004 },
		defenses = { 1500, 1000, 1500 },
	},
	[1004] = 
	{
		name = "Yun Nan",
		coordinate = { x = 6, y = 63 },
		level = 6,
		
		adjacents = { 1003 },
		defenses = { 1500, 1000, 1500 },
	},
}

RTK_GroupData =
{
	[1] =
	{
		name = "SHU",
		goals = { { type="TERRIORITY", target = 1 } },
		leader = 100,
		capital = 1000,
		cities = { 1000 },		
		charas = { 100, 101, 102, 103 },
		troops = {},
		corps = {},
		relations = {  },
		tags = {
			{ type = "MILITANT", value = 6 },
		}
	},
	[2] =
	{
		name = "WEI",
		goals = { { type="DOMINATION", target = 1 } },
		leader = 200,
		capital = 200,
		cities = { 200 },
		charas = { 200, 201, 202, 203 },
		troops = {},
		corps = {},
		relations = {  },
	},
	[3] =
	{
		name = "WU",
		goals = { { type="DOMINATION", target = 1 } },
		leader = 300,		
		money = 10000,
		capital = 500,
		cities = { 500 },
		charas = { 300, 301, 302, 303 },
		troops = {},
		corps = {},		
		relations = {  },
	},
}

RTK_GroupRelationData = 
{
--[[
	[10] = 
	{
		--QIN VS QI
		sid=1, tid=2, evaluation=0, type="FRIEND", skills      = {}			
	},
	[11] = 
	{
		--QIN VS CHU
		sid=1, tid=3, evaluation=0, type="ENEMY", skills      = {}			
	},
	[12] = 
	{
		--QIN VS WEI
		sid=1, tid=4, evaluation=0, type="BELLIGERENT", skills      =
		{
			{ type = "OLD_ENEMY", id = 0, value = 5 },
		}
	},
	]]
}

---------------------------------
--

RTK_WeaponTable = 
{
}


---------------------------------
-- Melee / Shoot / Charge / Siege / Armor
--	
--
--
-- SS = 110 / S = 95 / A = 85 / B = 75 / C = 65 / D = 45 / E = 30 / F = -999
--
-- requirment.MIN_SOLDER should be restricted by TroopConstant
RTK_TroopTable = 
{
}

RTK_CorpsTemplate =
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
RTK_EventData = 
{
}