local function Proposal_Execute( proposal )
	--issue task include initializing actortype, issue task to every subordinates
	Task_IssueByProposal( proposal )

	--remove proposal
	Entity_Remove( proposal )
end

local function Proposal_Respond( proposal )
	local city = Asset_Get( proposal, ProposalAssetID.DESTINATION )
	if not city then
		--InputUtil_Pause( "Invalid proposal location" )
		print( proposal:ToString() )
		k.p = 1
		return
	end
	local isAccepted = true
	if isAccepted == true then
		Proposal_Execute( proposal )
		--accept or not, NOW WE ALWAYS PERMITTED
		Asset_Set( proposal, ProposalAssetID.STATUS, ProposalStatus.PERMITTED )
		--Stat_Add( "Proposal@Accepted", MathUtil_FindName( ProposalType, Asset_Get( proposal, ProposalAssetID.TYPE ) ), StatType.LIST )
		Entity_Remove( proposal )
	else
		Asset_Set( proposal, ProposalAssetID.STATUS, ProposalStatus.REJECTED )
		--Stat_Add( "Proposal@Rejected", MathUtil_FindName( ProposalType, Asset_Get( proposal, ProposalAssetID.TYPE ) ), StatType.LIST )
		Entity_Remove( proposal )
	end
end

---------------------------------------------------

local function Meeting_Update( meeting )
	--determine topic	
	local topic = Asset_Get( meeting, MeetingAssetID.TOPIC )
	local begTopic, endTopic
	if topic == MeetingTopic.NONE then		
		begTopic = MeetingTopic.MEETING_LOOP
		endTopic = MeetingTopic.MEETING_END
		topic = begTopic		
	else
		--has special topic
		begTopic = topic
		endTopic = topic + 1

		Stat_Add( "Meeting@Special_Times", nil, StatType.TIMES )
	end

	local city = Asset_Get( meeting, MeetingAssetID.LOCATION )
	local superior = Asset_Get( meeting, MeetingAssetID.SUPERIOR )

	while topic < endTopic do
		--print( "cur_topic=", MathUtil_FindName( MeetingTopic, topic ) )
		Asset_Set( meeting, MeetingAssetID.TOPIC, topic )

		--clear all proposals
		Entity_Clear( EntityType.PROPOSAL )

		--number of allow proposer
		local numofproposer  = Random_GetInt_Sync( 1, 2 )
		local submitProposal = 0

		--submit proposals
		local freeParticiants = 0
		Asset_FindListItem( meeting, MeetingAssetID.PARTICIPANTS, function ( chara )			
			if chara:IsBusy() then return end
			freeParticiants = freeParticiants + 1
			Stat_Add( "Proposal@Try_Times", nil, StatType.TIMES )
			--if topic == MeetingTopic.COMMANDER then InputUtil_Pause( "commander") end
			if CharaAI_SubmitMeetingProposal( chara, meeting ) then
				numofproposer  = numofproposer - 1
				submitProposal = submitProposal + 1
			end
			return numofproposer <= 0
		end )
		
		if freeParticiants == 0 or submitProposal == 0 then
			--InputUtil_Pause( freeParticiants, submitProposal, MathUtil_FindName( MeetingTopic, topic ) )
			--let superior submit proposal
			if superior:IsBusy() == false then
				CharaAI_SubmitMeetingProposal( superior, meeting )
			end
			--Stat_Add( "Meeting@Cancel_Times", nil, StatType.TIMES )
			--print( "end meeting" )
		end

		--update proposals
		local numofproposal = Entity_Number( EntityType.PROPOSAL )		
		if numofproposal > 0 then
			local index =  Random_GetInt_Sync( 1, numofproposal )
			local proposal = Entity_GetIndex( EntityType.PROPOSAL, index )
			--print( "update proposal" .. MathUtil_FindName( ProposalType, Asset_Get( proposal, ProposalAssetID.TYPE ) ) )
			Proposal_Respond( proposal )
		end

		if topic <= MeetingTopic.MEETING_LOOP then
		--	InputUtil_Pause( city.name, "start topic=" .. MathUtil_FindName( MeetingTopic, topic ), topic )
		end

		--simply to the next topic
		topic = topic + 1
	end
	--Stat_Add( "Meeting@End_Times", nil, StatType.TIMES )
end

function Meeting_Hold( city, topic, target )
	if Asset_GetListItem( city, CityAssetID.STATUSES, CityStatus.IN_SIEGE ) == true then
		Debug_Log( city.name, "in siege, cann't hold meeting" )
		return
	end

	if not topic then topic = MeetingTopic.NONE end
	local executive = city:GetOfficer( CityJob.CHIEF_EXECUTIVE )
	if topic == MeetingTopic.UNDER_HARASS or topic == MeetingTopic.UNDER_ATTACK then		
		--Debug_Log( "gain intel need to intercept" .. target:ToString() )
		--find highest rank		
		local highestRank = CharaJob.NONE
		city:FilterOfficer( function ( chara )
			if chara:IsAtHome() == false then return end
			local rank = Asset_Get( chara, CharaAssetID.JOB )
			if rank > highestRank then
				executive = chara
				highestRank = rank
			end
		end)
		if not executive then
			Stat_Add( "Meeting@Pass", 1, StatType.TIMES )
			return
		end
	else
		if not executive then
			--no executive, cann't hold on any meeting
			Stat_Add( "Meeting@Pass", 1, StatType.TIMES )
			return
		end
	end

	local meeting = Entity_New( EntityType.MEETING )
	Asset_Set( meeting, MeetingAssetID.LOCATION, city )
	Asset_Set( meeting, MeetingAssetID.TOPIC, topic )
	Asset_Set( meeting, MeetingAssetID.SUPERIOR, executive )
	Asset_Set( meeting, MeetingAssetID.TARGET, target )

	--find participants
	local participants = {}
	Asset_ForeachList( city, CityAssetID.CHARA_LIST, function ( chara )
		if chara:IsBusy() == true then
			--print( chara.name, " is busy" )
			return
		end
		if chara:IsAtHome() == false then
			--print( chara.name, " isn't at home" )
			return
		end
		if chara == executive then return end
		table.insert( participants, chara )
	end )
	participants = MathUtil_Shuffle_Sync( participants )
	--InputUtil_Pause( meeting, MeetingAssetID.PARTICIPANTS, #participants )
	Asset_CopyList( meeting, MeetingAssetID.PARTICIPANTS, participants )

	--print( "hold meeting in=" .. city.name, "chara=" .. Asset_GetListSize( city, CityAssetID.CHARA_LIST ), #participants )

	Stat_Add( "Meeting@HoldTimes", 1, StatType.TIMES )
	Stat_Add( "Meeting@CityHold_" .. city.name, 1, StatType.TIMES )
end

--------------------------------------

local function Meeting_CityHold( msg )
	local city   = Asset_GetListItem( msg, MessageAssetID.PARAMS, "city" )
	local topic  = Asset_GetListItem( msg, MessageAssetID.PARAMS, "topic" )
	local target = Asset_GetListItem( msg, MessageAssetID.PARAMS, "target" )
	Meeting_Hold( city, topic, target )
end

---------------------------------------------------

MeetingSystem = class()

function MeetingSystem:__init()
	System_Setup( self, SystemType.MEETING_SYS )
end

function MeetingSystem:Start()
	Message_Handle( self.type, MessageType.CITY_HOLD_MEETING, Meeting_CityHold )	
end

function MeetingSystem:Update()
	Entity_Foreach( EntityType.MEETING, Meeting_Update )
	Entity_Clear( EntityType.MEETING )
end