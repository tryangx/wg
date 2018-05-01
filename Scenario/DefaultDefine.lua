----------------------------------------------------------------------------------------
--
-- Grade Evaluation
--
----------------------------------------------------------------------------------------

GradeEvaluation_Type = 
{
	SS = 110,
	S = 95,
	A = 85,
	B = 75,
	C = 65,
	D = 45,
	E = 30,
	F = -999,
}

----------------------------------------------------------------------------------------
--
-- Plot & Terrain & Feature & Addition 
--
----------------------------------------------------------------------------------------

PlotType = 
{
	NONE     = 0,
	LAND     = 1,
	HILLS    = 2,
	MOUNTAIN = 3,
	WATER    = 4,
}

PlotTerrainType =
{
	NONE      = 0,
	PLAINS    = 1,
	GRASSLAND = 2,	
	DESERT    = 3,
	TUNDRA    = 4,
	SNOW      = 5,
	LAKE      = 6,
	COAST     = 7,
	OCEAN     = 8,
}

PlotFeatureType = 
{
	ALL         = -1,
	NONE        = 0,
	WOODS       = 1,
	RAIN_FOREST = 2,
	MARSH       = 3,
	OASIS       = 4,
	FLOOD_PLAIN = 5,
	ICE         = 6,
	FALLOUT     = 7,
}

PlotAddition = 
{
	NONE      = 0,
	RIVER     = 1,
	CLIFFS    = 2,
}


----------------------------------------------------------------------------------------
--
--
--
----------------------------------------------------------------------------------------

ResourceCategory = 
{
	NONE       = 0,
	STRATEGIC  = 1,	
	BONUS      = 2,
	LUXURY     = 3,
	NATURAL    = 4,
	ARTIFICIAL = 5,
}

ResourceCondition =
{
	CONDITION_BRANCH         = 1,
	PROBABILITY              = 2,
	PLOT_TYPE                = 10,	
	PLOT_TERRAIN_TYPE        = 11,	
	PLOT_FEATURE_TYPE        = 12,
	PLOT_TYPE_EXCEPT         = 13,
	PLOT_TERRAIN_TYPE_EXCEPT = 14,
	PLOT_FEATURE_TYPE_EXCEPT = 15,
	NEAR_PLOT_TYPE           = 20,
	NEAR_TERRAIN_TYPE        = 21,
	NEAR_FEATURE_TYPE        = 22,
	AWAY_FROM_CITY_TYPE      = 23,
	AWAY_FROM_TERRAIN_TYPE   = 24,
	AWAY_FROM_FEATURE_TYPE   = 25,
}

----------------------------------------------------------------------------------------
--
--
--
----------------------------------------------------------------------------------------

DistrictCategory = 
{
	NONE        = 0,
	SETTLEMENT  = 1,
}

----------------------------------------------------------------------------------------
--
--
--
----------------------------------------------------------------------------------------

GroupGoalType = 
{
	--Final goal
	
	--Control terriority percent
	DOMINATION_TERRIORITY = 10,	

	---------------------------------
	SHORT_GOAL_SEPARATOR  = 100,

	--improve growth ability in city 
	DEVELOP_CITY      = 101,
	--improve growth ability in all city
	DEVELOP_GROUP     = 102,

	--
	ENHANCE_CITY      = 110,
	ENHANCE_GROUP     = 102,
}

GroupGovernment = 
{
	------------------------------------
	-- Comment     : Fallen	
	NONE          = 0,

	------------------------------------
	-- Comment     : 
	-- Destruction : Lose Capital
	-- Order       : No limited
	-- Purpose     : Survive / Power
	-- Belong      : Empire
	-- Special     : 
	-- Condition   : Control 5% Territory in the continent
	-- Leader      : Hereditary ( Leader dead )
	KINGDOM       = 1,
	
	------------------------------------
	-- Comment     : 
	-- Destruction : Lose Capital
	-- Order       : No limited
	-- Purpose     : Conquer
	-- Belong      : Empire
	-- Special     :
	-- Condition   : Control 35% Territory in the continent
	--               Military Rank At least 3rd
	-- Leader      : Hereditary ( Leader dead )
	EMPIRE        = 2,
		
	------------------------------------
	-- Comment     : Independent / Economic / Military Region
	-- Destruction : Lose all cities
	-- Order       : No technological, 
	-- Purpose     : Power / Survive
	-- Belong      : None / Kingdom / Empire
	-- Special     : 
	-- Condition   : Has Capital( At least City )
	-- Leader      : ENFEOFF ( None Leader ) / Hereditary ( Leader dead )
	REGION        = 3,
	
	------------------------------------
	-- Comment     : Sometime like Horde 
	-- Destruction : Lose capital
	-- Order       : No technological, economic, political
	-- Purpose     : Survive
	-- Belong      : Region / Kingdom / Empire
	-- Special     : Character can join only by event
	-- Condition   : Has Capital( Town / village )
	FAMILY        = 4,
	
	------------------------------------
	-- Comment     : 
	-- Destruction : Change government
	-- Order       : No technological, economic, political order
	-- Purpose     : Independent
	-- Belong      : 
	-- Special     : Won't be destroyed
	-- Condition   : Event Occur
	GUERRILLA     = 5,
	
	------------------------------------
	-- Comment     : Belong to Indenpendce government
	-- Destruction : Lose all cities
	-- Order       : No limited
	-- Purpose     : Short term goal
	-- Belong      : None
	-- Special     : 
	-- Leader      : Election ( Leader dead / Term end )
	WARZONE       = 6,
}

----------------------------------------------------------------------------------------
--
--
--
----------------------------------------------------------------------------------------

CityJob = 
{
	NONE             = 0,
	--All city
	CHIEF_EXECUTIVE  = 1,

	POSITION_BEGIN   = 10,
	CHIEF_COMMANDER  = 11,
	CHIEF_STAFF      = 12,
	CHIEF_HR         = 13,
	CHIEF_AFFAIRS    = 14,
	POSITION_END     = 15,

	--capital
	CHIEF_DIPLOMATIC = 15,
	CHIEF_TECHNICIAN = 16,
	CAPITAL_POSITION_END = 17,
}

CityPlan = 
{
	NONE       = 0,
	HR         = 1,
	AFFAIRS    = 2,
	COMMANDER  = 3,
	STAFF      = 4,

	DIPLOMATIC = 5,
	TECHNICIAN = 6,

	ALL        = 10,
}

--[[

#POPULATION LEVEL
lv5 noble, rich
lv4 bachelor, officeer
lv3 middle
lv2 farmer, merchant, worker, soldier
lv1	hobo


#NON-SOLDIER POPU -> SOLDIER
        recruit  conscript  volunteer
farmer     o         o          o           
merchant   o         o          o 
worker     o         o          o
middle               o          o
bachelor             o          o 
officer              o          o
rich                 o          
noble                           o
hobo       o         o          o
]]

CityPopu = 
{
	ALL      = 0,

	HOBO     = 10,
	CHILDREN = 11,
	
	FARMER   = 20,
	WORKER   = 21,
	MERCHANT = 22,
	RESERVES = 23,

	MIDDLE   = 30,
	
	BACHELOR = 40,
	OFFICER  = 41,
	
	RICH     = 50,
	NOBLE    = 51,	
}

--Default Value: true / false / nil
CityStatus = 
{
	IN_SIEGE           = 20,
	STARVATION         = 21,

	MILITARY_WEAK      = 100,
	MILITARY_DANGER    = 101,

	DEVELOPMENT_WEAK   = 110,
	DEVELOPMENT_DANGER = 111,

	BATTLEFRONT        = 120,
	SAFETY             = 121,
}

CityInstruction = 
{
	--no set
	DEFAULT              = 0,

	MILITARY_PRIORITY    = 1,

	DEVELOPMENT_PRIORITY = 2,
}

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
	PROPOSAL_CD       = 10,

	IN_TASK           = 20,
}

----------------------------------------------------------------------------------------
--
-- Corps & Troop
--
----------------------------------------------------------------------------------------

WeaponDamageType = 
{
	NORMAL    = 1,
	PIERCE    = 2,
	FORTIFIED = 3,
}

WeaponRangeType = 
{
	CLOSE   = 1,
	LONG    = 2,
	MISSILE = 3,
}

ConveyanceType = 
{
	FOOT    = 0,
	HORSE   = 1,
	CHARIOT = 2,
	WAGON   = 3,
}

TroopCategory = 
{
	--Light footman, use long-range weapon like bow, crossbow
	MISSILE_UNIT = 1,
	--Heavey footman, anti Cavalry
	INFANTRY     = 2,	
	--footman with conveyance
	CAVALRY      = 3,
	--
	SIEGE_WEAPON = 4,
	--
	ASSISTANT    = 5,
}

TroopConsume = 
{
	FOOD     = 1,
	MONEY    = 2,
}

TroopRequirement = 
{
	SOLDIER  = 0,
	MONEY    = 1,
	MATERIAL = 2,
	TECH     = 3,
}

TroopStatus = 
{
	--range: 1-10
	STARVATION = 10,

	SURRENDER  = 11,
}

CorpsStatus = 
{
	IN_COMBAT = 10,

	IN_TASK   = 11,	
}

CorpsPurpose =
{
	FIELD_COMBAT       = 1,
	SIEGE_COMBAT       = 2,
}

----------------------------------------------------------------------------------------
--
-- Proposal & Task
--
----------------------------------------------------------------------------------------

ProposalStatus = 
{
	SUBMITTED    = 1,
	PERMITTED    = 2,
	REJECTED     = 3,
}

ProposalType = 
{
	HARASS_CITY     = 110,
	ATTACK_CITY     = 111,
	INTERCEPT       = 112,
	DISPATCH_CORPS  = 113,

	ESTABLISH_CORPS = 120,
	REINFORCE_CORPS = 121,
	DISMISS_CORPS   = 122,
	TRAIN_CORPS     = 123,
	UPGRADE_CORPS   = 124,	
	ENROLL_CORPS    = 126,
	REGROUP_CORPS   = 127,

	CONSCRIPT       = 130,
	RECRUIT         = 131,

	DEV_AGRICULTURE = 310,
	DEV_COMMERCE    = 311,
	DEV_PRODUCTION  = 312,		
	BUILD_CITY      = 320,
	LEVY_TAX        = 321,
	CONSCRIPT       = 330,
	RECRUIT         = 331,

	HIRE_CHARA      = 400,
	PROMOTE_CHARA   = 401,
	DISPATCH_CHARA  = 402,
	CALL_CHARA      = 403,

	RECONNOITRE     = 500,
	SABOTAGE        = 501,

	RESEARCH        = 600,

	IMPROVE_RELATION = 700,
	DECLARE_WAR      = 701,
	SIGN_PACT        = 702,
}

--all proposal type should exist in TaskType or it'll occur error
TaskType = 
{
	HARASS_CITY     = 110,
	ATTACK_CITY     = 111,
	INTERCEPT       = 112,
	DISPATCH_CORPS  = 113,

	ESTABLISH_CORPS = 120,
	REINFORCE_CORPS = 121,
	DISMISS_CORPS   = 122,
	TRAIN_CORPS     = 123,
	UPGRADE_CORPS   = 124,
	ENROLL_CORPS    = 126,
	REGROUP_CORPS   = 127,

	CONSCRIPT       = 130,
	RECRUIT         = 131,

	DEV_AGRICULTURE = 310,
	DEV_COMMERCE    = 311,
	DEV_PRODUCTION  = 312,
	BUILD_CITY      = 320,
	LEVY_TAX        = 321,

	HIRE_CHARA      = 400,
	PROMOTE_CHARA   = 401,
	DISPATCH_CHARA  = 402,
	CALL_CHARA      = 403,

	RECONNOITRE     = 500,
	SABOTAGE        = 501,

	RESEARCH        = 600,

	IMPROVE_RELATION = 700,
	DECLARE_WAR      = 701,
	SIGN_PACT        = 702,
}

TaskActorType = 
{
	CHARA    = 1,
	CORPS    = 2,
}

TaskStep = 
{
	--some task needs time to prepare, like establish corps, attack city, etc.
	PREPARE = 1,

	--when arrive the destination, task can be execute
	EXECUTE = 2,

	--after task succeed or failed, task should be reply
	FINISH  = 3,

	REPLY   = 4,
}

TaskStatus = 
{
	--normal status, always idle
	RUNNING    = 0,
	--means current step is waiting until duration time elapsed
	WAITING    = 1,
	--means acotr is moving, should wait
	MOVING     = 2,
	--means task is working, should wait for finish
	WORKING    = 3,
}

TaskResult = 
{
	UNKNOWN = 0,
	SUCCESS = 1,
	FAILED  = 2,
}

------------------------------

EventType =
{
	--Nature
	DISASTER = 100,

	--Man-made
	WARFARE  = 200,
}

EventCondition = 
{

}

EventEffect = 
{
	--force 
	COOLDOWN = 10,
}

EventFlag = 
{
	------------------------------------------
	--TempoRARY flag( cleared in every UPDATE )
	TEMP_FLAG_RESERVED    = 1000,	--reserved separator
	
	EVT_TRIGGER_THIS_TURN = 1000,
	
	------------------------------------------
	--Global flag( only clear manually )
	GLOBAL_FLAG_RESERVED  = 2000,	--separator

	EVT_TRIGGER_BEFORE    = 2001,	

	------------------------------------------
	--User define flag
	USER_FLAG_RESERVED    = 3000,

	--to do or defined in other ENUM
}

------------------------------

MeetingTopic =
{
	NONE                  = 0,

	--enemy send corps to attack out territory
	UNDER_ATTACK          = 1,
	UNDER_HARASS          = 2,

	---------------------------------
	MEETING_LOOP          = 11,

	--CHIEF_EXECUTIVE       = 10,

	--research
	TECHNICIAN            = 11,

	--declare war, sign pact
	DIPLOMATIC            = 12,

	--hire, encourage
	HR                    = 13,

	--agriculture, commerce, production
	AFFAIRS               = 14,

	--establish corps, reinforce corps
	COMMANDER             = 15,	

	STAFF                 = 16,

	--harass, attack
	STRATEGY              = 17,

	--should be the last topic + 1
	MEETING_END           = 18,
	---------------------------------
}

------------------------------
--All system should depend on messages and process with them
MessageType = 
{
	------------------------------------
	--start / resume move

	--@param actor
	START_MOVING          = 70,
	--@param actor
	STOP_MOVING           = 71,
	--@param actor
	CANCEL_MOVING         = 72,
	------------------------------------


	--actor, destination	
	ARRIVE_DESTINATION    = 80,	

	CORPS_ATTACK          = 91,

	----------------------------------
	-- Combat Relative

	COMBAT_TRIGGERRED     = 100,
	--@param plot encounter when moving
	--@param city harass city task
	--@param atk  always valid
	--@param def  defender corps, only valid in encouter
	--@param task param
	FIELD_COMBAT_TRIGGER  = 101,
	SIEGE_COMBAT_TRIGGER  = 102,	

	COMBAT_OCCURED        = 110,
	FIELD_COMBAT_OCCURED  = 111,
	SIEGE_COMBAT_OCCURED  = 112,

	COMBAT_ENDED          = 120,

	COMBAT_REMOVE         = 140,	
	----------------------------------

	----------------------------------
	CITY_HOLD_MEETING     = 200,
	----------------------------------
}

------------------------------

IntelType = 
{
	HARASS_CITY   = 10,
	ATTACK_CITY   = 11,
}

------------------------------

MoveRole = 
{
	CHARA = 1,
	CORPS = 2,
}

MoveStatus = 
{
	MOVING  = 0,
	SUSPEND = 1,
	STOP    = 2,
}

------------------------------

RelationOpinion = 
{
	--base
	TRUST      = 1,

	--status
	WAS_AT_WAR = 10,
	AT_WAR     = 11,
	OLD_ENEMY  = 12,
	
	--pact
	NO_WAR     = 20,
	TRADE      = 21,
	PROTECT    = 22,
	ALLY       = 23,
}

RelationPact = 
{
	PEACE    = 10,
	NO_WAR   = 11,
	TRADE    = 12,
	PROTECT  = 13,
	ALLY     = 14,
}

DiplomacyMethod = 
{
	IMPROVE_RELATION = 1,
	DECLARE_WAR      = 2,
	SIGN_PACT        = 3,
}

------------------------------

FeatureOption =
{
	ENABLE_FOOD_SUPPLY = 0,
}

----------------------------------------------------------------------------------------

SkillEffectType = 
{
	HIRE_CHARA_BONUS   = 201,

	AGRICULTURE_BONUS  = 301,
	COMMERCE_BONUS     = 302,
	PRODUCTION_BONUS   = 303,
	BUILD_BONUS        = 304,
	LEVY_TAX_BONUS     = 305,

	RECONNOITRE_BONUS  = 401,
	SABOTAGE_BONUS     = 402,

	IMPROVE_RELATION_BONUS = 501,
	SIGN_PACT_BONUS        = 502,
	
	RESEARCH_BONUS     = 601,

	ATTACK             = 701,
	DEFEND             = 702,
	FIELD_COMBAT_BONUS = 711,
	SIEGE_COMBAT_BONUS = 711,
}

--
-- Selfish --       
-- Close -- Open
--
--
TraitEffectType = 
{
	--mental
	OPEN  = 1010,
	CLOSE = 1011,
	
	AGGRESSIVE   = 1020,
	CONSERVATIVE = 1021,

	SELFISH    = 1030,
	GENEROUS   = 1031,

	CAREFUL    = 1040,
	CARELESS   = 1041,

	INSIDIOUS  = 1050,
	NOBEL      = 1051,

	IRRITABLE  = 1060,
	DISPASSIONATE = 1061,

	--physical
	STRONG     = 2010,
	WEAK       = 2011,

	HARDWORK   = 2020,
	LAZY       = 2021,

	SMART      = 2030,
	FOOLISH    = 2031,
}

TechType = 
{
	WEAPON      = 100,
	ARMOR       = 110,
	ORGNIZATION = 120,

	AGRICULTURE = 200,
	COMMERCE    = 210,
	PRODUCTION  = 220,
}