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
	TEMPLATE_GENERAL = 
	{
		LUST          = 50,
		SEXLESS       = 0,
		HOMO          = 20,
		GLUTTONY      = 30,
		GREED         = 30,
		PRIDE         = 30,
		AMBITION      = 30,

		BRAVE         = 50,
		COWARD        = -20,
		AGGRESSIVE    = 30,
		CONSERVATIVE  = 20,
		IRRITABLE     = 30,
		DISPASSIONATE = 0,
		CONTROL       = 20,
		ENDURANCE     = 20,
		
		OPEN          = 20,
		CLOSE         = 10,
		SELFISH       = 10,
		GENEROUS      = 10,
		FRIENDSHIP    = 10,
		CONFIDENCE    = 30,
		INSIDIOUS     = 20,
		ENVY          = 20,	

		CAREFUL       = 30,
		CARELESS      = 30,
		HARDWORK      = 30,
		SLOTH         = 10,

		FOOLISH       = 20,
		SMART         = 20,
		STRENGTH      = 50,
		AGILITY       = 30,
	},

	TEMPLATE_OFFICER = 
	{
		LUST          = 20,
		SEXLESS       = 20,
		HOMO          = 20,
		GLUTTONY      = 10,
		GREED         = 20,
		PRIDE         = 30,
		AMBITION      = 30,

		BRAVE         = 0,
		COWARD        = 20,
		AGGRESSIVE    = 20,
		CONSERVATIVE  = 50,
		IRRITABLE     = 10,
		DISPASSIONATE = 30,
		CONTROL       = 50,
		ENDURANCE     = 30,
		
		OPEN          = 20,
		CLOSE         = 20,
		SELFISH       = 30,
		GENEROUS      = 20,
		FRIENDSHIP    = 20,
		CONFIDENCE    = 50,
		INSIDIOUS     = 30,
		ENVY          = 30,	

		CAREFUL       = 50,
		CARELESS      = 0,
		HARDWORK      = 10,
		SLOTH         = 10,

		FOOLISH       = 0,
		SMART         = 30,
		STRENGTH      = 0,
		AGILITY       = 0,

		VOLUBLE       = 35, --good at talk
		ACCOUNTING    = 35, --good at calculate 
		OBSERVANT     = 35, --good at observe
		INVENTION     = 35, --good at creativity work
		MECHANICAL    = 35, --good at mechanical work
	},

	TEMPLATE_LOBBYIST = 
	{
		LUST          = 20,
		SEXLESS       = 20,
		HOMO          = 20,
		GLUTTONY      = 10,
		GREED         = 20,
		PRIDE         = 30,
		AMBITION      = 30,

		BRAVE         = 0,
		COWARD        = 20,
		AGGRESSIVE    = 20,
		CONSERVATIVE  = 50,
		IRRITABLE     = 10,
		DISPASSIONATE = 30,
		CONTROL       = 50,
		ENDURANCE     = 30,
		
		OPEN          = 70,
		CLOSE         = 20,
		SELFISH       = 30,
		GENEROUS      = 20,
		FRIENDSHIP    = 20,
		CONFIDENCE    = 70,
		INSIDIOUS     = 30,
		ENVY          = 30,	

		CAREFUL       = 50,
		CARELESS      = 0,
		HARDWORK      = 10,
		SLOTH         = 10,

		FOOLISH       = 0,
		SMART         = 30,
		STRENGTH      = 0,
		AGILITY       = 0,

		VOLUBLE       = 100,
	},

	TEMPLATE_DIPLOMATIC = 
	{
		LUST          = 20,
		SEXLESS       = 20,
		HOMO          = 20,
		GLUTTONY      = 10,
		GREED         = 20,
		PRIDE         = 30,
		AMBITION      = 30,

		BRAVE         = 0,
		COWARD        = 20,
		AGGRESSIVE    = 20,
		CONSERVATIVE  = 50,
		IRRITABLE     = 10,
		DISPASSIONATE = 70,
		CONTROL       = 50,
		ENDURANCE     = 30,
		
		OPEN          = 70,
		CLOSE         = 20,
		SELFISH       = 30,
		GENEROUS      = 20,
		FRIENDSHIP    = 20,
		CONFIDENCE    = 50,
		INSIDIOUS     = 30,
		ENVY          = 30,	

		CAREFUL       = 50,
		CARELESS      = 0,
		HARDWORK      = 10,
		SLOTH         = 10,

		FOOLISH       = 0,
		SMART         = 30,
		STRENGTH      = 0,
		AGILITY       = 0,

		VOLUBLE       = 100,
	},

	IDEAL        =
	{
		INVENTION     = 30,
	},
	REALISM      =
	{
		MECHANICAL    = 30,
	},

	ACTIVELY     =
	{
		OBSERVANT     = 20,
	},
	PASSIVE      =
	{
		ACCOUNTING    = 20,
	},

	INTROVERT    =
	{
		VOLUBLE       = 30,
	},
	EXTROVERT    =
	{
		VOLUBLE       = -100,
	},
}

DefaultCharaTraitCongeniality = 
{
	IDEAL        = { REALISM = -10 },
	REALISM      = { IDEAL   = -10 },

	ACTIVELY     = { PASSIVE  = -10 },
	PASSIVE      = { ACTIVELY = -10 },

	INTROVERT    = { EXTROVERT = -10 },
	EXTROVERT    = { INTROVERT = -10 },

	BRAVE         = { COWARD = -10 },
	COWARD        = { BRAVE = -10 },

	AGGRESSIVE    = { CONSERVATIVE = -10 },
	CONSERVATIVE  = { AGGRESSIVE = -10 },

	IRRITABLE     = { DISPASSIONATE = -10 },
	DISPASSIONATE = { IRRITABLE = -10 },

	OPEN          = { CLOSE = -10 },
	CLOSE         = { OPEN = -10 },

	SELFISH       = { ALL = -5 },	
	GENEROUS      = { ALL = 10 },
	FRIENDSHIP    = { ALL = 10 },	
	CONFIDENCE    = { ALL = 5 },	
	INSIDIOUS     = { ALL = -5 },
	ENVY          = { ALL = -10 },

	CAREFUL       = { CARELESS = -5 },
	CARELESS      = { CAREFUL  = -5 },
	HARDWORK      = { SLOTH    = -5 },
	SLOTH         = { HARDWORK = -5 },

	FOOLISH       = { SMART = -5 },
	SMART         = { FOOLISH = -5 },

	STRENGTH      = { WEAK = -5 },
	WEAK          = { STRENGTH = -5 },
}

--"conditions"   means to learn the skill should match these conditions
--"prerequisite" means these condition should always be satisfied
--"traits"       means one of every subset conditions should be satisfied
DefaultCharaSkill = 
{
	[2000] =
	{
		name="LOBBYIST",  type = "DIPLOMAT", desc = "hr expert who is good at hiring chara",
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
		name="Agri expert", type = "OFFICIALS",
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
		name="Comm expert", type = "OFFICIALS",
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
		name="Prod expert", type = "OFFICIALS",
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
		name="Builder expert", type = "OFFICIALS",
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
		id=3050, name="Tax expert", type = "OFFICIALS",
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
		id=4010, name="SCOUT expert", type = "STAFF",
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
		id=4020, name="Spy TypeB", type = "STAFF", desc = "who is good at operation likes sabotage",
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
		id=4030, name="Spy TypeC", type = "STAFF", desc = "who is good at operation likes sabotage",
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
		id=5010, name="dipl expert", type = "DIPLOMAT",
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
		id=5020, name="pact expert", type = "DIPLOMAT",
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
		id=6010, name="tech expert", type = "TECHNICIAN",
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
		id=7000, name="atk expert", type = "COMMANDER",
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
		id=7010, name="infantry expert", type = "COMMANDER",
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
		id=7020, name="cavalry expert", type = "COMMANDER",
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
		id=7030, name="archer expert", type = "COMMANDER",
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
		id=7040, name="siegeweapon expert", type = "COMMANDER",
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
		id=7100, name="def expert", type = "COMMANDER",
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
		id=7200, name="field expert", type = "COMMANDER",
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
		id=7300, name="siege expert", type = "COMMANDER",
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
		id=7400, name="Leadership Lv1", type = "OFFICER",
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
		id=7410, name="Commander Lv1", type = "OFFICER",
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
		id=7500, name="training expert", type = "OFFICER",
		effects = 
		{
			{ type = "TRAINING_EFF_BONUS", value = 20 },
			{ type = "TRAINING_EFF_BONUS", prob = 80, value = 15 },
			{ type = "TRAINING_EFF_BONUS", prob = 50, value = 15 },
		},
		conditions = 
		{
			{ pot_above = 50, prob = 30, traits = { "HARDWORK", "VOLUBLE", "OBSERVANT", "CAREFUL" }, },
		},
	},
	{
		id=7510, name="training teacher", type = "OFFICER",
		effects = 
		{
			{ type = "TRAINING_EXP_BONUS", value = 10 },
			{ type = "TRAINING_EXP_BONUS", prob = 80, value = 5 },
			{ type = "TRAINING_EXP_BONUS", prob = 50, value = 5 },
		},
		conditions = 
		{
			{ pot_above = 50, prob = 30, traits = { "HARDWORK", "VOLUBLE", "OBSERVANT", "CAREFUL" }, },
		},
	},

	--historical role
	{
		id=10000, name="Overlord of West Chu", type = "COMMANDER",
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
			{ pot_above = 90, prob = 20, traits = { "AGGRESSIVE", "AMBITION", "STRENGTH", "AGILITY", "BRAVE" }, },
		},
	},
	{
		id=10001, name="GuoShiWuShuang", type = "COMMANDER",
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

DefaultCharaTitle =
{
	{
		id = 1000, name = "OFFICER_LV1", grade = 1, 
		prerequisite = { { contribution = 1000, limit = 1 }, },
	},
	{
		id = 1100, name = "OFFICER_LV2", grade = 2,
		prerequisite = { { contribution = 2000, limit = 1 }, },
	},
	{
		id = 1200, name = "OFFICER_LV3", grade = 3,
		prerequisite = { { contribution = 3000, limit = 1 }, },
	},
	{
		id = 2000, name = "OFFICIAL_LV1", grade = 1,
		prerequisite = { { contribution = 1000, limit = 1 }, },
	},
	{
		id = 2100, name = "OFFICIAL_LV2", grade = 2,
		prerequisite = { { contribution = 2000, limit = 1 }, },
	},
	{
		id = 2200, name = "OFFICIAL_LV3", grade = 3,
		prerequisite = { { contribution = 3000, limit = 1 }, },
	},
	{
		id = 3000, name = "Baron", grade = 4,
		prerequisite = { { contribution = 0, heir = 1 }, { contribution = 5000, }, },
	},
	{
		id = 3010, name = "Viscount", grade = 4,
		prerequisite = { { contribution = 1000, heir = 1, }, { contribution = 6000, }, },
	},
	{
		id = 3020, name = "Earl", grade = 4,
		prerequisite = { { contribution = 2000, heir = 1, }, { contribution = 7000, }, },
	},
	{
		id = 3030, name = "Marquess", grade = 4,
		prerequisite = { { contribution = 3000, heir = 1, }, { contribution = 8000, }, },
	},	
	{
		id = 3040, name = "Duke", grade = 4,
		prerequisite = { { contribution = 4000, heir = 1, }, { contribution = 9000, }, },
	},
	{
		id = 4000, name = "Chief", grade = 5, priority = 1,
		prerequisite = { { leader = 1, terriority_more_than = 30 }, },
	},
	{
		id = 4010, name = "Leader", grade = 5, priority = 2,
		prerequisite = { { leader = 1 }, },
	},
	{
		id = 4020, name = "Lord", grade = 5, priority = 3,
		prerequisite = { { leader = 1 }, },
	},
	{
		id = 4030, name = "King", grade = 5, priority = 4,
		prerequisite = { { leader = 1 }, },
	},
	{
		id = 4040, name = "Emperor", grade = 5, priority = 5,
		prerequisite = { { leader = 1 }, },
	},
}

DefaultCharaCareer =
{
	{
		id = 100, name = "officer",
	},
	{
		id = 110, name = "official",
	},
	{
		id = 120, name = "lobbist",
	},
	{
		id = 130, name = "agent",
	},
	{
		id = 140, name = "trader",
	},
	{
		id = 150, name = "builder",
	},

	{
		id = 200, name = "ass_minister",
	},
	{
		id = 210, name = "general",
	},	
	{
		id = 211, name = "captain",
	},
	{
		id = 220, name = "diplomat",
	},
	{
		id = 230, name = "spy",
	},
	{
		id = 240, name = "merchant",
	},
	{
		id = 250, name = "technician",
	},

	{
		id = 300, name = "premier",
	},
	{
		id = 301, name = "cabinet_minister",
	},
	{
		id = 310, name = "marshal",
	},
	{
		id = 311, name = "admiral",
	},
	{
		id = 320, name = "diplomat_minister",
	},
	{
		id = 330, name = "spymaster",
	},
	{
		id = 330, name = "assasin",
	},
	{
		id = 340, name = "monopoly",
	},
	{
		id = 350, name = "scientist",
	},
}