--------------------------------------------------------
--  Character Relative

DefaultCharaFamilyName = 
{
	{ name="Zhao", prob=15 },
	{ name="Qian", prob=10 },
	{ name="Sun",  prob=20 },
	{ name="Li",   prob=25 },
	{ name="Zhou", prob=15 },
	{ name="Wu",   prob=15 },
	{ name="Zhen", prob=10 },
	{ name="Wang", prob=20 },	
}

DefaultCharaGivenName = 
{
	{ name="I", prob=10 },
	{ name="II", prob=10 },
	{ name="III", prob=10 },
	{ name="IV", prob=10 },
	{ name="V", prob=10 },
	{ name="VI", prob=10 },
	{ name="VII", prob=10 },
	{ name="VIII", prob=10 },
	{ name="IX", prob=10 },
	{ name="XI", prob=10 },	
	{ name="XII", prob=10 },
	{ name="XIII", prob=10 },
	{ name="XIV", prob=10 },
	{ name="XV", prob=10 },
	{ name="XVI", prob=10 },
	{ name="XVII", prob=10 },
	{ name="XVIII", prob=10 },
	{ name="XIX", prob=10 },
	{ name="XX", prob=10 },
	--[[
	{ name="YI", prob=10 },
	{ name="ER", prob=10 },
	{ name="SAN", prob=10 },
	{ name="SI", prob=10 },
	{ name="WU", prob=10 },
	{ name="LIU", prob=10 },
	{ name="QI", prob=10 },
	{ name="BA", prob=10 },
	{ name="JIU", prob=10 },
	{ name="SHI", prob=10 },	
	{ name="SHIYI", prob=10 },
	{ name="ERER", prob=10 },
	{ name="SANSAN", prob=10 },
	{ name="SISI", prob=10 },
	{ name="WUWU", prob=10 },
	{ name="LIULIU", prob=10 },
	{ name="QIQI", prob=10 },
	{ name="BABA", prob=10 },
	{ name="JIUJIU", prob=10 },
	]]
}

--------------------------------------------------------
--Chara

--
-- atmoic = 
-- {
--
-- }
--
DefaultCharaTrait = 
{
	IDEAL        =
	{
		AGGRESSIVE    = 20,
		HARDWORK      = 20,
		CAREFUL       = -50, 
		CARELESS      = 50,
		INSIDIOUS     = -40,
		NOBEL         = 50,
		INSIDIOUS     = 20,
		DISPASSIONATE = -40,
		LOVE_MONEY    = -40,
		LOVE_HONOR    = -40,
	},
	REALISM      =
	{
		CONSERVATIVE  = 20,
		HARDWORK      = 50,
		CAREFUL       = 50, 
		CARELESS      = -50,
		INSIDIOUS     = 40,
		NOBEL         = -50,
		INSIDIOUS     = -20,
		DISPASSIONATE = 40,
		LOVE_MONEY    = 50,
		LOVE_HONOR    = 50,
	},

	ACTIVELY     =
	{
		AGGRESSIVE   = 50,
		IRRITATION   = 30,
		CONSERVATIVE = -100,
		LOVE_MONEY    = 20,
		LOVE_HONOR    = 20,
		HARDWORK      = 40,
		LAZY          = -20,
	},
	PASSIVE      =
	{
		CONSERVATIVE  = 50,
		LAZY          = 20,
		DISPASSIONATE = 30,
		AGGRESSIVE    = -100,
		HARDWORK      = -100,
		LOVE_MONEY    = -20,
		LOVE_HONOR    = -20,
	},

	INTROVERT    =
	{
		CAREFUL       = 50,
		CARELESS      = -50,
		IRRITATION    = -50,
		DISPASSIONATE = 50,
		LOVE_HONOR    = 40,
		HARDWORK      = 40,
	},
	EXTROVERT    =
	{
		CARELESS      = 50,
		CAREFUL       = -50,
		IRRITATION    = 40,
		DISPASSIONATE = -40,
		LOVE_MONEY    = 40,
		LOVE_HONOR    = 40,		
		HARDWORK      = 20,
	},
}

--"conditions"   means to learn the skill should match these conditions
--"prerequisite" means these condition should always be satisfied
--"traits"       means one of every subset conditions should be satisfied
DefaultCharaSkill = 
{
	[2000] =
	{
		name="LOBBYIST", desc = "hr expert who is good at hiring chara",
		effects =
		{
			{ type = "HIRE_CHARA_BONUS", value = 50 },
		},		
		conditions = 
		{
			{ pot_above = 50, prob = 30, traits = { "OPEN", "VOLUBLE", "CONFIDENCE" }, },
		},
		consume = { TACTIC = 100 },
	},

	[3010] =
	{
		name="Agri expert",
		effects =
		{
			{ type = "AGRICULTURE_BONUS", value = 50 },
		},
		conditions = 
		{
			{ pot_above = 30, prob = 30, traits = { "HARDWORK", "CONSERVATIVE" }, },
		},
	},
	[3020] =
	{
		name="Comm expert",
		effects =
		{
			{ type = "COMMERCE_BONUS", value = 50 },
		},
		conditions = 
		{
			{ pot_above = 40, prob = 30, traits = { "ACCOUNTING" }, },
		},
	},
	[3030] = 
	{
		name="Prod expert",
		effects =
		{
			{ type = "PRODUCTION_BONUS", value = 50 },
		},
		conditions = 
		{
			{ pot_above = 20, prob = 30, traits = { "HARDWORK", "AGGRESSIVE" }, },
		},
	},
	[3040] =
	{
		name="Builder expert",
		effects =
		{
			{ type = "BUILD_BONUS", value = 50 },
		},
		conditions = 
		{
			{ pot_above = 35, prob = 30, traits = { "CLOSE", "HARDWORK", "CAREFUL" }, },
		},
	},
	{
		id=3050, name="Tax expert",
		effects =
		{
			{ type = "LEVY_TAX_BONUS", value = 50 },
		},
		conditions = 
		{
			{ pot_above = 30, prob = 30, traits = { "GREED", "CAREFUL" }, },
		},
	},

	{
		id=4010, name="SCOUT expert",
		effects =
		{
			{ type = "RECONNOITRE_BONUS", value = 50 },
		},
		conditions = 
		{
			{ pot_above = 40, prob = 30, traits = { "OBSERVANT", "CAREFUL" }, },
		},
	},
	{
		id=4020, name="Spy TypeB", desc = "who is good at operation likes sabotage",
		effects =
		{
			{ type = "SABOTAGE_BONUS", value = 50 },
		},
		conditions = 
		{
			{ pot_above = 50, prob = 30, traits = { "OBSERVANT", "CAREFUL", "INSIDIOUS" }, },
		},
	},
	{
		id=4030, name="Spy TypeC", desc = "who is good at operation likes sabotage",
		effects =
		{
			{ type = "ASSASSINATE", value = 50 },
		},
		conditions = 
		{
			{ pot_above = 50, prob = 30, traits = { "OBSERVANT", "CAREFUL", "INSIDIOUS" }, },
		},
	},

	{
		id=5010, name="dipl expert",
		effects =
		{
			{ type = "IMPROVE_RELATION_BONUS", value = 50 },
		},
		conditions = 
		{
			{ pot_above = 60, prob = 20, traits = { "OPEN", "VOLUBLE", "GENEROUS" }, },
		},
	},
	{
		id=5020, name="pact expert",
		effects =
		{
			{ type = "SIGN_PACT_BONUS", value = 50 },
		},
		conditions = 
		{
			{ pot_above = 60, prob = 20, traits = { "OPEN", "VOLUBLE", "DISPASSIONATE" }, },
		},
	},

	{
		id=6010, name="tech expert",
		effects =
		{
			{ type = "RESEARCH_BONUS", value = 50 },
		},
		conditions = 
		{
			{ pot_above = 60, prob = 20, traits = { "CLOSE", "HARDWORK", "SMART", "CREATIVITY" }, },
		},
	},

	{
		id=7010, name="atk expert",
		effects = 
		{
			{ type = "ORG_DAMAGE_BONUS", value = 20 },
			{ type = "ORG_DAMAGE_BONUS", prob = 50, value = 10 },
		},
		conditions = 
		{
			{ pot_above = 40, prob = 30, traits = { "HARDWORK", "BRAVE", "STRENGTH", "AGGRESSIVE" }, },
		},
	},
	{
		id=7010, name="infantry expert",
		effects = 
		{
			{ type = "ORG_DAMAGE_BONUS", prob = 80, value = 10 },
			{ type = "ORG_DAMAGE_RESIST", prob = 80, value = 10 },
		},
		conditions = 
		{
			{ pot_above = 40, prob = 30, traits = { "HARDWORK", "STRENGTH", "CAREFUL", "CONSERVATIVE", }, },
		},
	},
	{
		id=7020, name="cavalry expert",
		effects = 
		{
			{ type = "ORG_DAMAGE_BONUS", value = 10 },
			{ type = "ORG_DAMAGE_RESIST", value = 10 },
		},		
		conditions = 
		{
			{ pot_above = 40, prob = 30, traits = { "HARDWORK", "STRENGTH", "AGGRESSIVE", "AGILITY", "BRAVE" }, },
		},
	},
	{
		id=7030, name="archer expert",
		effects = 
		{
			{ type = "ORG_DAMAGE_BONUS", value = 10 },
			{ type = "ORG_DAMAGE_RESIST", value = 10 },
		},
		conditions = 
		{
			{ pot_above = 40, prob = 30, traits = { "HARDWORK", "STRENGTH", "CONSERVATIVE", "DISPASSIONATE" }, },
		},
	},	
	{
		id=7040, name="siegeweapon expert",
		effects = 
		{
			{ type = "ORG_DAMAGE_BONUS", value = 10 },
			{ type = "ORG_DAMAGE_RESIST", value = 10 },
		},
		conditions = 
		{
			{ pot_above = 40, prob = 30, traits = { "HARDWORK", "STRENGTH", "DISPASSIONATE", "MECHANICAL" }, },
		},
	},
	{
		id=7100, name="def expert",
		effects = 
		{
			{ type = "ORG_DAMAGE_RESIST", type = "ORG_DAMAGE_BONUS", value = 20 },
			{ type = "ORG_DAMAGE_RESIST", prob = 50, value = 10 },
		},
		conditions = 
		{
			{ pot_above = 40, prob = 30, traits = { "HARDWORK", "STRENGTH", "CONSERVATIVE", "DISPASSIONATE", }, },
		},
	},
	{
		id=7200, name="field expert",
		effects = 
		{
			{ type = "ORG_DAMAGE_BONUS", conditions = { "IS_FIELD_COMBAT", }, value = 10 },
			{ type = "ORG_DAMAGE_BONUS", prob = 50, conditions = { "IS_FIELD_COMBAT", }, value = 15 },			
			{ type = "ORG_DAMAGE_RESIST", conditions = { "IS_FIELD_COMBAT", }, value = 10 },
			{ type = "ORG_DAMAGE_RESIST", prob = 60, conditions = { "IS_FIELD_COMBAT", }, value = 15 },
		},
		conditions = 
		{
			{ pot_above = 40, prob = 30, traits = { "HARDWORK", "STRENGTH", "DISPASSIONATE", "CAREFUL", "OPEN" }, },
		},
	},
	{
		id=7300, name="siege expert",
		effects = 
		{
			{ type = "ORG_DAMAGE_BONUS", conditions = { "IS_SIEGE_COMBAT", }, value = 10 },
			{ type = "ORG_DAMAGE_BONUS", prob = 50, conditions = { "IS_SIEGE_COMBAT", }, value = 15 },
			{ type = "ORG_DAMAGE_RESIST", conditions = { "IS_SIEGE_COMBAT", }, value = 10 },
			{ type = "ORG_DAMAGE_RESIST", prob = 60, conditions = { "IS_SIEGE_COMBAT", }, value = 15 },
		},
		conditions = 
		{
			{ pot_above = 40, prob = 30, traits = { "HARDWORK", "CONSERVATIVE", "DISPASSIONATE", "CAREFUL", "CLOSE" }, },
		},
	},
	{
		id=7400, name="Leadership Lv1",
		effects = 
		{
			{ type = "ORGANIZATION_BONUS", value = 20 },
		},
		conditions = 
		{
			{ pot_above = 50, prob = 30, traits = { "CONFIDENCE", "CLOSE", "VOLUBLE", "OBSERVANT", "GENEROUS" }, },
		},
	},
	{
		id=7410, name="Commander Lv1",
		effects = 
		{
			{ type = "MORALE_BONUS", value = 20 },
		},
		conditions = 
		{
			{ pot_above = 50, prob = 30, traits = { "CONFIDENCE", "OPEN", "VOLUBLE", "OBSERVANT", "AGGRESSIVE" }, },
		},
	},
	{
		id=7500, name="training expert",
		effects = 
		{
			{ type = "TRAINING_BONUS", value = 20 },
			{ type = "TRAINING_BONUS", prob = 80, value = 15 },
			{ type = "TRAINING_BONUS", prob = 50, value = 15 },
		},
		conditions = 
		{
			{ pot_above = 50, prob = 30, traits = { "HARDWORK", "VOLUBLE", "OBSERVANT", "CAREFUL" }, },
		},
	},

	--historical role
	{
		id=10000, name="Overlord of West Chu",
		effects = 
		{ 
			{ type = "DAMAGE_BONUS",     value = 15 },
			{ type = "ORG_DAMAGE_BONUS", value = 15 },
			{ type = "DAMAGE_BONUS",     conditions = { "IS_FIELD_COMBAT", }, value = 10 },
			{ type = "DAMAGE_BONUS",     conditions = { "IS_FIELD_COMBAT", "LEAD_CAVALRY" }, value = 20 },
			{ type = "ORG_DAMAGE_BONUS", conditions = { "IS_FIELD_COMBAT" }, value = 10 },
			{ type = "ORG_DAMAGE_BONUS", conditions = { "IS_FIELD_COMBAT", "LEAD_CAVALRY" }, value = 25 },
		},
		conditions = 
		{
			{ pot_above = 90, prob = 20, traits = { "HARDWORK", "VOLUBLE", "OBSERVANT", "CAREFUL" }, },
		},
	},
	{
		id=10001, name="GuoShiWuShuang",
		effects = 
		{
			{ type = "DAMAGE_RESIST",     value = 15 },
			{ type = "ORG_DAMAGE_RESIST", value = 15 },
			{ type = "DAMAGE_RESIST",     prob = 80, value = 10 },
			{ type = "ORG_DAMAGE_RESIST", prob = 80, value = 10 },
			{ type = "DAMAGE_RESIST",     prob = 30, value = 5 },
			{ type = "ORG_DAMAGE_RESIST", prob = 30, value = 5 },
		},
		conditions = 
		{
			{ pot_above = 90, prob = 20, traits = { "HARDWORK", "VOLUBLE", "OBSERVANT", "CAREFUL" }, },
		},
	},
}

DefaultJobPromoteData = 
{
	--[[
	OFFICER           = { contribution = 0, service = 0 },
	CIVIAL_OFFICIAL   = { contribution = 100, service = 0 },
	MILITARY_OFFICER  = { contribution = 100, service = 0 },
	SPY               = { contribution = 0, service = 0, has_skill = { { 0 } }, },
	TRADER            = { contribution = 0, service = 0, has_skill = { { 0 } }, },
	BUILDER           = { contribution = 0, service = 0, has_skill = { { 0 } }, },
	MISSIONARY        = { contribution = 0, service = 0, has_skill = { { 0 } }, },

	ASSISTANT_MINISTER= { contribution = 1000, service = 720 },
	DIPLOMATIC        = { contribution = 1000, service = 720 },
	GENERAL           = { contribution = 1000, service = 720 },
	CAPTAIN           = { contribution = 1000, service = 720 },
	AGENT             = { contribution = 1000, service = 720 },
	MERCHANT          = { contribution = 1000, service = 720 },
	TECHNICIAN        = { contribution = 1000, service = 720 },
	APOSTLE           = { contribution = 1000, service = 720 },
		
	IMPORTANT_JOB     = { contribution = 10000, service = 1800 },
	PREMIER           = { contribution = 10000, service = 1800 },
	CABINET_MINISTER  = { contribution = 10000, service = 1800 },
	MARSHAL           = { contribution = 10000, service = 1800 },
	ADMIRAL           = { contribution = 10000, service = 1800 },
	SPYMASTER         = { contribution = 10000, service = 1800 },
	ASSASSIN          = { contribution = 10000, service = 1800 },
	MONOPOLY          = { contribution = 10000, service = 1800 },
	SCIENTIST         = { contribution = 10000, service = 1800 },
	INQUISITOR        = { contribution = 10000, service = 1800 },
	]]
}

DefaultCharaPromoteMethod = 
{
	OFFICER           = { "CIVIAL_OFFICIAL", "MILITARY_OFFICER" },
	CIVIAL_OFFICIAL   = { "ASSISTANT_MINISTER", "DIPLOMATIC" },
	MILITARY_OFFICER  = { "GENERAL", "CAPTAIN" },
	SPY               = { "AGENT", "MILITARY_OFFICER" },
	TRADER            = { "MERCHANT", "CIVIAL_OFFICIAL" },
	BUILDER           = { "TECHNICIAN", "CIVIAL_OFFICIAL" },
	MISSIONARY        = { "APOSTLE", "CIVIAL_OFFICIAL" },
	
	ASSISTANT_MINISTER= { "PREMIER", "CABINET_MINISTER" },
	DIPLOMATIC        = { "PREMIER", "CABINET_MINISTER" },
	GENERAL           = { "MARSHAL", },
	CAPTAIN           = { "ADMIRAL", },
	AGENT             = { "SPYMASTER", "ASSASSIN" },	
	MERCHANT          = { "MONOPOLY", },	
	TECHNICIAN        = { "SCIENTIST", },
	APOSTLE           = { "INQUISITOR", },

	PREMIER           = {},
	CABINET_MINISTER  = {},
	MARSHAL           = {},
	ADMIRAL           = {},
	SPYMASTER         = {},
	ASSASSIN          = {},
	MONOPOLY          = {},
	SCIENTIST         = {},
	INQUISITOR        = {},
	
	MAYOR             = {},
	EMPEROR           = {},
	KING              = {},
	LORD              = {},
	LEADER            = {},
	CHIEF             = {},
	PRESIDENT         = {},
}
