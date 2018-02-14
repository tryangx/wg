
function Intel_Post( inteltype, city, params )	
	local intel = Entity_New( EntityType.INTEL )
	Asset_Set( intel, IntelAssetID.TYPE, inteltype )
	Asset_Set( intel, IntelAssetID.SOURCE, city )
	Asset_CopyDict( intel, IntelAssetID.PARAMS, params )

	local curGroup = Asset_Get( city, CityAssetID.GROUP )
	Entity_Foreach( EntityType.GROUP, function ( group )
		if group == curGroup then return end
		local dur = Route_QueryPathDistance( Asset_Get( group, GroupAssetID.CAPITAL ), city )
		dur = math.ceil( dur * 0.1 )
		--InputUtil_Pause( "intel to " .. group.name, "need dur=" .. dur )
		Asset_SetListItem( intel, IntelAssetID.SPYS_DURATION, group, dur )
	end )
end

function Intel_Update( intel )	
	local type = Asset_Get( intel, IntelAssetID.TYPE )
	Asset_ForeachList( intel, IntelAssetID.SPYS_DURATION, function( dur, group )
		if dur > 0 then
			dur = dur - g_elapsed
			Asset_SetListItem( intel, IntelAssetID.SPYS_DURATION, group, dur )
			if dur <= 0 then
				--group receive intel				
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