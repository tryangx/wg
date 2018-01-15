---------------------------------------------------

local Meeting_Update( meeting )
	Asset_ForeachList( meeting, MeetingAssetID.PARTICIPANTS, function ( chara )
		CharaAI_SubmitMeetingProposal( chara )
	end)
end

---------------------------------------------------

MeetingSystem = class()

function MeetingSystem:__init()
	System_Setup( self, SystemType.MEETING_SYS )
end

function MeetingSystem:Start()

end

function MeetingSystem:Update()
	Entity_Foreach( EntityType.MEETING, Meeting_Update )
end

--@param type MeetingTopic
function MeetingSystem:HoldMeeting( city, topic )
	local executive = Asset_GetListItem( Asset_Get( chara, CharaAssetID.LOCATION ), CityAssetID.OFFICER_LIST, CityOfficer.EXECUTIVE )

	if topic == MeetingTopic.UNDER_ATTACK then
		--find highest rank
		local highestRank = CharaJob.NONE
		city:FilterOfficer( function ( chara )
			if chara:IsAtHome() then
				local rank = Asset_Get( chara, CharaAssetID.JOB )
				if rank > highestRank then
					executive = chara
					highestRank = rank
				end
			end
		end)
		if not executive then
			return
		end
	else
		if not executive then
			--no executive, cann't hold on any meeting
			return
		end
	end

	local meeting = Entity_New( EntityType.MEETING )
	Asset_Set( meeting, MeetingAssetID.LOCATION, city )
	Asset_Set( meeting, MeetingAssetID.TOPIC, topic )

	--find participants
	local participants = {}
	Asset_ForeachList( city, CityAssetID.CHARA_LIST, function ( chara )
		if chara:IsAtHome() == true then
			table.insert( participants, chara )
		end
	end)

	Asset_CopyList( meeting, MeetingAssetID.participants, participants )	
end