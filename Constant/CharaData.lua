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

DefaultCharaTrait = 
{
	LIBIDO       =
	{
		SELFISH       = 40,		
		IRRITATION    = 40,
		INSIDIOUS     = 40,		
		DISPASSIONATE = -40,				
		LOVE_MONEY    = 40,
		LOVE_HONOR    = 40,

		HARDWORK      = 40,
	},
	SEXLESS     =
	{
		SELFISH       = 20,		
		AGGRESSIVE    = 60,
		CONSERVATIVE  = 100,		
		INSIDIOUS     = 40,		
		IRRITATION    = -40,
		DISPASSIONATE = 40,
		LOVE_MONEY    = -40,
		LOVE_HONOR    = -40,
	},

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
	STRONG       =
	{
		HARDWORK      = -20,
		CAREFUL       = -50,
		CARELESS      = 50,
		IRRITATION    = 40,
		LOVE_MONEY    = 20,
		LOVE_HONOR    = 20,
		SMART         = -40,
		FOOLISH       = -40,
	},
	WEAK         =
	{
		HARDWORK      = 40,
		CAREFUL       = 50,
		CARELESS      = -50,
		IRRITATION    = -40,
		SMART         = 40,
		FOOLISH       = -40,
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

--"prerequisite" means these condition should always be satisfied
--"traits" means one of every subset conditions should be satisfied
DefaultCharaSkill = 
{
	[2000] =
	{
		name="HR expert",
		effects = { HIRE_CHARA_BONUS = 150, },
		prerequisite = { exp_above = 100 },
		conditions = 
		{
			{ trait = "OPEN", prob = 70 },
			{ trait = "GENEROUS", prob = 30 },
		},
		consume = { TACTIC = 100 },
	},

	[3010] =
	{
		name="Agri expert",
		effects = { AGRICULTURE_BONUS = 150, },
		prerequisite = { exp_above = 100 },
		conditions = 
		{
			{ trait = "HARDWORK", prob = 60 },
			{ trait = "CONSERVATIVE", prob = 40 },
		},
	},
	[3020] =
	{
		name="Comm expert",
		effects = { COMMERCE_BONUS = 150, },
		prerequisite = { exp_above = 100 },
		conditions = 
		{
			{ trait = "HARDWORK", prob = 60 },
			{ trait = "LOVE_MONEY", prob = 50 },
			{ trait = "SELFISH", prob = 50 },
		},
	},
	[3030] = 
	{
		name="Prod expert",
		effects = { PRODUCTION_BONUS = 150, },
		prerequisite = { exp_above = 100 },
		conditions = 
		{
			{ trait = "HARDWORK", prob = 60 },
			{ trait = "AGGRESSIVE", prob = 40 },			
		},
	},
	[3040] =
	{
		name="Builder expert",
		effects = { BUILD_BONUS = 150, },
		prerequisite = { exp_above = 100 },
		conditions = 
		{
			{ trait = "HARDWORK", prob = 50 },
			{ trait = "CAREFUL", prob = 30 },			
		},
	},
	{
		id=3050, name="Tax expert",
		effects = { LEVY_TAX_BONUS = 150, },
		prerequisite = { exp_above = 100 },
		conditions = 
		{
			{ trait = "HARDWORK", prob = 30 },
			{ trait = "LOVE_MONEY", prob = 50 },
		},
	},

	{
		id=4010, name="SCOUT expert",
		effects = { RECONNOITRE_BONUS = 150, },
		prerequisite = { exp_above = 100 },
		conditions = 
		{
			{ trait = "INSIDIOUS", prob = 50 },
			{ trait = "CAREFUL", prob = 50 },
		},
	},
	{
		id=4020, name="SPY expert",
		effects = { SABOTAGE_BONUS = 150, },
		prerequisite = { exp_above = 100 },
		conditions = 
		{
			{ trait = "INSIDIOUS", prob = 50 },
			{ trait = "CAREFUL", prob = 50 },
		},
	},

	{
		id=5010, name="dipl expert",
		effects = { IMPROVE_RELATION_BONUS = 150, },
		prerequisite = { exp_above = 100 },
		conditions = 
		{
			{ trait = "INSIDIOUS", prob = 50 },
			{ trait = "SMART", prob = 50 },
			{ trait = "OPEN", prob = 50 },			
		},
	},
	{
		id=5020, name="pact expert",
		effects = { SIGN_PACT_BONUS = 150, },
		prerequisite = { exp_above = 100 },
		conditions = 
		{
			{ trait = "INSIDIOUS", prob = 50 },
			{ trait = "SMART", prob = 50 },
			{ trait = "OPEN", prob = 50 },
		},
	},

	{
		id=6010, name="tech expert",
		effects = { RESEARCH_BONUS = 150, },
		prerequisite = { exp_above = 100 },
		conditions = 
		{
			{ trait = "CAREFUL", prob = 50 },
			{ trait = "HARDWORK", prob = 50 },
		},
	},

	{
		id=7010, name="atk expert",
		effects = { ATTACK = 150, },
		prerequisite = { exp_above = 100 },
		conditions = 
		{
			{ traits = { "STRONG", "AGGRESSIVE" }, prob = 70 },
			{ traits = { "STRONG", "IRRITABLE" }, prob = 70 },			
		},
	},
	{
		id=7020, name="def expert",
		effects = { DEFEND = 150, },
		prerequisite = { exp_above = 100 },
		conditions = 
		{
			{ trait = "CONSERVATIVE", prob = 50 },
			{ trait = "CAREFUL", prob = 50 },
		},
	},
	{
		id=7110, name="field expert",
		effects = { FIELD_COMBAT_BONUS = 150, },
		prerequisite = { exp_above = 100 },
		conditions = 
		{
			{ traits = { "STRONG", "INSIDIOUS" }, prob = 70 },
		},
	},
	{
		id=7120, name="siege expert",
		effects = { SIEGE_COMBAT_BONUS = 150, },
		prerequisite = { exp_above = 100 },
		conditions = 
		{
			{ traits = { "STRONG", "CAREFUL" }, prob = 30 },
		},
	},
	{
		id=7500, name="training expert",
		effects = { TRAINING = 50, },
		prerequisite = { exp_above = 100 },
		conditions = 
		{
			--{ trait = "CAREFUL", prob = 30 },
		},
	},
	{
		id=7510, name="Leadership Lv1",
		effects = { LEADERSHIP = 30, },
		prerequisite = { exp_above = 100 },
		conditions = 
		{
			--{ trait = "CAREFUL", prob = 30 },
		},
	},
}

DefaultTraitData = 
{
	{

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
