---------------------------------------------------------------------------------------
--
--
--
----------------------------------------------------------------------------------------

CharaGender = 
{
	MALE          = 0,
	FEMALE        = 1,
	HERMAPHRODITE = 2,
}

CharaOrigin = 
{
	--Load by data
	HISTORIC  = 0,
	--Generate randomly
	FICTIONAL = 1,
	--??
	GOD       = 2,
}

CharaGrade = 
{
	NORMAL    = 0,
	GOOD      = 1,
	EXCELLENT = 2,
	BEST      = 3,
	PERFECT   = 4,
}

--[[
CharaTitle = 
{
	NONE              = 0,
	
	LOW_TITLE         = 100,	
	OFFICER           = 101,
	CIVIAL_OFFICIAL   = 102,
	MILITARY_OFFICER  = 103,
	
	SPY               = 120,
	TRADER            = 130,
	BUILDER           = 140,
	MISSIONARY        = 150,

	HIGH_TITLE        = 200,
	ASSISTANT_MINISTER= 201,
	DIPLOMATIC        = 202,
	GENERAL           = 210,
	CAPTAIN           = 211,
	AGENT             = 220,	
	MERCHANT          = 230,
	TECHNICIAN        = 240,
	APOSTLE           = 250,
		
	IMPORTANT_TITLE   = 300,	
	PREMIER           = 301,
	CABINET_MINISTER  = 302,
	MARSHAL           = 310,
	ADMIRAL           = 311,
	SPYMASTER         = 320,
	ASSASSIN          = 321,
	MONOPOLY          = 330,
	SCIENTIST         = 340,
	INQUISITOR        = 350,
	
	LEADER_TITLE      = 400,
	MAYOR             = 400,
	EMPEROR           = 401,	--Empire
	KING              = 402,	--Kingdom
	LORD              = 403,	--Region
	LEADER            = 404,	--Guerrilla
	CHIEF             = 405,	--Family
	PRESIDENT         = 406,    --Nation
}
]]

CharaTitleGrade =
{
	NONE_TITLE     = 0,
	LOW_TITLE      = 1,
	HIGH_TITLE     = 2,
	IMP_TITLE      = 3,
	ROYAL_TITLE    = 4,
	SUPREME_TITLE  = 5,
}

CharaRelation = 
{
	FATHER   = 10,
	MOTHER   = 11,
	HUSBAND  = 20,
	WIFE     = 21,
	SON      = 30,
	DAUGHTER = 31,
	FRIEND   = 100,
	RIVAL    = 101,
	ENEMY    = 102,
}

CharaStatus = 
{
	----------------------------
	--Flag / Data	
	DEAD              = 1,
	OUTSIDE           = 10,	
	SURRENDER         = 11,

	IN_TASK           = 20,

	----------------------------
	--ACCUMULATION
	EXP               = 100,
	TOTAL_EXP         = 101,	
	OFFICER_EXP       = 102,
	MILITARY_EXP      = 103,
	DIPLOMAT_EXP      = 104,

	--
	REPUTATION        = 110,
	NOTORIETY         = 111,

	----------------------------
	-- Time Status( use to gain new trait )
	CD_STATUS_BEG     = 1000,

	PROPOSAL_CD       = 1000,
	WORK              = 1010,
	WORK_ON_AGRI      = 1011,
	WORK_ON_COMM      = 1012,
	WORK_ON_PROD      = 1013,

	CD_STATUS_END     = 2000,
	----------------------------
}

CharaActionPoint = 
{
	STAMINA  = 1,
	TACTIC   = 2,
	STRATEGY = 3,
	POLITICS = 4,
}

CharaSkillType = 
{
	DIPLOMAT  = 10,
	OFFICIALS = 11,
	HR        = 12,

	COMMANDER = 20,
	OFFICER   = 21,
	STAFF     = 22,

	TECHNICIAN = 30,	
}

CharaSkillEffectCondition = 
{
	IS_FIELD_COMBAT    = 10,
	IS_SIEGE_COMBAT    = 11,

	LEAD_INFANTRY      = 20,
	LEAD_CAVALRY       = 21,
	LEAD_MISSILE_UNIT  = 22,
	LEAD_SIEGEWEAPON   = 23,
}

CharaSkillEffect = 
{
	------------------------------------
	-- 

	------------------------------------
	--	
	HIRE_CHARA_BONUS   = 201,

	--increase agriculture development
	AGRICULTURE_BONUS  = 301,
	COMMERCE_BONUS     = 302,
	PRODUCTION_BONUS   = 303,
	BUILD_BONUS        = 310,
	LEVY_TAX_BONUS     = 311,

	RECONNOITRE_BONUS  = 401,
	SABOTAGE_BONUS     = 402,	
	ASSASSINATE        = 403,

	IMPROVE_RELATION_BONUS = 501,
	SIGN_PACT_BONUS        = 502,
	
	RESEARCH_BONUS     = 601,

	STAMINA_BONUS      = 700,
	STAMINA_LIMIT      = 701,	
	TACTIC_BONUS       = 702,
	TACTIC_LIMIT       = 703,
	STRATEGY_BONUS     = 704,
	STRATEGY_LIMIT     = 705,
	POLITICS_BONUS     = 706,
	POLITICS_LIMIT     = 707,

	------------------------------
	-- Commander related

	--Affect the damage made
	DAMAGE_BONUS       = 1001,
	--Affect the surffered damage
	DAMAGE_RESIST      = 1002,
	--Affect the damage to organization
	ORG_DAMAGE_BONUS   = 1003,
	--Affect the suffered damage to organization
	ORG_DAMAGE_RESIST  = 1004,
	
	--increase the maximum of the troop morale	
	MORALE_BONUS       = 1101,
	--increase the maximum of the troop organization, ratio not exactly number
	ORGANIZATION_BONUS = 1102,
	--affect the movement
	MOVEMENT_BONUS     = 1104,

	------------------------------
	-- Officer related
	--speed up the troop training
	TRAINING_EFF_BONUS = 2000,	
	TRAINING_EXP_BONUS = 2001,
}


CharaLoyalityType =
{
	------------------------
	-- Permanent Loyality
	NEUTRAL        = 10,
	TRAIT_SUITED   = 11,	
		
	------------------------
	-- Time Loyality
	BONUS          = 20,
	BLAME          = 21,	

	------------------------
	-- Tunable Loyality
	--How long from service
	TUNABLE_SEPERATOR = 100,

	SENIORITY = 100,
}

--
--
CharaTraitType = 
{
	--Use to process
	ALL          = 0,

	------------------------------------------------
	-- Atomic Trait
	--   Initialized at first( Generated )
	--   Only change in Event
	------------------------------------------------	
	
	ATOMIC_TRAIT = 0, --seperator, below is ATOMIC

	IDEAL        = 1,
	REALISM      = 2,
	ACTIVELY     = 3,
	PASSIVE      = 4,
	INTROVERT    = 5,
	EXTROVERT    = 6,
	
	TEMPLATE_TRAIT      = 100,

	TEMPLATE_OFFICER    = 101,
	TEMPLATE_LOBBYIST   = 102,
	TEMPLATE_DIPLOMATIC = 103,

	TEMPLATE_GENERAL    = 200,

	------------------------------------------------
	-- Extension
	--   Depends on atomic trait
	------------------------------------------------	
	EXTENSION_TRAIT = 1000, --seperator

	--Needs
	LUST          = 1000, --sex
	SEXLESS       = 1001, --sex
	HOMO          = 1002, --sex
	GLUTTONY      = 1003, --for food
	GREED         = 1004, --for money
	PRIDE         = 1005, --for honor
	AMBITION      = 1006, --for power

	--Mood
	BRAVE         = 1100,
	COWARD        = 1101,
	AGGRESSIVE    = 1102,
	CONSERVATIVE  = 1103,
	IRRITABLE     = 1104,
	DISPASSIONATE = 1105,
	CONTROL       = 1106,
	ENDURANCE     = 1107,
	
	--attitude to people
	OPEN          = 1200,
	CLOSE         = 1201,
	SELFISH       = 1202,
	GENEROUS      = 1203,
	FRIENDSHIP    = 1204,
	CONFIDENCE    = 1205,
	INSIDIOUS     = 1206,
	ENVY          = 1207,

	--attitude to work
	CAREFUL       = 1301,
	CARELESS      = 1302,
	HARDWORK      = 1303,
	SLOTH         = 1304,

	--talent
	FOOLISH       = 1401,
	SMART         = 1402,
	STRENGTH      = 1403,
	AGILITY       = 1404,
	WEAK          = 1405,  --can't learn any combat-skill
	
	----------------------------------------------
	--Normally
	--  Depends on Extension Trait
	NORMAL_TRAIT  = 10000, --seperator

	VOLUBLE       = 10001, --good at talk
	ACCOUNTING    = 10002, --good at calculate 
	OBSERVANT     = 10003, --good at observe
	INVENTION     = 10004, --good at creativity work
	MECHANICAL    = 10005, --good at mechanical work
}
