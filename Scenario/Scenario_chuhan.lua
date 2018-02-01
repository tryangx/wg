CHUHAN_BaseData = 
{
	start_date = { year  = 205, month = 1, day   = 1, beforeChrist = false },
}

CHUHAN_MapData = 
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

CHUHAN_CharaData =
{
	[100] = 
	{
		name = "Liu Bang",
		birth       = 150,
		ability     = 60,
		potential   = 80,
		grade       = "BEST",
		purpose     = 0,
		job         = "KING",
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

	[200] = 
	{
		name = "Xiang Yu",
		birth       = 150,
		ability     = 50,
		potential   = 90,	
		grade       = "PERFECT",	
		purpose     = 0,		
		job         = "KING",
		home        = 200,
		skills      = { 1001, 1010, 1040 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
	[201] = 
	{
		name = "Fan Zeng",
		birth       = 150,
		ability     = 50,
		potential   = 90,
		grade       = "BEST",
		purpose     = 0,	
		home        = 200,	
		skills      = { 1001, 1010, 1040 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
	[202] = 
	{
		name = "Long ju",
		birth       = 150,
		ability     = 50,
		potential   = 90,
		grade       = "BEST",
		purpose     = 0,	
		home        = 200,	
		skills      = { 1001, 1010, 1040 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
	[203] = 
	{
		name = "Zhong Limei",		
		birth       = 150,
		ability     = 50,
		potential   = 90,
		grade       = "BEST",
		purpose     = 0,	
		home        = 200,	
		skills      = { 1001, 1010, 1040 },
		politics    = { 0, 10, 1000 },
		strategy    = { 0, 10, 1000 },
		tactic      = { 0, 10, 1000 },
	},
}

CHUHAN_CityData = 
{
	[100] = 
	{
		name = "Guan Zhong",
		coordinate = { x = 60, y = 6 },
		level = 10,
		charas = { 100, 101, 102, 103 },		
		adjacents = { 200 },
		defenses = { 15000, 10000, 15000 },
	},
	[200] = 
	{
		name = "Peng Chen",
		coordinate = { x = 66, y = 6 },
		level = 10,
		charas = { 200, 201, 202, 203 },
		adjacents = { 100 },
		defenses = { 15000, 10000, 15000 },
	},
}

CHUHAN_GroupData =
{
	[1] =
	{
		name = "HAN",
		goals = { { type="DOMINATION_TERRIORITY", target = 100 } },
		leader = 100,
		capital = 100,
		cities = { 100 },		
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
		name = "CHU",
		goals = { { type="DOMINATION_TERRIORITY", target = 100 } },
		leader = 200,
		capital = 200,
		cities = { 200 },
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

---------------------------------
-- Melee / Shoot / Charge / Siege / Armor
--	
--
--
-- SS = 110 / S = 95 / A = 85 / B = 75 / C = 65 / D = 45 / E = 30 / F = -999
--
-- requirment.MIN_SOLDER should be restricted by TroopConstant
CHUHAN_TroopTable = 
{
	[1] =
	{
		name      = "Strong", category  = "INFANTRY", conveyance = "FOOT",
		melee = 90, shoot = 90, charge = 90, siege = 90, armor = 90, toughness = 90, movement  = 25,
		skills    = {},
		potential = 20,
		capacity = { FOOD = 300, MATERIAL = 100 },
		consume = { FOOD = 10, MONEY = 10, },		
		requirement = { MONEY = 1, MATERIAL = 1, SOLDIER = 1, MIN_SOLDIER = 100 },
		weapons = { 10 },
	},
	[2] =
	{
		name      = "Weak", category  = "INFANTRY", conveyance = "FOOT",
		melee = 25, shoot = 25, charge = 25, siege = 25, armor = 25, toughness = 20, movement  = 25,		
		skills    = {},
		potential = 20,
		capacity = { FOOD = 300, MATERIAL = 100 },
		consume = { FOOD = 10, MONEY = 10, },		
		requirement = { MONEY = 1, MATERIAL = 1, SOLDIER = 1, MIN_SOLDIER = 100 },
		weapons = { 30 },
	},

	[10] =
	{
		name      = "Military", category  = "INFANTRY", conveyance = "FOOT",
		melee = 25, shoot = 25, charge = 25, siege = 0, armor = 25, toughness = 20, movement  = 25,		
		skills    = {},
		potential = 20,
		capacity = { FOOD = 300, MATERIAL = 100 },
		consume = { FOOD = 10, MONEY = 10, },		
		requirement = { MONEY = 1, MATERIAL = 1, SOLDIER = 1, MIN_SOLDIER = 100 },
		weapons = { 10 },
	},

	[11] =
	{	
		name      = "Guard", category  = "INFANTRY", conveyance = "FOOT",
		melee = 35, shoot = 30, charge = 30, siege = 0, armor = 35, toughness = 35, movement  = 25,
		skills    = {},
		potential = 20,
		capacity = { FOOD = 300, MATERIAL = 100 },
		consume = { FOOD = 10, MONEY = 5, },
		requirement = { MONEY = 1, MATERIAL = 1, SOLDIER = 1, MIN_SOLDIER = 100 },
		weapons = { 30 },
	},

	[100] =
	{
		name      = "Footman", category  = "INFANTRY", conveyance = "FOOT",
		melee = 50, shoot = 35, charge = 40, siege = 0, armor = 50, toughness = 45, movement  = 25,
		skills    = {},
		potential = 25,
		capacity = { FOOD = 300, MATERIAL = 100 },
		consume = { FOOD = 10, MONEY = 15, },		
		requirement = { MONEY = 1, MATERIAL = 1, SOLDIER = 1, MIN_SOLDIER = 100 },
		weapons = { 20 },
	},
	[101] =
	{
		name      = "Regular Footman", category  = "INFANTRY", conveyance = "FOOT",
		melee = 75, shoot = 0, charge = 65, siege = 0, armor = 65, toughness = 60, movement  = 20,
		skills    = {},
		potential = 30,
		capacity = { FOOD = 300, MATERIAL = 100 },
		consume = { FOOD = 10, MONEY = 20, },		
		requirement = { MONEY = 1, MATERIAL = 1, SOLDIER = 1, MIN_SOLDIER = 100 },
		weapons = { 30 },
	},	
	
	-- SS = 110 / S = 95 / A = 85 / B = 75 / C = 65 / D = 45 / E = 30 / F = -999
	[200] =
	{
		name      = "Archer", category  = "MISSILE_UNIT", conveyance = "FOOT",
		melee = 45, shoot = 75, charge = 0, siege = 0, armor = 60, toughness = 55, movement  = 25,
		skills    = {},
		potential = 25,
		capacity = { FOOD = 300, MATERIAL = 100 },
		consume = { FOOD = 10, MONEY = 16, },
		requirement = { MONEY = 1, MATERIAL = 1, SOLDIER = 1, MIN_SOLDIER = 100 },
		weapons = { 20, 40 },
	},

	[300] =
	{
		name      = "Scout", category  = "CAVALRY", conveyance = "HORSE",
		melee = 45, shoot = 35, charge = 45, siege = 0, armor = 40, toughness = 55, movement  = 90,
		skills    = {},
		potential = 25,
		capacity = { FOOD = 300, MATERIAL = 100 },
		consume = { FOOD = 10, MONEY = 28, },		
		requirement = { MONEY = 1, MATERIAL = 1, SOLDIER = 1, MIN_SOLDIER = 100 },
		weapons = { 20, 41 },
	},
	[301] =
	{
		name      = "Cavalry", category  = "CAVALRY", conveyance = "HORSE",
		melee = 75, shoot = 0, charge = 85, siege = 0, armor = 85, toughness = 80, movement  = 65,
		skills    = {},
		potential = 40,
		capacity = { FOOD = 300, MATERIAL = 100 },
		consume = { FOOD = 20, MONEY = 60, },		
		requirement = { MONEY = 1, MATERIAL = 1, SOLDIER = 1, MIN_SOLDIER = 100 },
		weapons = { 31 },
	},	
	--[[
	[310] =
	{
		name      = "Chariot", category  = "CAVALRY", conveyance = "CHARIOT",
		melee = 50, shoot = 30, charge = 90, siege = 50, armor = 65, toughness = 70, movement  = 45,
		skills    = {},
		potential = 35,
		consume = { FOOD = 40, MONEY = 100, POPULATION = 3 },		
		requirement = { MONEY = 90, MATERIAL = 120, TECH = 999 },
	},
	]]
	[400] =
	{
		name      = "BatteringRam", category  = "SIEGE_WEAPON", conveyance = "FOOT",
		melee = 35, shoot = 0, charge = 0, siege = 85, armor = 85, toughness = 60, movement  = 20,
		skills    = {},
		potential = 40,
		consume = { FOOD = 10, MONEY = 120, },		
		requirement = { MONEY = 1, MATERIAL = 1, TECH = 999, SOLDIER = 1, MIN_SOLDIER = 100 },
		weapons = { 51 },
	},
	[401] =
	{
		name      = "Catapult", category  = "SIEGE_WEAPON", conveyance = "FOOT",
		melee = 35, shoot = 80, charge = 0, siege = 80, armor = 85, toughness = 60, movement  = 15,
		skills    = {},
		potential = 40,
		consume = { FOOD = 10, MONEY = 150, },		
		requirement = { MONEY = 1, MATERIAL = 1, TECH = 999, SOLDIER = 1, MIN_SOLDIER = 100 },
		weapons = { 50 },
	},
}

CHUHAN_CorpsTemplate =
{
	--[[
	{
		prob = 50, purpose = CorpsPurpose.FIELD_COMBAT,
		priority_troop_category = 
		{
			{ category = TroopCategory.INFANTRY,     number = 2, },
			{ category = TroopCategory.CAVALRY,      number = 0, },
			{ category = TroopCategory.MISSILE_UNIT, number = 0, },
			{ category = TroopCategory.SIEGE_WEAPON, number = 0, },
		},
		tendency_troop_category = 
		{
			{ prob = 50, category = TroopCategory.INFANTRY },
			{ prob = 50, category = TroopCategory.MISSILE_UNIT },
		},
	},
	]]

	{
		prob = 50, purpose = CorpsPurpose.FIELD_COMBAT,
		priority_troop_category = 
		{
			{ category = TroopCategory.INFANTRY,     number = 2, },
			{ category = TroopCategory.MISSILE_UNIT, number = 2, },
			{ category = TroopCategory.INFANTRY,     number = 1, },
			{ category = TroopCategory.MISSILE_UNIT, number = 1, },
			{ category = TroopCategory.CAVALRY,      number = 2, },
		},
		tendency_troop_category = 
		{
			{ prob = 50, category = TroopCategory.INFANTRY },
			{ prob = 35, category = TroopCategory.MISSILE_UNIT },
			{ prob = 15, category = TroopCategory.CAVALRY },
		},
	},

	{
		prob = 50, purpose = CorpsPurpose.SIEGE_COMBAT,
		min_troop_category = 
		{
			INFANTRY     = 2,
			CAVALRY      = 0,
			MISSILE_UNIT = 0,
			SIEGE_WEAPON = 2,
		},
	},
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

CHUHAN_PolicyData = 
{
	[100] = 
	{

	},
}