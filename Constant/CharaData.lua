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
		IRRITABLE     = 40,
		INSIDIOUS     = 40,
		DISPASSIONATE = -40,		
		LOVE_MONEY    = 40,
		LOVE_HONOR    = 40,
	},
	SEXLESS     =
	{
		SELFISH       = 40,
		AGGRESSIVE    = 60,
		CONSERVATIVE  = 100,
		IRRITABLE     = -40,
		INSIDIOUS     = 40,
		IRRITABLE     = -40,
		DISPASSIONATE = 40,
		LOVE_MONEY    = -40,
		LOVE_HONOR    = -40,
	},

	IDEAL        =
	{
		AGGRESSIVE    = 20,
		HARDWORK      = 40,
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
		HARDWORK      = 40,
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
		HARDWORK     = 20,
		IRRITABLE    = 30,
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
		CAREFUL       = -50,
		CARELESS      = 50,
		IRRITABLE     = 40,
		LOVE_MONEY    = 20,
		LOVE_HONOR    = 20,
		SMART         = -40,
		FOOLISH       = -40,
	},
	WEAK         =
	{
		CAREFUL       = 50,
		CARELESS      = -50,
		IRRITABLE     = -40,
		SMART         = 40,
		FOOLISH       = -40,
	},
	INTROVERT    =
	{
		CAREFUL       = 50,
		CARELESS      = -50,
		IRRITABLE     = -50,
		DISPASSIONATE = 50,
		LOVE_HONOR    = 40,
	},
	EXTROVERT    =
	{
		CARELESS      = 50,
		CAREFUL       = -50,
		IRRITABLE     = 40,
		DISPASSIONATE = -40,
		LOVE_MONEY    = 40,
		LOVE_HONOR    = 40,
	},
}

--"prerequisite" means these condition should always be satisfied
--"traits" means one of every subset conditions should be satisfied
DefaultCharaSkill = 
{
	{
		id=2000, name="HR expert",
		effects = { HIRE_CHARA_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits  = { { "OPEN" } },
	},

	{
		id=3010, name="Agri expert",
		effects = { AGRICULTURE_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits  = { { "HARDWORK" } },
	},
	{
		id=3020, name="Comm expert",
		effects = { COMMERCE_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits  = { { "HARDWORK" } },
	},
	{
		id=3030, name="Prod expert",
		effects = { PRODUCTION_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits  = { { "HARDWORK" } },
	},
	{
		id=3040, name="Builder expert",
		effects = { BUILD_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits = { { "HARDWORK" } },
	},
	{
		id=3050, name="Tax expert",
		effects = { LEVY_TAX_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits = { { "HARDWORK" } },
	},

	{
		id=4010, name="SCOUT expert",
		effects = { RECONNOITRE_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits = { { "HARDWORK" } },
	},
	{
		id=4020, name="SPY expert",
		effects = { SABOTAGE_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits = { { "INSIDIOUS" } },
	},

	{
		id=5010, name="dipl expert",
		effects = { IMPROVE_RELATION_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits = { { "SMART" } },
	},
	{
		id=5020, name="pact expert",
		effects = { SIGN_PACT_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits = { { "INSIDIOUS" } },
	},

	{
		id=6010, name="tech expert",
		effects = { RESEARCH_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits = { { "CAREFUL" } },
	},

	{
		id=7010, name="atk expert",
		effects = { ATTACK = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits = { { "AGGRESSIVE" } },
	},
	{
		id=7020, name="def expert",
		effects = { DEFEND = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits = { { "CONSERVATIVE" } },
	},
	{
		id=7110, name="field expert",
		effects = { FIELD_COMBAT_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits = { { "STRONG", "INSIDIOUS" } },
	},
	{
		id=7120, name="siege expert",
		effects = { SIEGE_COMBAT_BONUS = 150, },
		prerequisite = { pot_above, exp_above = 100 },
		traits = { { "STRONG", "CAREFUL" } },
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
