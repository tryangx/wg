----------------------------------------------------------------------------------------
--
-- Corps & Troop
--
----------------------------------------------------------------------------------------

WeaponDamageType = 
{
	NORMAL    = 1,
	PIERCE    = 2,
	FORTIFIED = 3,
}

WeaponRangeType = 
{
	CLOSE   = 1,
	LONG    = 2,
	MISSILE = 3,
}

ConveyanceType = 
{
	FOOT    = 0,
	HORSE   = 1,
	CHARIOT = 2,
	WAGON   = 3,
}

TroopCategory = 
{
	--Light footman, use long-range weapon like bow, crossbow
	MISSILE_UNIT = 1,
	--Heavey footman, anti Cavalry
	INFANTRY     = 2,	
	--footman with conveyance
	CAVALRY      = 3,
	--
	SIEGE_WEAPON = 4,
	--
	ASSISTANT    = 5,
}

TroopConsume = 
{
	FOOD     = 1,
	MONEY    = 2,
}

TroopRequirement = 
{
	SOLDIER  = 0,
	MONEY    = 1,
	MATERIAL = 2,
	TECH     = 3,
}

TroopStatus = 
{
	--is guard
	GUARD      = 1,

	--range: 1-10
	STARVATION = 10,

	SURRENDER  = 11,
}

TroopCombatData = 
{
	SIDE       = 10,
	X_POS      = 11,
	Y_POS      = 12,
	GRID       = 13,
	FACE_DIR   = 14,

	PREPARED   = 20,
	ATTENDED   = 21,
	VP         = 22,
	EXPOSURE   = 23,
	
	ORDER      = 30,
	TARGET     = 31,
	MOVED      = 32,
	ATTACKED   = 33,
	DEFENDED   = 34,

	RETREAT    = 40,
	FLEE       = 41,
	SURROUNDED = 42,
	CAPTURED   = 43,
}

CorpsStatus = 
{
	IN_COMBAT = 10,

	IN_TASK   = 11,	

	DEPATURE_TIME = 12,
}

CorpsPurpose =
{
	FIELD_COMBAT       = 1,
	SIEGE_COMBAT       = 2,
}


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

CombatStepType = 
{
	--check withdraw, rest
	PREPARE  = 1,

	--check trigger skill?
	EMBATTLE = 2,

	--given order
	ORDER    = 3,

	--in combat, duration game time
	INCOMBAT = 4,

	--have a rest
	REST     = 5,
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

CombatAction = 
{
	MOVE     = 1,
	ATTACK   = 2,
	DEFEND   = 3,	
	KILL     = 5,
	BEAT     = 6,
	RETREAT  = 7,
	FLEE     = 8,

	BEEN_CRT_HIT     = 10,
	BEEN_KILLED      = 11,
	BEEN_FLANK_HIT   = 12,

	FRIENDLY_RETREAT = 20,
	FRIENDLY_KILLED  = 21,	
	FRIENDLY_FLED    = 22,

	DEFENCE_DESTOYED = 30,
}

CombatTask = 
{
	NONE     = 0,

	--action
	FIGHT    = 10,
	SHOOT    = 11,
	CHARGE   = 12,
	DESTROY  = 13,
	DEFEND   = 14,
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
	START_SOLDIER   = 1,	
	VP              = 2,

	--troop / side statistic, 
	_ACCUMULATE_TYPE= 10, --SEPERATOR
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
	STORM_DAY       = 31,
	COMBAT_DAY      = 32,
	
	RESTORE_MORALE  = 41,
	RESTORE_ORG     = 42,
	LOSE_MORALE     = 43,
	DESTROY         = 44,

	--------------------------------
	--damage calculation
	_TIMES_TYPE     = 50,  --SEPERATOR	
	COUNTER_TIMES   = 52,
	CRITICAL_TIMES  = 53,

	--count every time
	_UPDATE_TYPE    = 100,  --SEPERATOR
	SOLDIER         = 101,

	--prepare reference data	
	_REFERENCE_TYPE = 200,	--SEPERATOR	
	
	MAX_SOLDIER     = 200,
	TOTAL_SOLDIER   = 201,
	EXPOSURE_SOLDIER= 202,
	TOTAL_POWER     = 203,
	EXPOSURE_POWER  = 204,	
	PREPARE_SOLDIER = 206,
	MORALE          = 207,
	ORGANIZATION    = 208,	

	FOOD_HAS        = 210,
	FOOD_CONSUME    = 211,	
	FOOD_DAY        = 212,

	_RATIO_TYPE     = 220,
	
	CASUALTY_RATIO  = 220,
	ORG_RATIO       = 221,
	MORALE_RATIO    = 222,
	PROP_RATIO      = 223,
	PREPARE_RATIO   = 224,

	SURROUNDED      = 230,	
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

CombatPrepareResult = 
{
	BOTH_DECLINED = 0,
	BOTH_ACCEPTED = 1,
	ATK_ACCEPTED  = 2,
	DEF_ACCEPTED  = 3,
	ATK_SURRENDER = 4,
	DEF_SURRENDER = 5,
}

CombatTime = 
{
	NORMAL_END_TIME = 5,
	PURSUE_END_TIME = 7,
}
