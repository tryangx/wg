IntelEventType = 
{
	HARASS_CITY   = 10,
	ATTACK_CITY   = 11,
}


---------------------------------------

IntelSystem = class()

function IntelSystem:__init()
	System_Setup( self, SystemType.INTEL_SYS )
end

function IntelSystem:Start()
end

function IntelSystem:Update()
	
end

function IntelSystem:Broadcast( type, params )
	if type == IntelEventType.HARASS_CITY then
		System_Get( SystemType.MEETING_SYS ):HoldMeeting( params.city, MeetingTopic.UNDER_HARASS )
	elseif type == IntelEventType.ATTACK_CITY then
		System_Get( SystemType.MEETING_SYS ):HoldMeeting( params.city, MeetingTopic.UNDER_ATTACK )
	end
end