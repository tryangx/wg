

----------------------------------------------------------------------------------------
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

	--
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


	----------------------------
	--ACCUMULATION
	EXP               = 100,

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



--
-- Selfish --       
-- Close -- Open
--
--
CharaTraitType = 
{
	------------------------
	--atomic( won't changed after initialize except trigger event )

	LIBIDO       = 10,
	SEXLESS      = 20,
	
	IDEAL        = 200,
	REALISM      = 210,

	ACTIVELY     = 300,
	PASSIVE      = 310,

	INTROVERT    = 400,
	EXTROVERT    = 410,

	STRONG       = 500,
	WEAK         = 510,

	------------------------
	--extension( leads by atomic trait when level up )
	EXTENSION_TRAIT = 1000,

	--mental
	LOVE_MONEY   = 1010,
	LOVE_HONOR   = 1011,

	AGGRESSIVE   = 1020,
	CONSERVATIVE = 1021,

	SELFISH    = 1030,
	GENEROUS   = 1031,

	CAREFUL    = 1040,
	CARELESS   = 1041,

	INSIDIOUS  = 1050,
	NOBEL      = 1051,

	IRRITABLE     = 1060,
	DISPASSIONATE = 1061,

	HARDWORK   = 2020,
	LAZY       = 2021,

	SMART      = 2030,
	FOOLISH    = 2031,

	OPEN       = 2040,
	CLOSE      = 2041,


	-----------------------
	--Normally ( which will leads to extension )
	NORMAL_TRAIT   = 10000,
}
