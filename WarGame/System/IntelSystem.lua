
function Intel_Get( city, fromCity, type )
	local spy = fromCity:GetSpy( city )
	local data  = CitySpyParams.GRADE_DATA[spy.grade]
	local level =  data["MILITARY"]

	local value = 0
	if type == CityIntelType.MILITARY then
		value = city:GetMilitaryPower()

	elseif type == CityIntelType.SOLDIER then
		value = city:GetSoldier() + city:GetPopu( CityPopu.RESERVES )

	elseif type == CityIntelType.DEFENDER then		
		value = city:GetPopu( CityPopu.SOLDIER ) + city:GetPopu( CityPopu.RESERVES ) + city:GetPopu( CityPopu.GUARD )

	else
		error( "unkown intel type=" .. type )
	end

	local seed = g_Time:GetDateValue() + Entity_GetSeed( city ) + Entity_GetSeed( fromCity )

	if level == 1 then
		return math.ceil( value * Random_GetInt_Const( 80, 150, seed ) * 0.01 )
	elseif level == 2 then
		return math.ceil( value * Random_GetInt_Const( 90, 120, seed ) * 0.01 )
	elseif level == 3 then
		return value
	end

	return -1
end

function Intel_GetGroup( dest, sour, type )
	local power = 0
	Asset_Foreach( dest, GroupAssetID.CITY_LIST, function ( city )
		local spy = sour:GetSpy( city )
		if spy then
			local cityPower = Intel_Get( spy.city, spy.sour, type )
			if cityPower ~= -1 then
				power = power + cityPower
			end
		end
	end )
	return power
end

---------------------------------------------------

function Intel_Post( inteltype, city, params )	
	local intel = Entity_New( EntityType.INTEL )
	Asset_Set( intel, IntelAssetID.TYPE, inteltype )
	Asset_Set( intel, IntelAssetID.SOURCE, city )
	Asset_CopyDict( intel, IntelAssetID.PARAMS, params )

	local curGroup = Asset_Get( city, CityAssetID.GROUP )
	Entity_Foreach( EntityType.GROUP, function ( group )
		if group == curGroup then return end
		local dur = Move_CalcIntelTransDuration( nil, Asset_Get( group, GroupAssetID.CAPITAL ), city )
		--InputUtil_Pause( "intel to " .. group.name, "need dur=" .. dur )
		Asset_SetDictItem( intel, IntelAssetID.SPYS_DURATION, group, dur )
	end )
end

function Intel_Update( intel )	
	local type = Asset_Get( intel, IntelAssetID.TYPE )
	Asset_Foreach( intel, IntelAssetID.SPYS_DURATION, function( dur, group )
		if dur > 0 then
			dur = dur - g_elapsed
			Asset_SetDictItem( intel, IntelAssetID.SPYS_DURATION, group, dur )
			if dur <= 0 then
				--group receive intel
				--Stat_Add( "Intel@Gain", intel:ToString(), StatType.LIST )
				if type  == IntelType.HARASS_CITY then
					local target = Asset_GetDictItem( intel, IntelAssetID.PARAMS, "actor" )
					Message_Post( MessageType.CITY_HOLD_MEETING, { city = Asset_Get( group, GroupAssetID.CAPITAL ), topic = MeetingTopic.UNDER_HARASS, target = target } )
				elseif type == IntelType.ATTACK_CITY then
					local target = Asset_GetDictItem( intel, IntelAssetID.PARAMS, "actor" )
					Message_Post( MessageType.CITY_HOLD_MEETING, { city = Asset_Get( group, GroupAssetID.CAPITAL ), topic = MeetingTopic.UNDER_ATTACK, target = target } )
				end
			end
		end
	end )
end

---------------------------------------

IntelSystem = class()

function IntelSystem:__init()
	System_Setup( self, SystemType.INTEL_SYS )
end

function IntelSystem:Start()
	self._intels = {}
end

function IntelSystem:Update()
	Entity_Foreach( EntityType.INTEL, Intel_Update )
end

function IntelSystem:Post( type, params )	
end