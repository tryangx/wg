RelationAssetType = 
{
	BASE_ATTRIB      = 1,
}

RelationAssetID = 
{
	--de
	RED_GROUP     = 1,
	BLUE_GROUP    = 2,

	--base attitude
	ATTITUDE      = 10,

	OPINION_LIST  = 11,

	PACT_LIST     = 12,
}

RelationAssetAttrib = 
{
	red          = AssetAttrib_SetPointer( { id = RelationAssetID.RED_GROUP,     type = RelationAssetType.BASE_ATTRIB, setter = Entity_SetGroup } ),
	blue         = AssetAttrib_SetPointer( { id = RelationAssetID.BLUE_GROUP,    type = RelationAssetType.BASE_ATTRIB, setter = Entity_SetGroup } ),
	
	attitude     = AssetAttrib_SetNumber ( { id = RelationAssetID.ATTITUDE,       type = RelationAssetType.BASE_ATTRIB, default = 0 } ),
	
	opinion_list = AssetAttrib_SetList   ( { id = RelationAssetID.OPINION_LIST,   type = RelationAssetType.BASE_ATTRIB } ),
	pact_list    = AssetAttrib_SetList   ( { id = RelationAssetID.PACT_LIST,      type = RelationAssetType.BASE_ATTRIB } ),
}

-------------------------------------------


Relation = class()

function Relation:__init( ... )
	Entity_Init( self, EntityType.RELATION, RelationAssetAttrib )
end

function Relation:Load( data )
end

function Relation:ToString( type )
	local red  = Asset_Get( self, RelationAssetID.RED_GROUP )
	local blue = Asset_Get( self, RelationAssetID.BLUE_GROUP )
	local content = ""
	content = content .. red:ToString()
	content = content .. " & "
	content = content .. blue:ToString()
	content = content .. " at=" .. Asset_Get( self, RelationAssetID.ATTITUDE )
	if type == "ALL" then
	end
	if type == "PACT" or type == "ALL" then
		Asset_ForeachList( self, RelationAssetID.PACT_LIST, function ( time, pact )
			print( time, pact )
			content = content .. " " .. MathUtil_FindName( RelationPact, pact ) .. "+" .. time
		end)
	end
	if type == "OPINION" or type == "ALL" then
		Asset_ForeachList( self, RelationAssetID.OPINION_LIST, function ( at, opinion )
			content = content .. " " .. MathUtil_FindName( RelationOpinion, opinion ) .. "=" .. at
		end)
	end
	return content
end

function Relation:Update()
	local attitude = 0
	Asset_ForeachList( self, RelationAssetID.OPINION_LIST, function ( value, type )
		local opinion = Scenario_GetData( "RELATION_OPINION" )[type]
		if opinion then
			value = MathUtil_Clamp( value + opinion.increment * g_elapsed, opinion.min, opinion.max )		
			attitude = attitude + value
			Asset_SetListItem( self, RelationAssetID.OPINION_LIST, type, attitude )
		end
	end)
	Asset_Set( self, RelationAssetID.ATTITUDE, attitude )
end

function Relation:GetPact( type )
	return Asset_GetListItem( self, RelationAssetID.PACT_LIST, type )
end

function Relation:GetOppGroup( group )
	local red  = Asset_Get( self, RelationAssetID.RED_GROUP )
	local blue = Asset_Get( self, RelationAssetID.BLUE_GROUP )
	local opp = red == group and blue or red
	return opp
end

function Relation:GetOpinion( opinion )
	returnAsset_GetListItem( self, RelationAssetID.OPINION_LIST, opinion )
end

function Relation:HasPact( type )
	local pact = Asset_GetListItem( self, RelationAssetID.PACT_LIST, type )
	if not pact then return false end
	return pact
end

function Relation:HasOpinion( opinion )
	local attitude = Asset_GetListItem( self, RelationAssetID.OPINION_LIST, opinion )
	if not attitude then return false end
	return attitude > 0
end

-------------------------------------------------

function Relation:ImproveRelation( attitude )
	local cur = Asset_Get( self, RelationAssetID.ATTITUDE )
	cur = cur + attitude	
	Asset_Set( self, RelationAssetID.ATTITUDE, cur )

	--InputUtil_Pause( "imporve re", cur .. "+" .. attitude )
end

function Relation:DeclareWar()
	Asset_SetListItem( self, RelationAssetID.PACT_LIST, RelationPact.AT_WAR, 1 )
	InputUtil_Pause( "DeclareWars" )
end

function Relation:SignPact( pact, time )
	Asset_SetListItem( self, RelationAssetID.PACT_LIST, pact, time )
	InputUtil_Pause( "sign pact" )
end