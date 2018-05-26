TEST_BaseData = 
{
	start_date = { year  = 184, month = 1, day   = 1, beforeChrist = true },
}

TEST_MapData = 
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

RouteTest_CityData =
{
	--test
	--  1   2
	--3   4   5
	--  6   7
	[1] = 
	{
		name = "Left-Top",
		coordinate = { x = 1, y = 1 },
		adjacents = { 3 },
	},
	[2] = 
	{
		name = "Right-Top",
		coordinate = { x = 5, y = 1 },
		adjacents = { 5 },
	},
	[3] = 
	{
		name = "Left",
		coordinate = { x = 1, y = 3 },
		adjacents = { 1, 4, 6 },
	},
	[4] = 
	{
		name = "Center",
		coordinate = { x = 3, y = 3 },
		adjacents = { 3, 5 },
	},
	[5] = 
	{
		name = "Right",
		coordinate = { x = 5, y = 3 },
		adjacents = { 2, 7 },
	},
	[6] = 
	{
		name = "Left-Bottom",
		coordinate = { x = 1, y = 5 },
		adjacents = { 3 },
	},
	[7] = 
	{
		name = "Right-Bottom",
		coordinate = { x = 5, y = 5 },
		adjacents = { 5 },
	},
	--]]
}

TEST_CityData = 
{
	[100] = 
	{
		name = "Test City10",
		coordinate = { x = 5, y = 6 },
		level = 10,
		money    = 10000,
		material = 10000,
		adjacents = { 101 },
		defenses = { 15000, 10000, 15000 },
		charas = { 100, 101, 102, 103, 104 },
	},
	[101] = 
	{
		name = "Test City6",
		coordinate = { x = 10, y = 6 },
		level = 6,
		money    = 10000,
		material = 10000,
		adjacents = { 100, 102 },
		defenses = { 15000, 10000, 15000 },
		charas = {},
	},
	[102] = 
	{
		name = "Test City14",
		coordinate = { x = 15, y = 6 },
		level = 14,
		money    = 10000,
		material = 10000,
		adjacents = { 101, 103 },
		defenses = { 15000, 10000, 15000 },
		charas = {},
	},
	[103] = 
	{
		name = "Test City2",
		coordinate = { x = 20, y = 6 },
		level = 2,
		money    = 10000,
		material = 10000,
		adjacents = { 102, 104 },
		defenses = { 15000, 10000, 15000 },
		charas = {},
	},
	[104] = 
	{
		name = "Test City18",
		coordinate = { x = 25, y = 6 },
		level = 18,
		money    = 10000,
		material = 10000,
		adjacents = { 103 },
		defenses = { 15000, 10000, 15000 },
		charas = {},
	},
}

TEST_CharaData = 
{
	[100] = 
	{
		name = "Liu Bang",
		birth       = 150,
		ability     = 60,
		potential   = 80,
		grade       = "BEST",
		purpose     = 0,
		job         = "LEADER",
		home        = 100,
		skills      = { 1000, 1030 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
	[101] = 
	{
		name = "Zhang Liang",	
		birth       = 150,
		ability     = 60,
		potential   = 80,
		grade       = "PERFECT",
		purpose     = 0,
		job 		= "",	
		home        = 100,
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
		potential   = 80,
		grade       = "PERFECT",
		purpose     = 0,
		job 		= "",		
		home        = 100,
		skills      = { 1000, 1030 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
	[103] = 
	{
		name = "Xiao He",	
		birth       = 150,
		ability     = 60,
		potential   = 80,
		grade       = "BEST",
		purpose     = 0,
		job         = "",
		home        = 100,
		skills      = { 1000, 1030 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
	[104] = 
	{
		name = "Chen Pin",	
		birth       = 150,
		ability     = 60,
		potential   = 80,
		grade       = "BEST",
		purpose     = 0,
		job         = "",
		home        = 100,
		skills      = { 1000, 1030 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
}


TEST_GroupData =
{
	[1] =
	{
		name = "HAN",
		--goals = { { type="TERRIORITY", target = 1 } },
		leader = 100,
		capital = 100,
		cities = { 100 },
		charas = { 100, 101, 102, 103, 104 },
		troops = {},
		corps = {},
		relations = {  },
		tags = {
			{ type = "MILITANT", value = 6 },
		}
	},
}

TEST_TroopTable = 
{
}

TEST_CorpsTemplate =
{
}

TEST_WeaponTable = 
{
}