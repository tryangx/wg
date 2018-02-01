RouteAssetType = 
{
	BASE_ATTRIB      = 1,
}

RouteAssetID = 
{
	--plot
	FROM_CITY   = 1,
	--plot
	TO_CITY     = 2,
	NODES       = 3,
}

RouteAssetAttrib = 
{
	from     = AssetAttrib_SetPointer( { id = RouteAssetID.FROM_CITY,type = RouteAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	to       = AssetAttrib_SetPointer( { id = RouteAssetID.TO_CITY,  type = RouteAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	nodes    = AssetAttrib_SetList   ( { id = RouteAssetID.NODES,    type = RouteAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
}

-------------------------------------------


Route = class()

function Route:__init( ... )
	Entity_Init( self, EntityType.ROUTE, RouteAssetAttrib )
end

function Route:Load( data )
	self.id = data.id

	Asset_Set( self, RouteAssetID.FROM_CITY, data.from )
	Asset_Set( self, RouteAssetID.TO_CITY,   data.to )
	Asset_CopyList( self, RouteAssetID.NODES, data.nodes )
end

--------------------------------------------

function Route:FindNext( cur, destination )
	local cx = Asset_Get( cur, PlotAssetID.X )
	local cy = Asset_Get( cur, PlotAssetID.Y )
	--[[
	print( "cur  =", Asset_Get( cur, PlotAssetID.X ), ",", Asset_Get( cur, PlotAssetID.Y ) )
	print( "dest =", Asset_Get( destination, CityAssetID.X ), ",", Asset_Get( destination, CityAssetID.Y ) )	
	print( "from =", Asset_Get( Asset_Get( self, RouteAssetID.FROM_CITY ), CityAssetID.X ), ",", Asset_Get( Asset_Get( self, RouteAssetID.FROM_CITY ), CityAssetID.Y ) )	
	print( "to   =", Asset_Get( Asset_Get( self, RouteAssetID.TO_CITY ), CityAssetID.X ), ",", Asset_Get( Asset_Get( self, RouteAssetID.TO_CITY ), CityAssetID.Y ) )	
	--]]
	local next
	Asset_FindList( self, RouteAssetID.NODES, function ( node, index )
		--if cx == node.x and cy == node.y then
		--print( "check  =", Asset_Get( node, PlotAssetID.X ), ",", Asset_Get( node, PlotAssetID.Y ), index )
		if node == cur then
			if Asset_Get( self, RouteAssetID.TO_CITY ) == destination then				
				next = Asset_GetListIndex( self, RouteAssetID.NODES, index + 1 )
				--print( "find prev=", Asset_Get( next, PlotAssetID.X ), ",", Asset_Get( next, PlotAssetID.Y ) )
			else
				next = Asset_GetListIndex( self, RouteAssetID.NODES, index - 1 )
				--print( "find next=", Asset_Get( next, PlotAssetID.X ), ",", Asset_Get( next, PlotAssetID.Y ) )
			end
			return true
		end
		return false
	end )
	--print( destination, cur, next )	
	--print( "next =", Asset_Get( next, PlotAssetID.X ), ",", Asset_Get( next, PlotAssetID.Y ) )
	return next
end