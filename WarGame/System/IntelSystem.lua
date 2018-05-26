--Get military power evaluation under intel report
function Intel_GetMilPower( city, fromCity )
	local spy   = fromCity:GetSpy( city )
	local data  = CitySpyParams.GRADE_DATA[spy.grade]
	local level =  data["MILITARY"]
	
	local power = city:GetMilitaryPower()
	if level == 1 then
		return math.ceil( power * Random_GetInt_Sync( 100, 150 ) * 0.01 )
	elseif level == 2 then
		return math.ceil( power * Random_GetInt_Sync( 100, 120 ) * 0.01 )
	elseif level == 3 then
		return power
	end
	--unknown
	return -1	
end

function Intel_GetSoldier( city, fromCity )
	local spy = fromCity:GetSpy( city )

	local data  = CitySpyParams.GRADE_DATA[spy.grade]
	local level =  data["MILITARY"]

	local power = city:GetSoldier()
	if level == 1 then
		return math.ceil( power * Random_GetInt_Sync( 100, 150 ) * 0.01 )
	elseif level == 2 then
		return math.ceil( power * Random_GetInt_Sync( 100, 120 ) * 0.01 )
	elseif level == 3 then
		return power
	end
	return -1
end

function Intel_GetGroupMilPower( dest, sour )
	local power = 0
	Asset_Foreach( dest, GroupAssetID.CITY_LIST, function ( city )
		local spy = sour:GetSpy( city )
		if spy then
			local cityPower = Intel_GetMilPower( spy.city, spy.sour )
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
		Asset_SetListItem( intel, IntelAssetID.SPYS_DURATION, group, dur )
	end )
end

function Intel_Update( intel )	
	local type = Asset_Get( intel, IntelAssetID.TYPE )
	Asset_Foreach( intel, IntelAssetID.SPYS_DURATION, function( dur, group )
		if dur > 0 then
			dur = dur - g_elapsed
			Asset_SetListItem( intel, IntelAssetID.SPYS_DURATION, group, dur )
			if dur <= 0 then
				--group receive intel
				--Stat_Add( "Intel@Gain", intel:ToString(), StatType.LIST )
				if type  == IntelType.HARASS_CITY then
					local target = Asset_GetListItem( intel, IntelAssetID.PARAMS, "actor" )
					Message_Post( MessageType.CITY_HOLD_MEETING, { city = Asset_Get( group, GroupAssetID.CAPITAL ), topic = MeetingTopic.UNDER_HARASS, target = target } )
				elseif type == IntelType.ATTACK_CITY then
					local target = Asset_GetListItem( intel, IntelAssetID.PARAMS, "actor" )
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