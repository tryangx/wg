ProposalAssetType = 
{
	BASE_ATTRIB = 1,
}

ProposalAssetID = 
{
	TYPE     = 10,
	PROPOSER = 11,
	ACTOR    = 12,
	TARGET   = 13,
	PARAMS   = 14,
	LOCATION = 20,
	STATUS   = 21,
	TIME     = 22,
}

ProposalAssetAttrib = 
{
	type      = AssetAttrib_SetNumber ( { id = ProposalAssetID.TYPE,       type = ProposalAssetType.BASE_ATTRIB, enum = ProposalType } ),
	proposer  = AssetAttrib_SetPointer( { id = ProposalAssetID.PROPOSER,   type = ProposalAssetType.BASE_ATTRIB, setter = Entity_SetChara } ),
	actor     = AssetAttrib_SetPointer( { id = ProposalAssetID.ACTOR,      type = ProposalAssetType.BASE_ATTRIB } ),
	target    = AssetAttrib_SetPointer( { id = ProposalAssetID.TARGET,     type = ProposalAssetType.BASE_ATTRIB } ),
	params    = AssetAttrib_SetList   ( { id = ProposalAssetID.PARAMS,     type = ProposalAssetType.BASE_ATTRIB } ),
	location  = AssetAttrib_SetPointer( { id = ProposalAssetID.LOCATION,   type = ProposalAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
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
	if type == ProposalType.ISSUE_POLICY then
		content = content .. " ply=" .. MathUtil_FindName( CityPolicy, Asset_Get( self, ProposalAssetID.PARAMS, IssuePolicyParams.CITY_POLICY ) )
	end
	return content
end