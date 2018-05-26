--------------------------------------------
--

TechType = 
{
	WEAPON      = 100,
	ARMOR       = 110,
	ORGNIZATION = 120,

	AGRICULTURE = 200,
	COMMERCE    = 210,
	PRODUCTION  = 220,
}


----------------------------------------------------------------------------------------
--
--
--
----------------------------------------------------------------------------------------

GroupDomin = 
{

	DOMINATION,
}

GroupRepuation = 
{

}

GroupGoalType = 
{
	---------------------------------
	--Final goal
	
	--Control terriority percent
	TERRIORITY        = 11,

	--no enemy group
	DOMINATION        = 12,

	DOMINATION_TERRIORITY = 10,

	---------------------------------
	SHORT_GOAL_SEPARATOR  = 100,

	--commander
	--aggressive, occupy enemy city
	OCCUPY_CITY       = 101,
	--aggressive, increase soldier
	ENHANCE_CITY      = 102,
	--aggressive, increase the dev score
	DEVELOP_CITY      = 103,
	--defe
	DEFEND_CITY       = 104,	
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

