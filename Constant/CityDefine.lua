
----------------------------------------------------------------------------------------
--
--
--
----------------------------------------------------------------------------------------

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

	PLEB     = 100,

	--military
	REFUGEE  = 1,

	---------------------
	--Below is not include in city
	
	--lower-class
	HOBO     = 10,	
	CHILDREN = 11,
	OLD      = 12,
	
	--labour	
	FARMER   = 20,
	WORKER   = 21,
	MERCHANT = 22,
	CORVEE   = 23,

	RESERVES = 24,
	SOLDIER  = 25,	

	MIDDLE   = 30,
	
	--servant
	BACHELOR = 40,
	OFFICER  = 41,
	GUARD    = 42,
	
	--bigwigs
	RICH     = 50,
	NOBLE    = 51,	
}

--Default Value: true / false / nil
CityStatus = 
{
	IN_SIEGE           = 20,
	STARVATION         = 21,

	OLD_CAPITAL        = 30,
	--startegy priority
	--build defensive in DEFEND_CITY goal	
	--receive resources
	ADVANCED_BASE      = 31,	
	--affairs priority
	--transport resource to advanced_base
	PRODUCTION_BASE    = 32,
	--commander priority
	--dispatch corps to adanvaced_base
	MILITARY_BASE      = 33,

	-------------------------

	BATTLEFRONT        = 40,
	FRONTIER           = 41,
	SAFETY             = 42,
	BUDGET_DANGER      = 50,

	-----------------------------------
	--sabotage success or something else will trigger this for at least 3 mons
	VIGILANT           = 100,
	MOBILE_MERCHANT    = 101,

	FLOOD              = 110,
	LOCUSTS_PLAGUE     = 111,
	PLAGUE             = 114,
	TYPHOON            = 112,
	BLIZZARD           = 113,

	-----------------------------------
	--not enough aggressive military power
	AGGRESSIVE_WEAK    = 1000,
	AGGRESSIVE_ADV     = 1001,
	--not enough defender military power
	DEFENSIVE_WEAK     = 1010,	
	DEFENSIVE_DANGER   = 1011,
	--need develop
	DEVELOPMENT_WEAK   = 1020,
	DEVELOPMENT_DANGER = 1021,

	--not enough reserves
	RESERVE_UNDERSTAFFED = 1030,
	RESERVE_NEED         = 1031,
}

CityJob = 
{
	NONE            = 0,
	--All city
	EXECUTIVE       = 1,

	POSITION_BEGIN  = 10,
	COMMANDER       = 11,
	STAFF           = 12,
	HR              = 13,
	AFFAIRS         = 14,
	POSITION_END    = 15,

	--capital
	DIPLOMATIC      = 15,
	TECHNICIAN      = 16,
	CAPITAL_POSITION_END = 17,
}

CityIntelType = 
{
	--potential aggressive military power( exclude defend )
	MILITARY  = 10,
	SOLDIER   = 11,
	DEFENDER  = 12,
}

------------------------------------

CityConstructionType = 
{
	DEVELOPMENT = 10,
	MANAGEMENT  = 20,
	MILITARY    = 30,
	DEFENSIVE   = 40,
	FOREIGN     = 50,
	MISC        = 60,
}


CityConstrEffect = 
{	
	FORT = 400,
}

