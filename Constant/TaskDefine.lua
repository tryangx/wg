--all proposal type should exist in TaskType or it'll occur error
TaskType = 
{
	STRATEGY_TASK   = 110, --seperator
	HARASS_CITY     = 111,
	ATTACK_CITY     = 112,
	INTERCEPT       = 113,
	DISPATCH_CORPS  = 114,

	COMMANDER_TASK  = 220, --seperator
	ESTABLISH_CORPS = 221,
	REINFORCE_CORPS = 222,
	DISMISS_CORPS   = 223,
	TRAIN_CORPS     = 224,
	UPGRADE_CORPS   = 225,
	ENROLL_CORPS    = 226,
	REGROUP_CORPS   = 227,
	LEAD_CORPS      = 228,
	CONSCRIPT       = 230,
	RECRUIT         = 231,
	HIRE_GUARD      = 232,

	OFFICIAL_TASK   = 300, --seperator
	DEV_AGRICULTURE = 311,
	DEV_COMMERCE    = 312,
	DEV_PRODUCTION  = 313,
	BUILD_CITY      = 324,
	LEVY_TAX        = 325,
	TRANSPORT       = 330,
	BUY_FOOD        = 331,
	SELL_FOOD       = 332,

	HR_TASK         = 400, --seperator
	HIRE_CHARA      = 401,
	PROMOTE_CHARA   = 402,
	DISPATCH_CHARA  = 403,
	CALL_CHARA      = 404,
	MOVE_CAPITAL    = 410,

	STAFF_TASK      = 500, --seperator
	RECONNOITRE     = 501,
	SABOTAGE        = 502,
	DESTROY_DEF     = 503,
	ASSASSINATE     = 504,

	TECH_TASK       = 600,	
	RESEARCH        = 601,

	DIPLOMATIC_TASK  = 700, --seperator
	IMPROVE_RELATION = 701,
	DECLARE_WAR      = 702,
	SIGN_PACT        = 703,
}

TaskActorType = 
{
	CHARA    = 1,
	CORPS    = 2,
}

TaskStep = 
{
	--some task needs time to prepare, like establish corps, attack city, etc.
	PREPARE = 1,

	--when arrive the destination, task can be execute
	EXECUTE = 2,

	--after task succeed or failed, task should be reply
	FINISH  = 3,

	REPLY   = 4,
}

TaskStatus = 
{
	--normal status, always idle
	RUNNING    = 1,
	--means current step is waiting until duration time elapsed
	WAITING    = 2,
	--means acotr is moving, should wait
	MOVING     = 3,
	--means task is working, should wait for finish
	WORKING    = 4,
}

TaskResult = 
{
	UNKNOWN    = 0,
	SUCCESS    = 1,
	FAILED     = 2,
}