--
--
-- Proposal Procedure
--   SUBMITTED --> WAIT_RESPOND --> PERMITTED --> REJECTED
--	
--

IssuePolicyParams = 
{
	CITY_POLICY = 1,
}

local function Proposal_Execute( proposal )
	local task = Entity_New( EntityType.TASK )
	local typeName = MathUtil_FindName( ProposalType, Asset_Get( proposal, ProposalAssetID.TYPE ) )
	local taskType = TaskType[typeName]
	Asset_Set( task, TaskAssetID.TYPE, taskType )
	Asset_Set( task, TaskAssetID.ACTOR, proposal.actor )
	Asset_Set( task, TaskAssetID.TARGET, Asset_Get( proposal, ProposalAssetID.TYPE ) )
	Asset_Set( task, TaskAssetID.LOCATION, Asset_Get( proposal, ProposalAssetID.LOCATION ) )
	Task_InitActorType( task )

	Entity_Remove( proposal )
end

local function Proposal_Respond( proposal )
	local city = Asset_Get( proposal, ProposalAssetID.LOCATION )
	if not city then
		InputUtil_Pause( "Invalid proposal location" )
		return
	end
	local executive = Asset_GetListItem( city, CityAssetID.OFFICER_LIST, CityOfficer.EXECUTIVE )
	if not executive then
		DBG_Watch( "proposal_trace", "city=" .. city.name .. " no executive, proposal no respond", DBGLevel.FATAL )
		return
	end
	local loc = Asset_Get( executive, CharaAssetID.LOCATION )
	if loc ~= city then
		DBG_Watch( "proposal_trace", "executive=" .. executive.name .. " isn't at home=" .. loc.name .. "/" .. city.name, DBGLevel.FATAL )
		return
	end
	--accept or not, NOW WE ALWAYS PERMITTED
	Asset_Set( proposal, ProposalAssetID.STATUS, ProposalStatus.PERMITTED )
end

local function Proposal_Rejected( proposal )
	Stat_Add( "Proposal Rejected", { type = Asset_Get( proposal, ProposalAssetID.TYPE ) }, StatType.LIST )
	Entity_Remove( proposal )
end

local function Proposal_Update( proposal )
	local status = Asset_Get( proposal, ProposalAssetID.STATUS )
	DBG_Watch( "proposal_trace", "update proposal" .. MathUtil_FindName( ProposalType, Asset_Get( proposal, ProposalAssetID.TYPE ) ) .. " status=" .. MathUtil_FindName( ProposalStatus, status ) )

	if status == ProposalStatus.SUBMITTED then
		Asset_Set( proposal, ProposalAssetID.STATUS, ProposalStatus.WAIT_RESPOND )	
	elseif status == ProposalStatus.WAIT_RESPOND then
		Proposal_Respond( proposal )	
	elseif status == ProposalStatus.PERMITTED then
		Proposal_Execute( proposal )
	elseif status == ProposalStatus.REJECTED then
		Proposal_Rejected( proposal )
	end
end

--------------------------------

ProposalSystem = class()

function ProposalSystem:__init()
	System_Setup( self, SystemType.PROPOSAL_SYS )
end

function ProposalSystem:Start()
	self._tasks = {}

	DBG_SetWatcher( "proposal_trace", DBGLevel.IMPORTANT )
end

function ProposalSystem:Update()
	--InputUtil_Pause( "update pro sys" )
	Entity_Foreach( EntityType.PROPOSAL, Proposal_Update )
end