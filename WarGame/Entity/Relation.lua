RelationAssetType = 
{
	BASE_ATTRIB      = 1,
}

RelationAssetID = 
{
	--de
	RED_GROUP     = 1,
	BLUE_GROUP    = 2,
	ATTITUDE      = 10,
	OPINION_LIST  = 11,
	PACT_LIST     = 21,
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