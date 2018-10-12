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
	MOVE_IS_BLOCKED       = 81,

	CORPS_ATTACK          = 91,

	----------------------------------
	-- Combat Relative

	COMBAT_TRIGGERRED_NOTIFY = 100,
	COMBAT_UNTRIGGER_NOTIFY  = 101,

	--{ combat }
	--@param combat that was been interrupted
	COMBAT_INTERRUPTED    = 102,

	--{ plot, city, atk, def, task }	
	--@param plot encounter when moving
	--@param city harass city task
	--@param atk  always valid
	--@param def  defender corps, only valid in encouter
	--@param task param
	FIELD_COMBAT_TRIGGER  = 110,
	SIEGE_COMBAT_TRIGGER  = 111,
	--{ combat, corps }
	COMBAT_ATTEND         = 112,

	COMBAT_OCCURED        = 120,
	FIELD_COMBAT_OCCURED  = 121,
	SIEGE_COMBAT_OCCURED  = 122,

	COMBAT_ENDED          = 130,
	COMBAT_REMOVE         = 131,	
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
