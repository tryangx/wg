--------------------------------------------------------
-- Task

DefaultTaskAP = 
{

	HARASS_CITY     = { STRATEGY = 100, TACTIC = 200 },
	ATTACK_CITY     = { STRATEGY = 200, TACTIC = 200 },	
	INTERCEPT       = { STRATEGY = 100, TACTIC = 100 },
	DISPATCH_CORPS  = { STRATEGY = 100, POLITICS = 100 },
	
	ESTABLISH_CORPS = { STRATEGY = 100, POLITICS = 100 },
	REINFORCE_CORPS = { STRATEGY = 100, POLITICS = 100 },
	DISMISS_CORPS   = { STRATEGY = 100, POLITICS = 100 },

	TRAIN_CORPS     = { POLITICS = 100, },
	UPGRADE_CORPS   = { STRATEGY = 100, POLITICS = 100 },
	ENROLL_CORPS    = { STRATEGY = 100, POLITICS = 100 },
	LEAD_CORPS      = { POLITICS = 100, },	
	REGROUP_CORPS   = { STRATEGY = 100, POLITICS = 100 },
	CONSCRIPT       = { STRATEGY = 100, POLITICS = 100 },
	RECRUIT         = { STRATEGY = 100, POLITICS = 100 },
	HIRE_GUARD      = { STRATEGY = 100, POLITICS = 100 },

	DEV_AGRICULTURE = { POLITICS = 100, },
	DEV_COMMERCE    = { POLITICS = 100, },
	DEV_PRODUCTION  = { POLITICS = 100, },
	BUILD_CITY      = { POLITICS = 100, },
	LEVY_TAX        = { POLITICS = 100, },
	TRANSPORT       = { POLITICS = 100, },
	BUY_FOOD        = { POLITICS = 100, },
	SELL_FOOD       = { POLITICS = 100, },

	HIRE_CHARA      = { POLITICS = 100, },
	PROMOTE_CHARA   = { POLITICS = 100, },
	DISPATCH_CHARA  = { POLITICS = 100, },
	CALL_CHARA      = { POLITICS = 100, },
	MOVE_CAPITAL    = { POLITICS = 200, },

	RECONNOITRE     = { TACTIC = 100, },
	SABOTAGE        = { TACTIC = 300, },
	DESTROY_DEF     = { TACTIC = 350, },
	ASSASSINATE     = { TACTIC = 1000, },

	RESEARCH        = { POLITICS = 300, },

	IMPROVE_RELATION = { STRATEGY = 100, POLITICS = 100 },
	DECLARE_WAR      = { POLITICS = 200 },
	SIGN_PACT        = { STRATEGY = 100, POLITICS = 200 },	
}

DefaultTaskSkill = 
{
	HARASS_CITY     = {},
	ATTACK_CITY     = {},
	INTERCEPT       = {},
	DISPATCH_CORPS  = {},

	ESTABLISH_CORPS = {},
	REINFORCE_CORPS = {},
	DISMISS_CORPS   = {},
	TRAIN_CORPS     = {},
	UPGRADE_CORPS   = {},
	ENROLL_CORPS    = {},
	REGROUP_CORPS   = {},
	LEAD_CORPS      = {},
	CONSCRIPT       = {},
	RECRUIT         = {},
	HIRE_GUARD      = {},
	
	DEV_AGRICULTURE = {},
	DEV_COMMERCE    = {},
	DEV_PRODUCTION  = {},
	BUILD_CITY      = {},
	LEVY_TAX        = {},
	TRANSPORT       = {},
	BUY_FOOD        = {},
	SELL_FOOD       = {},

	HIRE_CHARA      = {},
	PROMOTE_CHARA   = {},
	DISPATCH_CHARA  = {},
	CALL_CHARA      = {},
	MOVE_CAPITAL    = {},

	RECONNOITRE     = {},
	SABOTAGE        = {},
	DESTROY_DEF     = {},
	ASSASSINATE     = {},

	TECH_TASK       = {},	
	RESEARCH        = {},

	IMPROVE_RELATION = {},
	DECLARE_WAR      = {},
	SIGN_PACT        = {},
}

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
	BUY_FOOD        = { "EXECUTE", "FINISH", "REPLY" },
	SELL_FOOD        = { "EXECUTE", "FINISH", "REPLY" },
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
	BUY_FOOD         = { success = 40, failed = 0, work = 1, off_exp = 20 },
	SELL_FOOD        = { success = 40, failed = 0, work = 1, off_exp = 20 },
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
