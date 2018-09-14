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
	LEAD_CORPS      = { "FINISH", "REPLY" },
	REGROUP_CORPS   = { "PREPARE", "FINISH", "REPLY" },
	
	CONSCRIPT       = { "EXECUTE", "FINISH", "REPLY" },
	RECRUIT         = { "EXECUTE", "FINISH", "REPLY" },
	HIRE_GUARD      = { "EXECUTE", "FINISH", "REPLY" },

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
	DESTROY_DEF     = { "EXECUTE", "FINISH", "REPLY" },
	ASSASSINATE     = { "EXECUTE", "FINISH", "REPLY" },

	RESEARCH        = { "EXECUTE", "FINISH", "REPLY" },

	IMPROVE_RELATION = { "EXECUTE", "FINISH", "REPLY" },
	DECLARE_WAR      = { "PREPARE", "FINISH", "REPLY" },	
	SIGN_PACT        = { "EXECUTE", "FINISH", "REPLY" },
}

--success: contribution bonus when task successed
--failed : contribution bonus when task failed
--work   : contribution bonus when works every day
--mil_exp: military exp bonus
--dip_exp: diplomatic exp bonus
--off_exp: officer exp bonus
DefaultTaskBonus = 
{
	HARASS_CITY      = { success = 200, failed = 0, city_level_ratio = 20, mil_exp = 100 },
	ATTACK_CITY      = { success = 400, failed = 0, city_level_ratio = 20, mil_exp = 100 },
	INTERCEPT        = { success = 300, failed = 0, city_level_ratio = 20, mil_exp = 100 },
	DISPATCH_CORPS   = { success = 20,  failed = 0, mil_exp = 20 },

	ESTABLISH_CORPS  = { success = 40, failed = 0, mil_exp = 100 },
	REINFORCE_CORPS  = { success = 20, failed = 0, mil_exp = 20 },
	DISMISS_CORPS    = { success = 10, failed = 0, mil_exp = 10 },
	TRAIN_CORPS      = { success = 40, failed = 0, mil_exp = 20 },
	UPGRADE_CORPS    = { success = 40, failed = 0, mil_exp = 20 },
	ENROLL_CORPS     = { success = 20, failed = 0, mil_exp = 20 },	
	REGROUP_CORPS    = { success = 40, failed = 0, mil_exp = 20 },
	LEAD_CORPS       = { success = 20, failed = 0, mil_exp = 10 },

	CONSCRIPT        = { success = 20, failed = 0, mil_exp = 20 },
	RECRUIT          = { success = 20, failed = 0, mil_exp = 20 },
	HIRE_GUARD       = { success = 20, failed = 0, mil_exp = 20 },

	DEV_AGRICULTURE  = { success = 30, failed = 0, work = 1, off_exp = 20 },
	DEV_COMMERCE     = { success = 30, failed = 0, work = 1, off_exp = 20 },
	DEV_PRODUCTION   = { success = 30, failed = 0, work = 1, off_exp = 20 },
	BUILD_CITY       = { success = 50, failed = 0, work = 1, off_exp = 20 },
	LEVY_TAX         = { success = 40, failed = 0, work = 1, off_exp = 20 },
	TRANSPORT        = { success = 40, failed = 0, off_exp = 20 },

	HIRE_CHARA       = { success = 40, failed = 0, off_exp = 50 },
	PROMOTE_CHARA    = { success = 20, failed = 0, off_exp = 50 },
	DISPATCH_CHARA   = { success = 20, failed = 0, off_exp = 50 },
	CALL_CHARA       = { success = 20, failed = 0, off_exp = 50 },

	RECONNOITRE      = { success = 30, failed = 0, mil_exp = 20, dip_exp = 10 },
	SABOTAGE         = { success = 30, failed = 0, mil_exp = 20, dip_exp = 10 },
	DESTROY_DEF      = { success = 30, failed = 0, mil_exp = 20, dip_exp = 10 },
	ASSASSINATE      = { success = 30, failed = 0, mil_exp = 20, dip_exp = 10 },

	RESEARCH         = { success = 50, failed = 0, off_exp = 100 },

	IMPROVE_RELATION = { success = 40, failed = 0, dip_exp = 20 },
	DECLARE_WAR      = { success = 10, failed = 0, dip_exp = 20 },
	SIGN_PACT        = { success = 40, failed = 0, dip_exp = 20 },
}
