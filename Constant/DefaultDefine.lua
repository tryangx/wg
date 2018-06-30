----------------------------------------------------------------------------------------
--
-- Grade Evaluation
--
----------------------------------------------------------------------------------------

GradeEvaluation_Type = 
{
	SS = 110,
	S = 95,
	A = 85,
	B = 75,
	C = 65,
	D = 45,
	E = 30,
	F = -999,
}

------------------------------
--All system should depend on messages and process with them

MessageType = 
{
	------------------------------------
	--start / resume move

	--@param actor
	START_MOVING          = 70,
	--@param actor
	STOP_MOVING           = 71,
	--@param actor
	CANCEL_MOVING         = 72,
	------------------------------------


	--actor, destination	
	ARRIVE_DESTINATION    = 80,	

	CORPS_ATTACK          = 91,

	----------------------------------
	-- Combat Relative

	COMBAT_TRIGGERRED     = 100,
	--@param plot encounter when moving
	--@param city harass city task
	--@param atk  always valid
	--@param def  defender corps, only valid in encouter
	--@param task param
	FIELD_COMBAT_TRIGGER  = 101,
	SIEGE_COMBAT_TRIGGER  = 102,	

	COMBAT_OCCURED        = 110,
	FIELD_COMBAT_OCCURED  = 111,
	SIEGE_COMBAT_OCCURED  = 112,

	COMBAT_ENDED          = 120,

	COMBAT_REMOVE         = 140,	
	----------------------------------

	----------------------------------
	CITY_HOLD_MEETING     = 200,
	----------------------------------
}

------------------------------

IntelType = 
{
	HARASS_CITY   = 10,
	ATTACK_CITY   = 11,
}

------------------------------

MoveRole = 
{
	CHARA = 1,
	CORPS = 2,
}

MoveStatus = 
{
	MOVING  = 0,
	SUSPEND = 1,
	STOP    = 2,
}

------------------------------

------------------------------

----------------------------------------------------------------------------------------

SkillEffectType = 
{
	HIRE_CHARA_BONUS   = 201,

	AGRICULTURE_BONUS  = 301,
	COMMERCE_BONUS     = 302,
	PRODUCTION_BONUS   = 303,
	BUILD_BONUS        = 304,
	LEVY_TAX_BONUS     = 305,

	RECONNOITRE_BONUS  = 401,
	SABOTAGE_BONUS     = 402,

	IMPROVE_RELATION_BONUS = 501,
	SIGN_PACT_BONUS        = 502,
	
	RESEARCH_BONUS     = 601,

	ATTACK             = 701,
	DEFEND             = 702,
	FIELD_COMBAT_BONUS = 711,
	SIEGE_COMBAT_BONUS = 711,

	TRAINING           = 800,
	LEADERSHIP         = 801,
}