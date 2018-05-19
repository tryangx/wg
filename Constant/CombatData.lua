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

--------------------------------------------

DefaultCorpsParams = 
{
	MAX_TROOP_NUMBER = 20,
	REQ_TROOP_NUMBER = 8,
}

DefaultTroopParams = 
{
	MIN_TROOP_SOLDIER = 100,

	TROOP_MAX_NUMBER = 
	{
		[0] = 200,
		[1] = 500,
		[2] = 1000,
		[3] = 2000,
	}
}