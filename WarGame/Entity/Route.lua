RouteAssetType = 
{
	BASE_ATTRIB      = 1,
}

RouteAssetID = 
{
	FROM   = 1,
	TO     = 2,
	NODES  = 3,
}

RouteAssetAttrib = 
{
	from     = AssetAttrib_SetPointer( { id = RouteAssetID.FROM,     type = RouteAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	to       = AssetAttrib_SetPointer( { id = RouteAssetID.TO,       type = RouteAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	nodes    = AssetAttrib_SetList   ( { id = RouteAssetID.NODES,    type = RouteAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
}

-------------------------------------------


Route = class()

function Route:__init( ... )
	Entity_Init( self, EntityType.ROUTE, RouteAssetAttrib )
end

function Route:Load( data )
	self.id = data.id

	Asset_Set( self, RouteAssetID.FROM, data.from )
	Asset_Set( self, RouteAssetID.TO,   data.to )
	Asset_CopyList( self, RouteAssetID.NODES, data.nodes )
end

--------------------------------------------

function Route_QueryPath( city1, city2 )
	return Entity_Filter( EntityType.ROUTE, function( route )
		local from = Asset_Get( route, RouteAssetID.FROM )
		local to = Asset_Get( route, RouteAssetID.TO )
		if ( from == city1 and to == city2 ) or ( from == city2 and to == city1 ) then
			return true
		end
	end )
end