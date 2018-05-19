------------------------------

EventType =
{
	--Nature
	DISASTER = 100,

	--Man-made
	WARFARE  = 200,
}

EventCondition = 
{

}

EventEffect = 
{
	--force 
	COOLDOWN = 10,
}

EventFlag = 
{
	------------------------------------------
	--TempoRARY flag( cleared in every UPDATE )
	TEMP_FLAG_RESERVED    = 1000,	--reserved separator
	
	EVT_TRIGGER_THIS_TURN = 1000,
	
	------------------------------------------
	--Global flag( only clear manually )
	GLOBAL_FLAG_RESERVED  = 2000,	--separator

	EVT_TRIGGER_BEFORE    = 2001,	

	------------------------------------------
	--User define flag
	USER_FLAG_RESERVED    = 3000,

	--to do or defined in other ENUM
}