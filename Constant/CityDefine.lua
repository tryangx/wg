
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

	--defensive
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
	---------------------------------
	-- Flag
	---------------------------------
	IN_SIEGE           = 20,
	STARVATION         = 21,	

	OLD_CAPITAL        = 30,
	
	--startegy priority
	--build defensive in DEFEND_CITY goal	
	--receive resources
	ADVANCED_BASE      = 31,	
	--official priority
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

	EXPAND_PLOT        = 60,
	EXPAND_END         = 61,

	-----------------------------------
	--sabotage success or something else will trigger this for at least 3 mons
	MOBILE_MERCHANT    = 101,
	--Measure the price to buy/sell food
	PRICE              = 102,

	FLOOD              = 110,
	LOCUSTS_PLAGUE     = 111,
	PLAGUE             = 114,
	TYPHOON            = 112,
	BLIZZARD           = 113,

	-----------------------------------
	--time
	TIME_STATUS_BEG    = 1000,
	
	VIGILANT           = 1001,
	DEMONSTRATE        = 1002,
	STRIKE             = 1003,
	WAR_WEARINESS      = 1004,

	EXPAND_DURATION    = 1500,

	TIME_STATUS_END    = 1999,

	-----------------------------------
	--not enough aggressive military power
	AGGRESSIVE_WEAK    = 3000,
	AGGRESSIVE_ADV     = 3001,
	--not enough defender military power
	DEFENSIVE_WEAK     = 3010,	
	DEFENSIVE_DANGER   = 3011,
	--need develop
	DEVELOPMENT_WEAK   = 3020,
	DEVELOPMENT_DANGER = 3021,

	--not enough reserves
	RESERVE_UNDERSTAFFED = 3030,
	RESERVE_NEED         = 3031,
}

CityJob = 
{
	NONE            = 0,
	--All city
	EXECUTIVE       = 1,

	POSITION_BEGIN  = 10,  --begin
	COMMANDER       = 11,
	STAFF           = 12,
	HR              = 13,
	OFFICIAL        = 14,
	POSITION_END    = 14,  --end

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
	--add slot for diplomat
	FOREIGN     = 50,	
	MISC        = 60,
}


CityConstrEffect = 
{
	--function 
	TRADE          = 100,

	--attributes
	FORT           = 200,

	--support more jobs	
	COMMANDER_SLOT = 210,
	OFFICIAL_SLOT  = 211,
	HR_SLOT        = 212,
	STAFF_SLOT     = 213,
	DIPLOMAT_SLOT  = 214,
	TECHNICIAN     = 215,	

	--Attributes
	--Measure the soldier can support in SING city, out of range will gain debuff
	SUPPLY_SOLDIER = 300,	

	CORPS_LIMIT    = 301,
	TROOP_LIMIT    = 302,
	SOLDIER_LIMIT  = 303,
}

CitySecurity = 
{
	OFFICER = 10,
	GUARD   = 11,
	SOLDIER = 12,

	PATROL  = 20,
	EVENT   = 21,
}

CityDiss = 
{
	--attack / been attacked
	FRONTIER    = 11,
	BATTLEFRONT = 12,

	--been seiged
	IN_SIEGE    = 13,
	STARVATION  = 14,

	LEVY_TAX      = 20,
	DEMONSTRATION = 21,
	STRIKE        = 22,
}