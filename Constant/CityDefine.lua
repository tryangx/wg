
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

	--military
	RESERVES = 1,
	SOLDIER  = 2,

	--lower-class
	HOBO     = 10,
	CHILDREN = 11,
	OLD      = 12,
	
	--labour	
	FARMER   = 20,
	WORKER   = 21,
	MERCHANT = 22,

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