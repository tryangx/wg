
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
	IMPROVE_GRADE   = 12,

	-----------------------

	HARASS_CITY     = 110,
	ATTACK_CITY     = 111,
	INTERCEPT       = 112,
	DISPATCH_CORPS  = 113,

	ESTABLISH_CORPS = 220,
	REINFORCE_CORPS = 221,
	DISMISS_CORPS   = 222,
	TRAIN_CORPS     = 223,
	UPGRADE_CORPS   = 224,	
	ENROLL_CORPS    = 226,
	REGROUP_CORPS   = 227,
	LEAD_CORPS      = 228,
	CONSCRIPT       = 230,
	RECRUIT         = 231,
	HIRE_GUARD      = 232,

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
	DESTROY_DEF     = 502,
	ASSASSINATE     = 503,

	RESEARCH        = 600,

	IMPROVE_RELATION = 700,
	DECLARE_WAR      = 701,
	SIGN_PACT        = 702,
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
	--Should be the first top ic index, just as same as the first one below
	MEETING_LOOP          = 10,

	CAPITAL               = 10,

	--harass, attack
	STRATEGY              = 11,

	--hire, encourage
	HR                    = 12,

	--research
	TECHNICIAN            = 13,

	--declare war, sign pact
	DIPLOMATIC            = 14,

	--agriculture, commerce, production
	OFFICIAL              = 15,

	--establish corps, reinforce corps
	COMMANDER             = 16,	

	--operation
	STAFF                 = 17,

	--Always should be the last topic + 1
	MEETING_END           = 18,
	---------------------------------
}
