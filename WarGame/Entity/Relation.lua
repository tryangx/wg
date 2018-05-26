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
	content = content .. " att=" .. Asset_Get( self, RelationAssetID.ATTITUDE )
	if type == "PACT" or type == "ALL" then
		Asset_Foreach( self, RelationAssetID.PACT_LIST, function ( data, pact )
			content = content .. " " .. MathUtil_FindName( RelationPact, pact ) .. "+" .. ( data.time and data.item or "?" )
		end)
	end
	if type == "OPINION" or type == "ALL" then
		Asset_Foreach( self, RelationAssetID.OPINION_LIST, function ( data, opinion )
			content = content .. " " .. MathUtil_FindName( RelationOpinion, opinion ) .. "=" .. data.attitude
		end)
	end
	return content
end

function Relation:Update()
	local attitude = 0

	--update opinion
	--  1.increase duration
	--  2.alter attitude
	Asset_Foreach( self, RelationAssetID.OPINION_LIST, function ( data, type )
		data.duration = data.duration + 1
		if data.time > 1 then
			data.time = data.time - 1		
			local opinion = Scenario_GetData( "RELATION_OPINION" )[type]
			if opinion then			
				data.attitude = MathUtil_Clamp( data.attitude + opinion.increment * g_elapsed, opinion.min, opinion.max )
				attitude = attitude + data.attitude
			end
		elseif data.time == 0 then
			InputUtil_Pause( "op over", MathUtil_FindName( RelationOpinion, type ) )
			Asset_SetListItem( self, RelationAssetID.OPINION_LIST, type, nil )
		end
	end)
	Asset_Set( self, RelationAssetID.ATTITUDE, attitude )

	--update pact
	Asset_Foreach( self, RelationAssetID.PACT_LIST, function ( data, pact )
		data.remain = data.remain - g_elapsed
		if data.remain < 0 then			
			--InputUtil_Pause( "pact over", MathUtil_FindName( RelationPact, pact ) )
			Asset_SetListItem( self, RelationAssetID.PACT_LIST, pact, nil )			
		end
	end)
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

function Relation:GetOpinion( type )
	return Asset_GetListItem( self, RelationAssetID.OPINION_LIST, type )
end

function Relation:HasPact( type )
	local pact = Asset_GetListItem( self, RelationAssetID.PACT_LIST, type )
	if not pact then return false end
	if pact.remain and pact.remain > 0 then return true end
	return false
end

function Relation:HasOpinion( type )
	local opinion = Asset_GetListItem( self, RelationAssetID.OPINION_LIST, type )
	if not opinion then return false end
	return opinion ~= 0
end

-------------------------------------------------

function Relation:RemoveOpinion( type )
	Asset_SetListItem( self, RelationAssetID.OPINION_LIST, type, nil )
end

function Relation:ImproveRelation( attitude )
	local cur = Asset_Get( self, RelationAssetID.ATTITUDE )
	cur = cur + attitude	
	Asset_Set( self, RelationAssetID.ATTITUDE, cur )

	--InputUtil_Pause( "imporve re", cur .. "+" .. attitude )
end

function Relation:AddOpinion( type )
	local opinion = {}
	local data = Scenario_GetData( "RELATION_OPINION" )[type]
	opinion.attitude = data.def
	opinion.time     = data.time
	opinion.duration = 1
	Asset_SetListItem( self, RelationAssetID.OPINION_LIST, type, opinion )
end

function Relation:DeclareWar()
	self:AddOpinion( RelationOpinion.AT_WAR )
end

function Relation:SignPact( pact, time )
	Asset_SetListItem( self, RelationAssetID.PACT_LIST, pact, { remain = time } )

	--special process
	if pact == RelationPact.PEACE then
		self:RemoveOpinion( RelationOpinion.AT_WAR )
		self:AddOpinion( RelationOpinion.WAS_AT_WAR )
		--InputUtil_Pause( "peace", self:ToString( "ALL" ) )
	end	
	--InputUtil_Pause( "sign pact", MathUtil_FindName( RelationPact, pact ), time )
end