---------------------------------------------------------------------------------------
--
-- Combat
--
----------------------------------------------------------------------------------------

CombatSide = 
{
	UNKNOWN  = 0,
	NEUTRAL  = 1,
	ATTACKER = 2,
	DEFENDER = 3,
	ALL      = 10,
}

CombatType =
{
	--Situation: occured in field, both sided agress to attend combat
	FIELD_COMBAT  = 1,

	--Situation: siege city
	SIEGE_COMBAT  = 2,

	--Situation: when one side refused to attend combat
	CAMP_COMBAT   = 3,
}

CombatStatus = 
{
	--BOTH
	SURROUNDED  = 10,

	--FIELD
	RANK_BROKEN = 20,

	--SIEGE
	DEFENSE_BROKEN = 30,
}

CombatStep = 
{
	REST     = 0,
	PREPARE  = 1,
	EMBATTLE = 2,
	ORDER    = 3,
	INCOMBAT = 4,
}

CombatResult = 
{
	--Time out
	UNKNOWN           = 0,
	DRAW              = 1,
	---------------------------
	--At least gain more advantage than opponent
	TACTICAL_VICTORY  = 11,	
	--All troops neutralized or fled
	TACTICAL_LOSE     = 12,
	---------------------------
	--Seperator
	COMBAT_END_RESULT = 20,
	---------------------------
	--All enemy neutralized or fled
	STRATEGIC_VICTORY = 21,		
	--Gain less advantage than opponent
	STRATEGIC_LOSE    = 22,
	---------------------------
	BRILLIANT_VICTORY = 31,
	DISASTROUS_LOSE   = 32,
}

CombatPurpose = 
{
	CONSERVATIVE = 10,

	MODERATE     = 20,

	AGGRESSIVE   = 30,
}

CombatOrder = 
{
	--Always Shoot, No move, Easy to retreat
	SURVIVE = 0,

	--Always Shoot, Less Melee, No move
	DEFEND  = 1,

	--Attack / Move in advantageous
	ATTACK  = 2,

	--Always Attack / Move
	FORCED_ATTACK  = 3,
}

CombatTask = 
{
	NONE     = 0,

	--action
	FIGHT    = 10,
	SHOOT    = 11,
	CHARGE   = 12,
	DEFEND   = 13,
	DESTROY_DEFENSE  = 14,
	PASS     = 15,

	--movement
	FORWARD  = 20,	--go straight line
	BACKWARD = 21,
	FLEE     = 22,
	TOWARD_TAR  = 23,
	TOWARD_GRID = 24,
	STAY        = 25,
}

CombatStatistic = 
{
	--initialize when combat occured

	--troop / side statistic, 
	ACCUMULATE_TYPE = 10,
	KILL            = 11,
	GAIN_VP         = 12,
	VP_RATIO        = 13,
	ATTACK          = 14,
	--DEFEND          = 15,
	DAMAGE          = 16,
	FLEE            = 17,
	FORWARD         = 18,
	BACKWARD        = 19,
	PASS            = 20,
	DEAD            = 21,

	REST_DAY        = 30,
	FORCED_ATK_DAY  = 31,
	COMBAT_DAY      = 32,
	
	RESTORE_MORALE  = 41,
	RESTORE_ORG     = 42,
	LOSE_MORALE     = 43,
	DESTROY_DEFENSE = 44,

	--damage calculation
	COUNTER_TIMES   = 52,
	CRITICAL_TIMES  = 53,

	--count every time
	UPDATE_TYPE     = 100,
	SOLDIER         = 101,

	--prepare reference data
	REFERENCE_TYPE  = 200,
	PREPARED        = 201,
	TOTAL_SOLDIER   = 202,
	TOTAL_POWER     = 203,
	EXPOSURE_POWER  = 204,
	COMBAT_INTENSE  = 205,
	AVERAGE_MORALE  = 206,
	HAS_FOOD        = 207,
	CONSUME_FOOD    = 208,
	FOOD_SUPPLY_DAY = 209,
	CASUALTY_RATIO  = 210,
}

CombatDirection = 
{
	UP    = { 1,  0, -1 },
	DOWN  = { 2,  0,  1 },
	LEFT  = { 3, -1,  0 },
	RIGHT = { 4,  1,  0 },
}

--------------------------------------------------------
-- Tactic Relative

TacticCategory = 
{
	--Activate tactic will trigger every time when match conditions
	ACTIVE    = 0,
	--Passive tactic always been trigger by other situation
	PASSIVE   = 1,
	--Always exist
	PERMANENT = 2,
}

TacticCondition = 
{
	PROBABILITY  = 1,
	UNDER_TACTIC = 2,
}

TacticEffect = 
{
	ATTACK = 100,
	DEFEND = 101,
}

----------------------------------------------------------------------

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
			{ x=1, y=1, depth=5000, prot = 0, height = 10 },
			{ x=2, y=1, depth=5000, prot = 0, height = 10 },
			{ x=3, y=1, depth=5000, prot = 0, height = 10 },
			{ x=1, y=2, depth=5000, prot = 0, height = 10 },
			{ x=2, y=2, depth=5000, prot = 0, height = 10 },
			{ x=3, y=2, depth=5000, prot = 0, height = 10 },
			{ x=1, y=3, depth=5000, prot = 0, height = 10 },
			{ x=2, y=3, depth=5000, prot = 0, height = 10 },
			{ x=3, y=3, depth=5000, prot = 0, height = 10 },
			{ x=1, y=4, depth=5000, prot = 0, height = 10 },
			{ x=2, y=4, depth=5000, prot = 0, height = 10 },
			{ x=3, y=4, depth=5000, prot = 0, height = 10 },
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
			{ x=2, y=1, depth=2000, prot = 50, height = 20, isWall = true, defense = 400, },
			{ x=1, y=1, depth=2000, prot = 40, height = 20, isWall = true, defense = 200, },
			{ x=3, y=1, depth=2000, prot = 50, height = 20, isWall = true, defense = 400, },
			{ x=2, y=2, depth=2000, prot = 0, height = 10 },
			{ x=1, y=2, depth=2000, prot = 0, height = 10 },
			{ x=3, y=2, depth=2000, prot = 0, height = 10 },
			{ x=2, y=3, depth=2000, prot = 0, height = 10 },
			{ x=1, y=3, depth=2000, prot = 0, height = 10 },
			{ x=3, y=3, depth=2000, prot = 0, height = 10 },
			{ x=2, y=4, depth=2000, prot = 0, height = 10 },
			{ x=1, y=4, depth=2000, prot = 0, height = 10 },
			{ x=3, y=4, depth=2000, prot = 0, height = 10 },
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
			{ x=2, y=1, depth=2000, prot = 100, height = 40, isWall = true, defense = 1500, },
			{ x=1, y=1, depth=2000, prot = 80,  height = 40, isWall = true, defense = 1000, },
			{ x=3, y=1, depth=2000, prot = 100, height = 40, isWall = true, defense = 1500, },
			{ x=2, y=2, depth=2000, prot = 0, height = 10 },
			{ x=1, y=2, depth=2000, prot = 0, height = 10 },
			{ x=3, y=2, depth=2000, prot = 0, height = 10 },
			{ x=2, y=3, depth=2000, prot = 0, height = 10 },
			{ x=1, y=3, depth=2000, prot = 0, height = 10 },
			{ x=3, y=3, depth=2000, prot = 0, height = 10 },
			{ x=2, y=4, depth=2000, prot = 0, height = 10 },
			{ x=1, y=4, depth=2000, prot = 0, height = 10 },
			{ x=3, y=4, depth=2000, prot = 0, height = 10 },
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