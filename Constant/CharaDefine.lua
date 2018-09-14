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

CharaJob = 
{
	NONE              = 0,
	
	LOW_RANK_JOB      = 100,	
	OFFICER           = 101,
	CIVIAL_OFFICIAL   = 102,
	MILITARY_OFFICER  = 103,
	
	SPY               = 120,
	TRADER            = 130,
	BUILDER           = 140,
	MISSIONARY        = 150,
		
	HIGH_RANK_JOB     = 200,
	ASSISTANT_MINISTER= 201,
	DIPLOMATIC        = 202,
	GENERAL           = 210,
	CAPTAIN           = 211,
	AGENT             = 220,	
	MERCHANT          = 230,
	TECHNICIAN        = 240,
	APOSTLE           = 250,
		
	IMPORTANT_JOB     = 300,	
	PREMIER           = 301,
	CABINET_MINISTER  = 302,
	MARSHAL           = 310,
	ADMIRAL           = 311,
	SPYMASTER         = 320,
	ASSASSIN          = 321,
	MONOPOLY          = 330,
	SCIENTIST         = 340,
	INQUISITOR        = 350,
	
	LEADER_JOB        = 400,
	MAYOR             = 400,
	EMPEROR           = 401,	--Empire
	KING              = 402,	--Kindom
	LORD              = 403,	--Region
	LEADER            = 404,	--Guerrilla
	CHIEF             = 405,	--Family
	PRESIDENT         = 406,    --Nation
}

CharaStatus = 
{
	----------------------------
	--Flag / Data
	IN_TASK           = 1,
	DEAD              = 2,
	SURRENDER         = 3,

	----------------------------
	--ACCUMULATION
	EXP               = 100,
	TOTAL_EXP         = 101,	
	OFFICER_EXP       = 102,
	MILITARY_EXP      = 103,
	DIPLOMATIC_EXP    = 104,

	----------------------------
	-- Time Status( use to gain new trait )
	CD_STATUS_BEG     = 1000,

	PROPOSAL_CD       = 1000,
	WORK              = 1010,
	WORK_ON_AGRI      = 1011,
	WORK_ON_COMM      = 1012,
	WORK_ON_PROD      = 1013,
	COMBAT            = 1011,

	CD_STATUS_END     = 2000,
	----------------------------
}

CharaActionPoint = 
{
	--STAMINA = 1,
	TACTIC   = 1,
	STRATEGY = 2,
	POLITICS = 3,
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
	HIRE_CHARA_BONUS   = 201,

	AGRICULTURE_BONUS  = 301,
	COMMERCE_BONUS     = 302,
	PRODUCTION_BONUS   = 303,
	BUILD_BONUS        = 304,
	LEVY_TAX_BONUS     = 305,

	RECONNOITRE_BONUS  = 401,
	SABOTAGE_BONUS     = 402,	
	ASSASSINATE        = 403,

	IMPROVE_RELATION_BONUS = 501,
	SIGN_PACT_BONUS        = 502,
	
	RESEARCH_BONUS     = 601,

	------------------------------
	-- Combat Relate

	--Affect the damage made
	DAMAGE_BONUS       = 1001,
	--Affect the surffered damage
	DAMAGE_RESIST      = 1002,
	--Affect the damage to organization
	ORG_DAMAGE_BONUS   = 1003,
	--Affect the suffered damage to organization
	ORG_DAMAGE_RESIST  = 1004,

	ARMOR_BONUS        = 1005,--not test
	ARMOR_BREAK        = 1006,--not test
	
	--increase the maximum of the troop morale	
	MORALE_BONUS       = 1101,
	--increase the maximum of the troop organization, ratio not exactly number
	ORGANIZATION_BONUS = 1102,
	--affect the movement
	MOVEMENT_BONUS     = 1104,
	--speed up the troop training
	TRAINING_BONUS     = 1100,
}

--
--
CharaTraitType = 
{
	------------------------------------------------
	-- Atomic Trait
	--   Initialized at first( Generated )
	--   Only change in Event
	------------------------------------------------

	IDEAL        = 100,
	REALISM      = 110,

	ACTIVELY     = 200,
	PASSIVE      = 210,

	INTROVERT    = 300,
	EXTROVERT    = 310,

	------------------------------------------------
	-- Extension
	--   Depends on atomic trait
	------------------------------------------------	
	EXTENSION_TRAIT = 1000, --seperator

	--Needs
	LUST          = 1000,
	SEXLESS       = 1001,
	HOMO          = 1002, 
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
