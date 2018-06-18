
----------------------------------------------------------------------------------------
--
-- Proposal & Task
--
----------------------------------------------------------------------------------------

ProposalStatus = 
{
	SUBMITTED    = 1,
	PERMITTED    = 2,
	REJECTED     = 3,
}

ProposalType = 
{
	SET_GOAL        = 10,
	INSTRUCT_CITY   = 11,

	HARASS_CITY     = 110,
	ATTACK_CITY     = 111,
	INTERCEPT       = 112,
	DISPATCH_CORPS  = 113,

	ESTABLISH_CORPS = 120,
	REINFORCE_CORPS = 121,
	DISMISS_CORPS   = 122,
	TRAIN_CORPS     = 123,
	UPGRADE_CORPS   = 124,	
	ENROLL_CORPS    = 126,
	REGROUP_CORPS   = 127,

	CONSCRIPT       = 130,
	RECRUIT         = 131,
	HIRE_GUARD      = 132,

	DEV_AGRICULTURE = 310,
	DEV_COMMERCE    = 311,
	DEV_PRODUCTION  = 312,		
	BUILD_CITY      = 320,
	LEVY_TAX        = 321,
	TRANSPORT       = 330,
	BUY_FOOD        = 331,
	SELL_FOOD       = 332,	

	HIRE_CHARA      = 400,
	PROMOTE_CHARA   = 401,
	DISPATCH_CHARA  = 402,
	CALL_CHARA      = 403,
	MOVE_CAPITAL    = 410,

	RECONNOITRE     = 500,
	SABOTAGE        = 501,

	RESEARCH        = 600,

	IMPROVE_RELATION = 700,
	DECLARE_WAR      = 701,
	SIGN_PACT        = 702,
}

--all proposal type should exist in TaskType or it'll occur error
TaskType = 
{
	HARASS_CITY     = 110,
	ATTACK_CITY     = 111,
	INTERCEPT       = 112,
	DISPATCH_CORPS  = 113,

	ESTABLISH_CORPS = 120,
	REINFORCE_CORPS = 121,
	DISMISS_CORPS   = 122,
	TRAIN_CORPS     = 123,
	UPGRADE_CORPS   = 124,
	ENROLL_CORPS    = 126,
	REGROUP_CORPS   = 127,

	CONSCRIPT       = 130,
	RECRUIT         = 131,
	HIRE_GUARD      = 132,

	DEV_AGRICULTURE = 310,
	DEV_COMMERCE    = 311,
	DEV_PRODUCTION  = 312,
	BUILD_CITY      = 320,
	LEVY_TAX        = 321,
	TRANSPORT       = 330,
	BUY_FOOD        = 331,
	SELL_FOOD       = 332,

	HIRE_CHARA      = 400,
	PROMOTE_CHARA   = 401,
	DISPATCH_CHARA  = 402,
	CALL_CHARA      = 403,
	MOVE_CAPITAL    = 410,

	RECONNOITRE     = 500,
	SABOTAGE        = 501,

	RESEARCH        = 600,

	IMPROVE_RELATION = 700,
	DECLARE_WAR      = 701,
	SIGN_PACT        = 702,
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

----------------------------------------

MeetingTopic =
{
	NONE                  = 0,

	--enemy send corps to attack out territory
	UNDER_ATTACK          = 1,
	UNDER_HARASS          = 2,

	DETERMINE_GOAL        = 3,

	---------------------------------
	--
	MEETING_LOOP          = 11,

	--EXECUTIVE       = 10,
	CAPITAL               = 11,

	--hire, encourage
	HR                    = 12,

	--research
	TECHNICIAN            = 13,

	--declare war, sign pact
	DIPLOMATIC            = 14,

	--agriculture, commerce, production
	AFFAIRS               = 15,

	--establish corps, reinforce corps
	COMMANDER             = 16,	

	--operation
	STAFF                 = 17,

	--harass, attack
	STRATEGY              = 18,

	--Always should be the last topic + 1
	MEETING_END           = 19,
	---------------------------------
}
