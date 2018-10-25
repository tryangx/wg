ProposalAssetType = 
{
	BASE_ATTRIB = 1,
}

ProposalAssetID = 
{
	TYPE        = 10,
	--who submit the proposal	
	PROPOSER    = 11,	
	--who will execute the task by proposal
	ACTOR       = 12,	
	--where submit the proposal	
	LOCATION    = 14,
	--where to execute the task
	DESTINATION = 15,
	--reserved
	PARAMS      = 16,
	--reserved, proposal 
	STATUS      = 21,
	--reserved, time when submit the proposal
	TIME        = 22,
}

ProposalAssetAttrib = 
{
	type      = AssetAttrib_SetNumber   ( { id = ProposalAssetID.TYPE,       type = ProposalAssetType.BASE_ATTRIB, enum = ProposalType } ),
	proposer  = AssetAttrib_SetPointer  ( { id = ProposalAssetID.PROPOSER,   type = ProposalAssetType.BASE_ATTRIB, setter = Entity_SetChara } ),
	actor     = AssetAttrib_SetPointer  ( { id = ProposalAssetID.ACTOR,      type = ProposalAssetType.BASE_ATTRIB } ),
	location  = AssetAttrib_SetPointer  ( { id = ProposalAssetID.LOCATION,   type = ProposalAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	destination = AssetAttrib_SetPointer( { id = ProposalAssetID.DESTINATION,type = ProposalAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	params    = AssetAttrib_SetDict     ( { id = ProposalAssetID.PARAMS,     type = ProposalAssetType.BASE_ATTRIB } ),
	
	status    = AssetAttrib_SetNumber   ( { id = ProposalAssetID.STATUS,     type = ProposalAssetType.BASE_ATTRIB, default = ProposalStatus.SUBMITTED } ),
	time      = AssetAttrib_SetNumber   ( { id = ProposalAssetID.TIME,       type = ProposalAssetType.BASE_ATTRIB } ),
}

-------------------------------------------

Proposal = class()

function Proposal:__init( ... )
	Entity_Init( self, EntityType.PROPOSAL, ProposalAssetAttrib )
end

function Proposal:Load( data )

end

function Proposal:ToString()
	local type = Asset_Get( self, ProposalAssetID.TYPE )
	local content = ""
	content = content .. " " .. MathUtil_FindName( ProposalType, type )
	content = content .. " psr=[" .. String_ToStr( Asset_Get( self, ProposalAssetID.PROPOSER ), "name" ) .. "]"
	content = content .. " atr=[" .. String_ToStr( Asset_Get( self, ProposalAssetID.ACTOR ), "name" ) .. "]"
	content = content .. " loc=" .. String_ToStr( Asset_Get( self, ProposalAssetID.LOCATION ), "name" )
	content = content .. " dst=" .. String_ToStr( Asset_Get( self, ProposalAssetID.DESTINATION ), "name" )
	content = content .. " t=" .. g_Time:CreateDateDescByValue( Asset_Get( self, ProposalAssetID.TIME ) )
	if type == ProposalType.HARASS_CITY or type == ProposalType.ATTACK_CITY then
	end
	return content
end