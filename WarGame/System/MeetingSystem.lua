local function Proposal_Execute( proposal )
	local task = Entity_New( EntityType.TASK )

	--convert proposal type into task type
	local typeName = MathUtil_FindName( ProposalType, Asset_Get( proposal, ProposalAssetID.TYPE ) )
	local taskType = TaskType[typeName]	
	Asset_Set( task, TaskAssetID.TYPE, taskType )

	--copy same data
	Asset_Set( task, TaskAssetID.ACTOR, Asset_Get( proposal, ProposalAssetID.ACTOR ) )	
	Asset_Set( task, TaskAssetID.DESTINATION, Asset_Get( proposal, ProposalAssetID.DESTINATION ) )

	Asset_CopyDict( task, TaskAssetID.PARAMS, Asset_Get( proposal, ProposalAssetID.PARAMS ) )

	if taskType == TaskType.PROMOTE_CHARA then
	end

	--issue task include initializing actortype, issue task to every subordinates
	Task_Issue( task )

	--remove proposal
	Entity_Remove( proposal )
end

local function Proposal_Respond( proposal )
	local city = Asset_Get( proposal, ProposalAssetID.DESTINATION )
	if not city then
		InputUtil_Pause( "Invalid proposal location" )
		return
	end
	local superior = Asset_Get( proposal, ProposalAssetID.SUPERIOR )
	local isAccepted = true
	if isAccepted == true then
		Proposal_Execute( proposal )
		--accept or not, NOW WE ALWAYS PERMITTED
		Asset_Set( proposal, ProposalAssetID.STATUS, ProposalStatus.PERMITTED )
		Stat_Add( "Proposal Accept", { type = Asset_Get( proposal, ProposalAssetID.TYPE ) }, StatType.LIST )
		Entity_Remove( proposal )
	else
		Asset_Set( proposal, ProposalAssetID.STATUS, ProposalStatus.REJECTED )
		Stat_Add( "Proposal Rejected", { type = Asset_Get( proposal, ProposalAssetID.TYPE ) }, StatType.LIST )
		Entity_Remove( proposal )
	end
end

---------------------------------------------------

local function Meeting_Update( meeting )
	local topic = Asset_Get( meeting, MeetingAssetID.TOPIC )
	local begTopic, endTopic
	if topic == MeetingTopic.NONE then		
		begTopic = MeetingTopic.CITY_DEVELOPMENT
		endTopic = MeetingTopic.MEETING_END
	else
		begTopic = topic
		endTopic = topic
	end
	topic = begTopic

	while topic < endTopic do	
		--print( "start topic", MathUtil_FindName( MeetingTopic, topic ), topic )

		--clear all proposals
		Entity_Clear( EntityType.PROPOSAL )

		local numofproposer = Random_GetInt_Sync( 1, 2 )

		--submit proposals
		Asset_FindList( meeting, MeetingAssetID.PARTICIPANTS, function ( chara )			
			if Asset_GetListSize( chara, CharaAssetID.TASKS ) > 0 then return end			
			if CharaAI_SubmitMeetingProposal( chara, meeting ) then
				--print( chara.name, "submit")
				numofproposer = numofproposer - 1
			end
			return numofproposer <= 0
		end)

		--update proposals
		local numofproposal = Entity_Number( EntityType.PROPOSAL )		
		if numofproposal > 0 then
			local index =  Random_GetInt_Sync( 1, numofproposal )
			local proposal = Entity_GetIndex( EntityType.PROPOSAL, index )
			--print( "update proposal" .. MathUtil_FindName( ProposalType, Asset_Get( proposal, ProposalAssetID.TYPE ) ) )
			Asset_Set( proposal, ProposalAssetID.SUPERIOR, Asset_Get( meeting, MeetingAssetID.SUPERIOR ) )
			Proposal_Respond( proposal )
		end

		--simply to the next topic
		topic = topic + 1
		Asset_Set( meeting, MeetingAssetID.TOPIC, topic )
	end
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
	local executive = city:GetOfficer( CityOfficer.EXECUTIVE )
	if topic == MeetingTopic.UNDER_HARASS or topic == MeetingTopic.UNDER_ATTACK then
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
			print( "no exec")
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
	Asset_Set( meeting, MeetingAssetID.SUPERIOR, executive )

	--find participants
	local participants = {}
	Asset_ForeachList( city, CityAssetID.CHARA_LIST, function ( chara )
		if Asset_GetListSize( chara, CharaAssetID.TASKS ) > 0 then return end
		if chara:IsAtHome() == false then return end
		table.insert( participants, chara )
	end)
	participants = MathUtil_Shuffle_Sync( participants )
	--InputUtil_Pause( meeting, MeetingAssetID.PARTICIPANTS, #participants )
	Asset_CopyList( meeting, MeetingAssetID.PARTICIPANTS, participants )
end