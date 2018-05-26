--------------------------------------------------------
-- Task

DefaultTaskSteps = 
{
	HARASS_CITY     = { "PREPARE", "EXECUTE", "FINISH", "REPLY" },
	ATTACK_CITY     = { "PREPARE", "EXECUTE", "FINISH", "REPLY" },
	INTERCEPT       = { "PREPARE", "EXECUTE", "FINISH", "REPLY" },
	
	ESTABLISH_CORPS = { "PREPARE", "EXECUTE", "FINISH", "REPLY" },
	REINFORCE_CORPS = { "EXECUTE", "FINISH", "REPLY" },
	DISMISS_CORPS   = { "EXECUTE", "FINISH", "REPLY" },
	TRAIN_CORPS     = { "EXECUTE", "FINISH", "REPLY" },
	DISPATCH_CORPS  = { "PREPARE", "EXECUTE", "FINISH", "REPLY" },
	ENROLL_CORPS    = { "EXECUTE", "FINISH", "REPLY" },
	CONSCRIPT       = { "EXECUTE", "FINISH", "REPLY" },
	RECRUIT         = { "EXECUTE", "FINISH", "REPLY" },

	DEV_AGRICULTURE = { "EXECUTE", "FINISH", "REPLY" },
	DEV_COMMERCE    = { "EXECUTE", "FINISH", "REPLY" },
	DEV_PRODUCTION  = { "EXECUTE", "FINISH", "REPLY" },
	BUILD_CITY      = { "EXECUTE", "FINISH", "REPLY" },
	LEVY_TAX        = { "EXECUTE", "FINISH", "REPLY" },
	TRANSPORT       = { "PREPARE", "EXECUTE", "FINISH", "REPLY" },

	HIRE_CHARA      = { "EXECUTE", "FINISH", "REPLY" },
	PROMOTE_CHARA   = { "FINISH", "REPLY" },
	DISPATCH_CHARA  = { "PREPARE", "EXECUTE", "FINISH", },
	CALL_CHARA      = { "PREPARE", "EXECUTE", "FINISH", },

	RECONNOITRE     = { "EXECUTE", "FINISH", "REPLY" },
	SABOTAGE        = { "EXECUTE", "FINISH", "REPLY" },

	RESEARCH        = { "EXECUTE", "FINISH", "REPLY" },

	IMPROVE_RELATION = { "EXECUTE", "FINISH", "REPLY" },
	DECLARE_WAR      = { "PREPARE", "FINISH", "REPLY" },	
	SIGN_PACT        = { "EXECUTE", "FINISH", "REPLY" },
}

DefaultTaskContribution = 
{
	HARASS_CITY     = { success = 200, failed = 0, city_level_ratio = 20 },
	ATTACK_CITY     = { success = 400, failed = 0, city_level_ratio = 20 },
	INTERCEPT       = { success = 300, failed = 0, city_level_ratio = 20 },
	DISPATCH_CORPS  = { success = 20,  failed = 0 },

	ESTABLISH_CORPS = { success = 40, failed = 0, },
	REINFORCE_CORPS = { success = 20, failed = 0 },
	DISMISS_CORPS   = { success = 10, failed = 0 },
	TRAIN_CORPS     = { success = 40, failed = 0 },
	UPGRADE_CORPS   = { success = 40, failed = 0 },
	ENROLL_CORPS    = { success = 20, failed = 0 },
	REGROUP_CORPS   = { success = 40, failed = 0 },

	CONSCRIPT       = { success = 20, failed = 0 },
	RECRUIT         = { success = 20, failed = 0 },

	DEV_AGRICULTURE = { success = 30, failed = 0, work = 1 },
	DEV_COMMERCE    = { success = 30, failed = 0, work = 1 },
	DEV_PRODUCTION  = { success = 30, failed = 0, work = 1 },
	BUILD_CITY      = { success = 50, failed = 0, work = 1 },
	LEVY_TAX        = { success = 40, failed = 0, work = 1 },
	TRANSPORT       = { success = 40, failed = 0 },

	HIRE_CHARA      = { success = 40, failed = 0 },
	PROMOTE_CHARA   = { success = 20, failed = 0 },
	DISPATCH_CHARA  = { success = 20, failed = 0 },
	CALL_CHARA      = { success = 20, failed = 0 },

	RECONNOITRE     = { success = 30, failed = 0 },
	SABOTAGE        = { success = 30, failed = 0 },

	RESEARCH        = { success = 50, failed = 0 },

	IMPROVE_RELATION = { success = 40, failed = 0 },
	DECLARE_WAR      = { success = 10, failed = 0 },
	SIGN_PACT        = { success = 40, failed = 0 },
}
