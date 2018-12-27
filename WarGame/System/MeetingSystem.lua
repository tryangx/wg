local function Proposal_Execute( proposal )
	--some proposal will execute immediately, no need to issue a task
	local type = Asset_Get( proposal, ProposalAssetID.TYPE )

	if type == ProposalType.SET_GOAL then
		local loc   = Asset_Get( proposal, ProposalAssetID.LOCATION )
		local group = Asset_Get( loc, CityAssetID.GROUP )
		local goalType = Asset_GetDictItem( proposal, ProposalAssetID.PARAMS, "goalType" )
		local goalData = Asset_GetDictItem( proposal, ProposalAssetID.PARAMS, "goalData" )
		--print( "goal", MathUtil_FindName( GroupGoalType, goalType ), goalType )
		group:AddGoal( goalType, goalData )

	elseif type == ProposalType.MOVE_CAPITAL then
		local actor = Asset_Get( proposal, ProposalAssetID.ACTOR )
		local group = Asset_Get( actor, CharaAssetID.GROUP )
		group:MoveCapital( Asset_Get( proposal, ProposalAssetID.LOCATION ) )

	elseif type == ProposalType.IMPROVE_GRADE then
		local actor = Asset_Get( proposal, ProposalAssetID.ACTOR )
		local group = Asset_Get( actor, CharaAssetID.GROUP )
		group:ImproveGrade( Asset_GetDictItem( proposal, ProposalAssetID.PARAMS, "grade" ) )

	elseif type == ProposalType.INSTRUCT_CITY then
		local list = Asset_GetDictItem( proposal, ProposalAssetID.PARAMS, "instructCityList" )
		for _, item in ipairs( list ) do
			City_Instruct( item.city, item.type )
		end

	elseif type == ProposalType.CALL_CHARA then
		local actor = Asset_Get( proposal, ProposalAssetID.ACTOR )		
		local dest  = Asset_Get( proposal, ProposalAssetID.LOCATION )
		local loc   = Asset_Get( actor, CharaAssetID.LOCATION )
		local group = Asset_Get( actor, CharaAssetID.GROUP )
		local dur   = Move_CalcIntelTransDuration( group, loc, dest )
		Cmd_MoveToCity( actor, dest, { dur = dur } )
		--print( "add cmd", actor:ToString(), loc:ToString(), dest:ToString() )

	else
		--print( "issue", proposal:ToString() )

		--issue task include initializing actortype, issue task to every subordinates
		local task = Task_IssueByProposal( proposal )
		--Log_Write( "meeting", "			issue proposal=" .. proposal:ToString() )
		if task then
			Log_Write( "meeting", "  task=" .. task:ToString() )
		end
	end

	--remove proposal
	Entity_Remove( proposal )
end

local function Proposal_Respond( proposal )
	local city = Asset_Get( proposal, ProposalAssetID.DESTINATION )
	if not city then
		--InputUtil_Pause( "Invalid proposal location" )
		error( proposal:ToString() )
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

local function CheckTopicWithChara( city, chara, topic )	
	if topic == MeetingTopic.UNDER_HARASS or topic == MeetingTopic.UNDER_ATTACK then
		return true
	end
	local job = city:GetCharaJob( chara )	
	if job == CityJob.EXECUTIVE then
		return true
	end
	if job == CityJob.COMMANDER then
		if topic == MeetingTopic.COMMANDER or topic == MeetingTopic.STRATEGY then
			return true
		end
	end
	if job == CityJob.STAFF then
		if topic == MeetingTopic.STAFF then
			return true
		end
	end
	if job == CityJob.HR then
		if topic == MeetingTopic.HR then
			return true
		end
	end
	if job == CityJob.OFFICIAL then
		if topic == MeetingTopic.OFFICIAL then
			return true
		end
	end
	if job == CityJob.DIPLOMATIC then
		if topic == MeetingTopic.DIPLOMATIC then
			return true
		end
	end
	if job == CityJob.TECHNICIAN then
		if topic == MeetingTopic.TECHNICIAN then
			return true
		end
	end
	return false
end

local function Meeting_Update( meeting )
	--Log_Write( "meeting", g_Time:ToString() .. " hold" .. meeting:ToString() )	
	local city = Asset_Get( meeting, MeetingAssetID.LOCATION )
	local topic = Asset_Get( meeting, MeetingAssetID.TOPIC )
	local begTopic, endTopic
	if topic == MeetingTopic.NONE then		
		begTopic = MeetingTopic.MEETING_LOOP
		endTopic = MeetingTopic.MEETING_END
		topic = begTopic
		if city:IsCapital() then
			begTopic = begTopic + 1
		end
	else
		--has special topic
		begTopic = topic
		endTopic = topic + 1

		Stat_Add( "Meeting@Special_Times", nil, StatType.TIMES )
	end

	local superior = Asset_Get( meeting, MeetingAssetID.SUPERIOR )
	local totalSubmit = 0
	while topic < endTopic do
		--print( "cur_topic=", MathUtil_FindName( MeetingTopic, topic ) )
		--Log_Write( "meeting", "  topic=" .. MathUtil_FindName( MeetingTopic, topic ) )
		Asset_Set( meeting, MeetingAssetID.TOPIC, topic )

		--clear all proposals
		Entity_Clear( EntityType.PROPOSAL )

		--number of allow proposer
		local numofproposer  = Random_GetInt_Sync( 2, 4 )
		local submitProposal = 0

		--submit proposals
		local freeParticiants = 0
		Asset_FindItem( meeting, MeetingAssetID.PARTICIPANTS, function ( chara )
			if not CheckTopicWithChara( city, chara, topic ) then
				return
			end
			if chara:IsBusy() then
				--Log_Write( "meeting", "  chara=" .. chara:ToString() .. " busy=" .. chara:GetTask():ToString() )
				return
			end			
			freeParticiants = freeParticiants + 1
			Stat_Add( "Proposal@Try_Times", nil, StatType.TIMES )
			--if topic == MeetingTopic.COMMANDER then InputUtil_Pause( "commander") end			
			if CharaAI_SubmitMeetingProposal( chara, meeting ) then
				numofproposer  = numofproposer - 1
				submitProposal = submitProposal + 1
				totalSubmit    = totalSubmit + 1
			else
				--Log_Write( "meeting", "  topic=" .. MathUtil_FindName( MeetingTopic, topic ) .. " chara=" .. chara:ToString() .. " passed" )
			end
			return numofproposer <= 0
		end )
		
		--print( "free=" .. freeParticiants, "submit=" .. submitProposal )
		if freeParticiants == 0 or submitProposal == 0 then
			--InputUtil_Pause( "executive submit proposal", MathUtil_FindName( MeetingTopic, topic ) )
			--let superior submit proposal
			if superior:IsBusy() == false then				
				if CharaAI_SubmitMeetingProposal( superior, meeting ) then
					totalSubmit    = totalSubmit + 1
				else
					--Log_Write( "meeting", "  topic=" .. MathUtil_FindName( MeetingTopic, topic ) .. " superior=" .. superior:ToString() .. " passed" )
				end
			else
				--Log_Write( "meeting", "  topic=" .. MathUtil_FindName( MeetingTopic, topic ) .. " superior=" .. superior:ToString() .. " busy=" .. superior:GetTask():ToString() )
			end
			--Stat_Add( "Meeting@Cancel_Times", nil, StatType.TIMES )
			--print( "end meeting" )
		end

		--update proposals
		local numofproposal = Entity_Number( EntityType.PROPOSAL )		
		if numofproposal > 0 then			
			local index =  Random_GetInt_Sync( 1, numofproposal )
			local proposal = Entity_GetByIndex( EntityType.PROPOSAL, index )
			if numofproposal > 1 then
				--Entity_Foreach( EntityType.PROPOSAL, function(proposal) print( proposal:ToString() ) end )
				--InputUtil_Pause( "choose proposal=" .. index, numofproposal )
			end
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

	if totalSubmit == 0 then Stat_Add( "Meeting@Waste", g_Time:ToString() .. " " .. city.name .. " n=" .. Asset_GetListSize( meeting, MeetingAssetID.PARTICIPANTS ), StatType.LSIT ) end

	local content = g_Time:ToString() .. " " .. city.name .. " sp=" .. String_ToStr( superior, "name" ) .. " meeting over, n=" .. Asset_GetListSize( meeting, MeetingAssetID.PARTICIPANTS ) .. " num_p=" .. totalSubmit

	content = content .. " charas="
	Asset_Foreach( city, CityAssetID.OFFICER_LIST, function ( data )
		content = content .. MathUtil_FindName( CityJob, data.job ) .. "=" .. data.officer.name .. ","
	end)
	Log_Write( "meeting", content )
	Log_Write( "meeting", "--------------------------------------------------------" )

	DBG_Watch( "Debug_Meeting", content )
end

function Meeting_Hold( city, topic, target )
	if Asset_GetDictItem( city, CityAssetID.STATUSES, CityStatus.IN_SIEGE ) == true then
		--Debug_Log( city.name, "in siege, cann't hold meeting" )
		Stat_Add( "Meeting@Siege", 1, StatType.TIMES )
		return
	end

	if not topic then
		topic = MeetingTopic.NONE
	end
	local executive = city:GetOfficer( CityJob.EXECUTIVE )
	Debug_Log( city.name, MathUtil_FindName( MeetingTopic, topic ), topic, "ex=" .. String_ToStr( executive, "name" ) )	
	if topic == MeetingTopic.UNDER_HARASS or topic == MeetingTopic.UNDER_ATTACK then		
		--Debug_Log( "gain intel need to intercept" .. target:ToString() )
		--find highest rank		
		local highestTitle = CharaTitle.NONE
		city:FilterOfficer( function ( chara, job )
			if chara:IsAtHome() == false then return end
			local title = Asset_Get( chara, CharaAssetID.TITLE )
			if title > highestTitle then
				executive = chara
				highestTitle = title
			end
		end )
	end	
	if not executive then			
		--Stat_Add( "Meeting@Pass", g_Time:ToString() .. " " .. city:ToString( "CHARA" ), StatType.LIST )
		return
	end
	if not executive:IsAtHome() then
		Debug_Log( "meeting failed", executive.name .. " not at home", executive:ToString( "LOCATION") )
		return
	end

	local meeting = Entity_New( EntityType.MEETING )
	Asset_Set( meeting, MeetingAssetID.LOCATION, city )
	Asset_Set( meeting, MeetingAssetID.TOPIC, topic )
	Asset_Set( meeting, MeetingAssetID.SUPERIOR, executive )
	Asset_Set( meeting, MeetingAssetID.TARGET, target )

	Debug_Log( city.name, executive:ToString(), "enter meeting, executive" )

	--find participants
	local participants = {}
	--Asset_Foreach( city, CityAssetID.CHARA_LIST, function ( chara )
	Asset_Foreach( city, CityAssetID.OFFICER_LIST, function ( data )
		local chara = data.officer
		if chara:IsBusy() == true then
			Log_Write( "meeting", city.name .. "-->" .. chara:ToString() .. " is busy=" .. chara:GetTask():ToString() )
			return
		end
		if chara:IsAtHome() == false then
			--Debug_Log( chara.name, " isn't at home" )
			Log_Write( "meeting", city.name .. "-->" .. chara:ToString() .. " not at home" )
			return
		end
		if chara == executive then
			Log_Write( "meeting", city.name .. "-->" .. chara:ToString() .. " is executive" )
			return
		end
		table.insert( participants, chara )
		Debug_Log( chara:ToString(), "enter meeting" )
		--Log_Write( "meeting", "       " .. chara:ToString() .. "=" .. MathUtil_FindName( CityJob, city:GetCharaJob( chara ) ) .. " attend" )
	end )
	participants = MathUtil_Shuffle_Sync( participants )
	Asset_CopyList( meeting, MeetingAssetID.PARTICIPANTS, participants )

	--Log_Write( "meeting", "prepare=" .. city.name .. " chara=" .. Asset_GetListSize( city, CityAssetID.CHARA_LIST ) .. " parti=" .. Asset_GetListSize( meeting, MeetingAssetID.PARTICIPANTS ) )

	Stat_Add( "Meeting@HoldTimes", 1, StatType.TIMES )
	Stat_Add( "Meeting@CityHold_" .. city.name, 1, StatType.TIMES )
	
	--print( city:ToString( "OFFICER" ) )
	--local group = Asset_Get( city, CityAssetID.GROUP )	
	--Log_Write( "meeting", g_Time:ToString() .. " " .. city.name .. " hold meeting t=" .. MathUtil_FindName( MeetingTopic, topic ) .. " p=" .. #participants .. ( group and " g=" .. group:ToString( "GOAL" ) or "" ) )
	Log_Write( "meeting", "--------------------------------------------------------" )
end

--------------------------------------

local function Meeting_CityHold( msg )
	local city   = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "city" )
	local topic  = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "topic" )
	local target = Asset_GetDictItem( msg, MessageAssetID.PARAMS, "target" )
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
	local month = g_Time:GetMonth()
	local day   = g_Time:GetDay()
	Entity_Foreach( EntityType.CITY, function ( city )
		if month == 1 and day == 1 and city:IsCapital() then
			Meeting_Hold( city, MeetingTopic.DETERMINE_GOAL )
		end

		if day == 2 then
			Meeting_Hold( city )
		end
	end)	
	Entity_Foreach( EntityType.MEETING, Meeting_Update )
	Entity_Clear( EntityType.MEETING )
end