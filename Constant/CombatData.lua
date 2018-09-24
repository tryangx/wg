--------------------------------------------

DefaultCorpsParams = 
{
	MAX_TROOP_NUMBER = 20,
	REQ_TROOP_NUMBER = 8,
}

DefaultTroopParams = 
{
	------------------------------
	--Very Important!!!
	--special temp id
	GUARD_ID          = 11,
	RESERVE_ID        = 12,
	TRANSPORT_ID      = 20,
	------------------------------

	INIT_POTENTIAL    = 10,

	MIN_TROOP_SOLDIER = 100,

	TROOP_POTENTIAL   = 20,

	TROOP_LEVELUP_EXP = 100,

	TROOP_MAX_NUMBER = 
	{
		[0] = 200,
		[1] = 500,
		[2] = 1000,
		[3] = 2000,
		[4] = 4000,
	}
}

--------------------------------------------

DefaultTroopTable = 
{
	--[[
	[1] =
	{
		name      = "Strong", category  = "INFANTRY", conveyance = "FOOT",
		melee = 90, shoot = 90, charge = 90, siege = 90, armor = 90, toughness = 90, movement  = 25,
		skills    = {},
		potential = 20,
		capacity = { FOOD = 100, MATERIAL = 100 },
		consume = { FOOD = 5, MONEY = 10, },		
		requirement = { MONEY = 1, MATERIAL = 1, SOLDIER = 1, MIN_SOLDIER = 100 },
		weapons = { 10 },
	},
	[2] =
	{
		name      = "Weak", category  = "INFANTRY", conveyance = "FOOT",
		melee = 25, shoot = 25, charge = 25, siege = 25, armor = 25, toughness = 20, movement  = 25,		
		skills    = {},
		potential = 20,
		capacity = { FOOD = 100, MATERIAL = 100 },
		consume = { FOOD = 2, MONEY = 10, },		
		requirement = { MONEY = 1, MATERIAL = 1, SOLDIER = 1, MIN_SOLDIER = 100 },
		weapons = { 30 },
	},
]]
	[10] =
	{
		name      = "Military", category  = "INFANTRY", conveyance = "FOOT",
		melee = 25, shoot = 25, charge = 25, siege = 0, armor = 25, toughness = 20, movement  = 25,		
		skills    = {},
		potential = 20,
		capacity = { FOOD = 100, MATERIAL = 100 },
		consume = { FOOD = 2, MONEY = 2, },		
		requirement = { MONEY = 1, MATERIAL = 1, SOLDIER = 1, MIN_SOLDIER = 100 },
		weapons = { 10 },
	},

	[11] =
	{	
		name      = "Guard", category  = "INFANTRY", conveyance = "FOOT",
		melee = 35, shoot = 30, charge = 30, siege = 0, armor = 35, toughness = 35, movement  = 25,
		skills    = {},
		potential = 20,
		capacity = { FOOD = 100, MATERIAL = 100 },
		consume = { FOOD = 2, MONEY = 5, },
		requirement = { MONEY = 1, MATERIAL = 1, SOLDIER = 1, MIN_SOLDIER = 100 },
		weapons = { 30 },
	},

	[12] =
	{
		name      = "Reserves", category  = "INFANTRY", conveyance = "FOOT",
		melee = 25, shoot = 25, charge = 25, siege = 0, armor = 25, toughness = 20, movement  = 25,		
		skills    = {},
		potential = 20,
		capacity = { FOOD = 100, MATERIAL = 100 },
		consume = { FOOD = 2, MONEY = 5, },		
		requirement = { MONEY = 1, MATERIAL = 1, SOLDIER = 1, MIN_SOLDIER = 100 },
		weapons = { 10 },
	},

	[20] = 
	{
		name      = "Transport", category  = "INFANTRY", conveyance = "FOOT",
		melee = 35, shoot = 30, charge = 30, siege = 0, armor = 35, toughness = 35, movement  = 25,
		skills    = {},
		potential = 20,
		capacity = { FOOD = 3000, MATERIAL = 1000, MONEY = 1000 },
		consume = { FOOD = 2, MONEY = 5, },
		requirement = { MONEY = 1, MATERIAL = 1, SOLDIER = 1, MIN_SOLDIER = 100 },
		weapons = { 30 },	
	},

	[100] =
	{
		name      = "Footman", category  = "INFANTRY", conveyance = "FOOT",
		melee = 50, shoot = 35, charge = 40, siege = 0, armor = 50, toughness = 45, movement  = 25,
		skills    = {},
		potential = 25,
		capacity = { FOOD = 100, MATERIAL = 100 },
		consume = { FOOD = 3, MONEY = 10, },		
		requirement = { MONEY = 1, MATERIAL = 1, SOLDIER = 1, MIN_SOLDIER = 100 },
		weapons = { 20 },
	},
	[101] =
	{
		name      = "Regular Footman", category  = "INFANTRY", conveyance = "FOOT",
		melee = 75, shoot = 0, charge = 65, siege = 0, armor = 65, toughness = 60, movement  = 20,
		skills    = {},
		potential = 30,
		capacity = { FOOD = 100, MATERIAL = 100 },
		consume = { FOOD = 4, MONEY = 15, },
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
		capacity = { FOOD = 100, MATERIAL = 100 },
		consume = { FOOD = 4, MONEY = 12, },
		requirement = { MONEY = 1, MATERIAL = 1, SOLDIER = 1, MIN_SOLDIER = 100 },
		weapons = { 20, 40 },
	},

	[300] =
	{
		name      = "Scout", category  = "CAVALRY", conveyance = "HORSE",
		melee = 45, shoot = 35, charge = 45, siege = 0, armor = 40, toughness = 55, movement  = 90,
		skills    = {},
		potential = 25,
		capacity = { FOOD = 200, MATERIAL = 100 },
		consume = { FOOD = 6, MONEY = 20, },		
		requirement = { MONEY = 1, MATERIAL = 1, SOLDIER = 1, MIN_SOLDIER = 100 },
		weapons = { 20, 41 },
	},
	[301] =
	{
		name      = "Cavalry", category  = "CAVALRY", conveyance = "HORSE",
		melee = 75, shoot = 0, charge = 85, siege = 0, armor = 85, toughness = 80, movement  = 65,
		skills    = {},
		potential = 40,
		capacity = { FOOD = 200, MATERIAL = 100 },
		consume = { FOOD = 8, MONEY = 30, },		
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
		consume = { FOOD = 2, MONEY = 15, },		
		requirement = { MONEY = 1, MATERIAL = 1, TECH = 999, SOLDIER = 1, MIN_SOLDIER = 100 },
		weapons = { 51 },
	},
	[401] =
	{
		name      = "Catapult", category  = "SIEGE_WEAPON", conveyance = "FOOT",
		melee = 35, shoot = 80, charge = 0, siege = 80, armor = 85, toughness = 60, movement  = 15,
		skills    = {},
		potential = 40,
		consume = { FOOD = 2, MONEY = 15, },		
		requirement = { MONEY = 1, MATERIAL = 1, TECH = 999, SOLDIER = 1, MIN_SOLDIER = 100 },
		weapons = { 50 },
	},
}

DefaultCorpsTemplate = 
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

--weight   : affect KINECT damage， against TOUGHNESS
--sharpness: affect PIERCE damage, against ARMOR
DefaultWeaponTable = 
{
	[10] = { name = "fork",      level = 1, weight = 15,  sharpness = 15,  range = "CLOSE",   ballistic = "NONE", attributes = {} },
	[20] = { name = "sword",     level = 1, weight = 10,  sharpness = 40,  range = "CLOSE",   ballistic = "NONE", attributes = {} },
	[30] = { name = "spear",     level = 1, weight = 30,  sharpness = 30,  range = "LONG",    ballistic = "NONE", attributes = {} },
	[31] = { name = "lance",     level = 1, weight = 50,  sharpness = 50,  range = "LONG",    ballistic = "NONE", attributes = {} },
	[40] = { name = "bow",       level = 1, weight = 15,  sharpness = 15,  range = "MISSILE", ballistic = "PROJECTTILE", attributes = {} },	
	[41] = { name = "slingshot", level = 1, weight = 15,  sharpness = 5,   range = "MISSILE", ballistic = "FLAT_FIRE", attributes = {} },
	[42] = { name = "crossbow",  level = 1, weight = 15,  sharpness = 30,  range = "MISSILE", ballistic = "FLAT_FIRE", attributes = {} },
	[50] = { name = "stone",     level = 1, weight = 500, sharpness = 100, range = "MISSILE", ballistic = "PROJECTTILE", attributes = {} },
	[51] = { name = "ram",       level = 1, weight = 300, sharpness = 50,  range = "CLOSE",   ballistic = "NONE", attributes = {} },
}

--[[
DefaultWeaponTable = 
{	
	[10] = { name = "fork",      level = "1", dmg = "at_normal",    range = "CLOSE",   power = 40, accuracy = 25,  duration = 30, },
	[20] = { name = "sword",     level = "3", dmg = "at_normal",    range = "CLOSE",   power = 35, accuracy = 35,  duration = 30, },
	[30] = { name = "spear",     level = "3", dmg = "PIERCE",    range = "LONG",    power = 30, accuracy = 45,  duration = 30, },
	[31] = { name = "lance",     level = "4", dmg = "PIERCE",    range = "LONG",    power = 50, accuracy = 40,  duration = 30, },
	[40] = { name = "bow",       level = "4", dmg = "PIERCE",    range = "MISSILE", power = 20, accuracy = 25,  duration = 20, },
	[41] = { name = "slingshot", level = "2", dmg = "at_normal",    range = "MISSILE", power = 10, accuracy = 30,  duration = 20, },
	[50] = { name = "stone",     level = "5", dmg = "FORTIFIED", range = "MISSILE", power = 80, accuracy = 5,  duration = 20, },
	[51] = { name = "ram",       level = "5", dmg = "FORTIFIED", range = "CLOSE",   power = 50, accuracy = 10, duration = 20, },
}
]]

----------------------------------------------------------------------
-- Results

local _tacticResult = nil
local _tacticEnvironment = {}

local function Tactic_SetResult( params )
	_tacticResult = params
end

function Tactic_GetResult()
	return _tacticResult
end

function Tactic_SetEnvironment( key, value )
	_tacticEnvironment[key] = value
end

function Tactic_ClearEnvironment()
	_tacticEnvironment = {}
end

----------------------------------------------------------------------
-- Conditions

local function Tactic_Probability( params )
	local prob = params.prob
	return prob < Random_GetInt_Sync( 1, 100 )
end

local function Tactic_UnderTactic( params )
	return _tacticEnvironment["UNDER_TACTIC"] == params.tacticid
end

----------------------------------------------------------------------

DefaultTacticData = 
{
	[1000] = 
	{
		name = "RAID", category = "ACTIVATE",
		trigger = 
		{
			type = "SEQUENCE", children =
			{
				{ type = "FILTER", condition = Tactic_Probability, params = { prob = 50 } },
			}
		},
		result = 
		{
			type = "SEQUENCE", children =
			{
				{ type = "ACTION", action = Tactic_SetResult, params = { DAMAGE = 150 } },
			}
		},
	},

	[2000] = 
	{
		name = "COUNTER ATTACK", category = "PASSIVE",
		trigger = 
		{
			type = "SEQUENCE", children =
			{
				{ type = "FILTER", condition = Tactic_UnderTactic, params = { tacticid = 1000 } },
			}
		},
		result = 
		{
			type = "SEQUENCE", children =
			{
				{ type = "ACTION", action = Tactic_SetResult, params = { DAMAGE = 150 } },
			}
		},
	},

	[3000] = 
	{
		name = "FAMOUS GENERAL", category = "PERMANENT",
		result = 
		{
			type = "SEQUENCE", children =
			{
				{ type = "ACTION", action = Tactic_SetResult, params = { ATTACK = 120, DEFEND = 120 } },
			}
		},
	},	
}


----------------------------------------------------------------------
-- Battlefield
-- ---------->x+
-- |    DF
-- |
-- V    AT
-- y++

DefaultBattlefieldData = 
{	
	[100] = 
	{
	    --   1  2  3
		--1 DB DC DB
		--2 DF DF DF
		--3 AF AF AF
		--4 AB AC AB
		name = "grassland", width = 3, height = 6,
		grids = {
			{ x=1, y=1, depth=5000, fort = 0, height = 10 },
			{ x=2, y=1, depth=5000, fort = 0, height = 10 },
			{ x=3, y=1, depth=5000, fort = 0, height = 10 },
			{ x=1, y=2, depth=5000, fort = 0, height = 10 },
			{ x=2, y=2, depth=5000, fort = 0, height = 10 },
			{ x=3, y=2, depth=5000, fort = 0, height = 10 },
			{ x=1, y=3, depth=5000, fort = 0, height = 10 },
			{ x=2, y=3, depth=5000, fort = 0, height = 10 },
			{ x=3, y=3, depth=5000, fort = 0, height = 10 },
			{ x=1, y=4, depth=5000, fort = 0, height = 10 },
			{ x=2, y=4, depth=5000, fort = 0, height = 10 },
			{ x=3, y=4, depth=5000, fort = 0, height = 10 },
		},
		defpos = {
			{ x=2, y=2 },
			{ x=1, y=2 },
			{ x=3, y=2 },
			{ x=2, y=1 },
			{ x=1, y=1 },
			{ x=3, y=1 },
		},
		atkpos = {		 
			{ x=2, y=3 },
			{ x=1, y=3 },
			{ x=3, y=3 },
			{ x=2, y=4 },
			{ x=1, y=4 },
			{ x=3, y=4 },
		},
	},
	[200] = 
	{
		--    1  2  3
		-- 1 DF DF DF
		-- 2  x  x  x
		-- 3 AF AF AF
		-- 4 AB AC AB
		name = "camp", width = 3, height = 4,
		grids = {
			{ x=2, y=1, depth=2000, fort = 50, height = 20, isWall = true, defense = 400, },
			{ x=1, y=1, depth=2000, fort = 40, height = 20, isWall = true, defense = 200, },
			{ x=3, y=1, depth=2000, fort = 50, height = 20, isWall = true, defense = 400, },
			{ x=2, y=2, depth=2000, fort = 0, height = 10 },
			{ x=1, y=2, depth=2000, fort = 0, height = 10 },
			{ x=3, y=2, depth=2000, fort = 0, height = 10 },
			{ x=2, y=3, depth=2000, fort = 0, height = 10 },
			{ x=1, y=3, depth=2000, fort = 0, height = 10 },
			{ x=3, y=3, depth=2000, fort = 0, height = 10 },
			{ x=2, y=4, depth=2000, fort = 0, height = 10 },
			{ x=1, y=4, depth=2000, fort = 0, height = 10 },
			{ x=3, y=4, depth=2000, fort = 0, height = 10 },
		},
		defpos = {
			{ x=2, y=1 },
			{ x=1, y=1 },
			{ x=3, y=1 },
		},
		atkpos = {		 
			{ x=2, y=3 },
			{ x=1, y=3 },
			{ x=3, y=3 },
			{ x=2, y=4 },
			{ x=1, y=4 },
			{ x=3, y=4 },
		},
	},		
	[300] = 
	{
		name = "town", width = 3, height = 4,
		grids = {
			{ x=2, y=1, depth=2000, fort = 100, height = 40, isWall = true, defense = 1500, },
			{ x=1, y=1, depth=2000, fort = 80,  height = 40, isWall = true, defense = 1000, },
			{ x=3, y=1, depth=2000, fort = 100, height = 40, isWall = true, defense = 1500, },
			{ x=2, y=2, depth=2000, fort = 0, height = 10 },
			{ x=1, y=2, depth=2000, fort = 0, height = 10 },
			{ x=3, y=2, depth=2000, fort = 0, height = 10 },
			{ x=2, y=3, depth=2000, fort = 0, height = 10 },
			{ x=1, y=3, depth=2000, fort = 0, height = 10 },
			{ x=3, y=3, depth=2000, fort = 0, height = 10 },
			{ x=2, y=4, depth=2000, fort = 0, height = 10 },
			{ x=1, y=4, depth=2000, fort = 0, height = 10 },
			{ x=3, y=4, depth=2000, fort = 0, height = 10 },
		},
		defpos = {
			{ x=2, y=1 },
			{ x=1, y=1 },
			{ x=3, y=1 },
		},
		atkpos = {		 
			{ x=2, y=3 },
			{ x=1, y=3 },
			{ x=3, y=3 },
			{ x=2, y=4 },
			{ x=1, y=4 },
			{ x=3, y=4 },
		},
	},	
}


DefaultFormationData = 
{
	--Cavalry, Archer, Infantry
	--Cavalry, Infantry, Archer
	--
	[100] = 
	{
		name = "YuLin",
		fitWidth = 10,
		fitDepth = 3,
		features = 
		{
			position = ""
		},
	},
}

CombatPurposeParam = 
{
	--casualty, morale, food, proportion
	CONSERVATIVE = 
	{
		ATTITUDE = 
		{
			END_DAY = 60,
		},

		SURRENDER = 
		{
			{ reason = "sr_despair",  is_surrounded = 1, prop_below = 25 },			
			{ reason = "sr_guard",    is_guard = 1, casualty_above = 20, mor_below = 60, score = 100 },
		},
		WITHDRAW = 
		{
			{ reason = "wd_casualty1", casualty_above = 10, score = 10 },
			{ reason = "wd_casualty2", casualty_above = 20, score = 20 },
			{ reason = "wd_casualty3", casualty_above = 35, score = 30 },
			{ reason = "wd_chaos1",    org_below = 50, score = 15 },
			{ reason = "wd_chaos2",    org_below = 20, score = 15 },
			{ reason = "wd_downcast1", mor_below = 60, score = 15 },
			{ reason = "wd_downcast2", mor_below = 40, score = 15 },
			{ reason = "wd_nofood1",  food_below = 20, is_atk = 1,   score = 80 },
			{ reason = "wd_nofood2",  food_below = 30, is_field = 1, score = 60 },
			{ reason = "wd_danger1",   prop_below = 35, score = 10 },
			{ reason = "wd_danger2",   prop_below = 25, score = 10 },
			{ reason = "wd_danger3",   prop_below = 20, score = 20 },			
		},
		REST =
		{
			{ reason = "rt_chaos",    org_below = 60, prob = 50 },
			{ reason = "rt_downcast", mor_below = 60, prob = 50 },
		},
		STORM = 
		{
			{ reason = "st_advantage", prop_above = 75, prob = 60 },
		},
		ATTEND = 
		{
			{ reason = "at_normal",    prepare_above = 75 },
		},
	},

	MODERATE = 
	{
		ATTITUDE = 
		{
			END_DAY = 120,
		},
		SURRENDER = 
		{
			{ reason = "sr_despair", is_surrounded = 1, prop_below = 20 },
			{ reason = "sr_guard",    is_guard = 1, casualty_above = 20, mor_below = 60, score = 100 },
		},
		WITHDRAW = 
		{
			{ reason = "wd_casualty1", casualty_above = 10, score = 10 },
			{ reason = "wd_casualty2", casualty_above = 20, score = 20 },
			{ reason = "wd_casualty3", casualty_above = 35, score = 30 },
			{ reason = "wd_chaos1",    org_below = 50, score = 15 },
			{ reason = "wd_chaos2",    org_below = 20, score = 15 },
			{ reason = "wd_downcast1", mor_below = 60, score = 15 },
			{ reason = "wd_downcast2", mor_below = 40, score = 15 },
			{ reason = "wd_nofood1",   food_below = 20, is_atk = 1,   score = 80 },
			{ reason = "wd_nofood2",   food_below = 30, is_field = 1, score = 60 },
			{ reason = "wd_danger1",   prop_below = 35, score = 10 },
			{ reason = "wd_danger2",   prop_below = 25, score = 10 },
			{ reason = "wd_danger3",   prop_below = 20, score = 20 },
		},
		REST =
		{
			{ reason = "rt_chaos",    org_below = 50, prob = 50 },
			{ reason = "rt_downcast", mor_below = 50, prob = 50 },
		},
		STORM = 
		{
			{ reason = "st_advantage", prop_above = 70, prob = 60 },
		},
		ATTEND = 
		{
			{ reason = "at_normal",    prepare_above = 70 },
		},
	},

	AGGRESSIVE = 
	{
		ATTITUDE = 
		{
			END_DAY = 360,
		},
		SURRENDER = 
		{
			{ reason = "sr_despair", is_surrounded = 1, prop_below = 20 },
			{ reason = "sr_guard",    is_guard = 1, casualty_above = 20, mor_below = 60, score = 100 },
		},
		WITHDRAW = 
		{
			{ reason = "wd_casualty1", casualty_above = 10, score = 10 },
			{ reason = "wd_casualty2", casualty_above = 20, score = 20 },
			{ reason = "wd_casualty3", casualty_above = 35, score = 30 },
			{ reason = "wd_chaos1",    org_below = 50, score = 15 },
			{ reason = "wd_chaos2",    org_below = 20, score = 15 },
			{ reason = "wd_downcast1", mor_below = 60, score = 15 },
			{ reason = "wd_downcast2", mor_below = 40, score = 15 },
			{ reason = "wd_nofood1",  food_below = 20, is_atk = 1,   score = 80 },
			{ reason = "wd_nofood2",  food_below = 30, is_field = 1, score = 60 },
			{ reason = "wd_danger1",   prop_below = 35, score = 10 },
			{ reason = "wd_danger2",   prop_below = 25, score = 10 },
			{ reason = "wd_danger3",   prop_below = 20, score = 20 },
		},
		REST =
		{
			{ reason = "rt_chaos",    org_below = 30, prob = 50 },
			{ reason = "rt_downcast", mor_below = 30, prob = 50 },
		},
		STORM = 
		{
			{ reason = "st_advantage", prop_above = 60, prob = 60 },
		},
		ATTEND = 
		{
			{ reason = "at_normal",    prepare_above = 65 },
		},
	},
}

CombatVictoryPoint =
{
	RESULTS = 
	{
		CAMP_COMBAT = 
		{
			--result minimum condition, descending
			{ ratio = 50, atk = CombatResult.BRILLIANT_VICTORY, def = CombatResult.DISASTROUS_LOSE, winner = 1 },
			{ ratio = 30, atk = CombatResult.STRATEGIC_VICTORY, def = CombatResult.STRATEGIC_LOSE, winner = 0 },
		},

		SIEGE_COMBAT = 
		{
			--result minimum condition, descending
			{ ratio = 50, atk = CombatResult.BRILLIANT_VICTORY, def = CombatResult.DISASTROUS_LOSE, winner = 1 },
			{ ratio = 30, atk = CombatResult.STRATEGIC_VICTORY, def = CombatResult.STRATEGIC_LOSE, winner = 0 },
		},

		FIELD_COMBAT = 
		{
			--result minimum condition, descending
			{ ratio = 50, atk = CombatResult.BRILLIANT_VICTORY, def = CombatResult.DISASTROUS_LOSE, winner = 1 },
			{ ratio = 30, atk = CombatResult.STRATEGIC_VICTORY, def = CombatResult.STRATEGIC_LOSE, winner = 0 },
			--{ ratio = 15, atk = CombatResult.TACTICAL_VICTORY,  def = CombatResult.TACTICAL_LOSE, winner = 0 },
		},		
	},

	BONUS = 
	{
		ACE_MODULUS       = 2,
		
		REPEL_TROOP       = 1,
		NEUTRALIZE_TROOP  = 3,		

		BREAKTHROUGH      = 0.5,

		RETREAT           = 1,
	},
}

CombatStepData =
{
	--standard
	[1] =
	{
		"PREPARE",
		"EMBATTLE",
		"ORDER",
		"INCOMBAT",
	},
}