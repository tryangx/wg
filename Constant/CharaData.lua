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
