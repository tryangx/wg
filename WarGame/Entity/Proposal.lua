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
	DESTINATION = 13,
	--reserved
	PARAMS      = 14,
	--superior
	SUPERIOR    = 15,

	STATUS      = 21,
	TIME        = 22,
}

ProposalAssetAttrib = 
{
	type      = AssetAttrib_SetNumber ( { id = ProposalAssetID.TYPE,       type = ProposalAssetType.BASE_ATTRIB, enum = ProposalType } ),
	proposer  = AssetAttrib_SetPointer( { id = ProposalAssetID.PROPOSER,   type = ProposalAssetType.BASE_ATTRIB, setter = Entity_SetChara } ),
	actor     = AssetAttrib_SetPointer( { id = ProposalAssetID.ACTOR,      type = ProposalAssetType.BASE_ATTRIB } ),
	superior  = AssetAttrib_SetPointer( { id = ProposalAssetID.SUPERIOR,   type = ProposalAssetType.BASE_ATTRIB, setter = Entity_SetChara } ),
	params    = AssetAttrib_SetList   ( { id = ProposalAssetID.PARAMS,     type = ProposalAssetType.BASE_ATTRIB } ),
	destination = AssetAttrib_SetPointer( { id = ProposalAssetID.DESTINATION,type = ProposalAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	status    = AssetAttrib_SetNumber ( { id = ProposalAssetID.STATUS,     type = ProposalAssetType.BASE_ATTRIB, default = ProposalStatus.SUBMITTED } ),
	time      = AssetAttrib_SetNumber ( { id = ProposalAssetID.TIME,       type = ProposalAssetType.BASE_ATTRIB } ),
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
	content = content .. " type=" .. MathUtil_FindName( ProposalType, type )
	content = content .. " pser=" .. String_ToStr( Asset_Get( self, ProposalAssetID.PROPOSER ), "name" )
	content = content .. " actr=" .. String_ToStr( Asset_Get( self, ProposalAssetID.ACTOR ), "name" )
	content = content .. " loc=" .. String_ToStr( Asset_Get( self, ProposalAssetID.DESTINATION ), "name" )
	if type == ProposalType.ISSUE_POLICY then
		content = content .. " ply=" .. MathUtil_FindName( CityPolicy, Asset_Get( self, ProposalAssetID.PARAMS, "CITY_POLICY" ) )
	elseif type == ProposalType.HARASS_CITY or type == ProposalType.ATTACK_CITY then

	end
	return content
end