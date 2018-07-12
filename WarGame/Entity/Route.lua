RouteAssetType = 
{
	BASE_ATTRIB      = 1,
}

RouteAssetID = 
{
	--plot
	FROM_PLOT   = 1,
	--plot
	TO_PLOT     = 2,
	NODES       = 3,
	DISTANCE    = 4,
	FROM_CITY   = 5,
	TO_CITY     = 6,
}

RouteAssetAttrib = 
{
	from     = AssetAttrib_SetPointer( { id = RouteAssetID.FROM_PLOT, type = RouteAssetType.BASE_ATTRIB } ),
	to       = AssetAttrib_SetPointer( { id = RouteAssetID.TO_PLOT,   type = RouteAssetType.BASE_ATTRIB } ),
	nodes    = AssetAttrib_SetList   ( { id = RouteAssetID.NODES,     type = RouteAssetType.BASE_ATTRIB } ),
	distance = AssetAttrib_SetNumber ( { id = RouteAssetID.DISTANCE,  type = RouteAssetType.BASE_ATTRIB } ),
	fromcity = AssetAttrib_SetPointer( { id = RouteAssetID.FROM_CITY, type = RouteAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	tocity   = AssetAttrib_SetPointer( { id = RouteAssetID.TO_CITY,   type = RouteAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
}

-------------------------------------------


Route = class()

function Route:__init( ... )
	Entity_Init( self, EntityType.ROUTE, RouteAssetAttrib )
end

function Route:Load( data )
	self.id = data.id

	Asset_Set( self, RouteAssetID.FROM_PLOT, data.from )
	Asset_Set( self, RouteAssetID.TO_PLOT,   data.to )
	Asset_CopyList( self, RouteAssetID.NODES, data.nodes )
end

function Route:ToString()
	local content = ""
	content = content .. Asset_Get( self, RouteAssetID.FROM_CITY ).name .. Asset_Get( self, RouteAssetID.FROM_PLOT ):ToString() .. "->" .. Asset_Get( self, RouteAssetID.TO_CITY ).name .. Asset_Get( self, RouteAssetID.TO_PLOT ):ToString()
	return content
end

--------------------------------------------

--find next plot in the route nodes by given current node and destination 
function Route:FindNext( cur, to )
	local cx = Asset_Get( cur, PlotAssetID.X )
	local cy = Asset_Get( cur, PlotAssetID.Y )
	--[[
	print( "cur  =", Asset_Get( cur, PlotAssetID.X ), ",", Asset_Get( cur, PlotAssetID.Y ) )
	print( "dest =", Asset_Get( city, CityAssetID.X ), ",", Asset_Get( city, CityAssetID.Y ) )	
	print( "from =", Asset_Get( Asset_Get( self, RouteAssetID.FROM_PLOT ), CityAssetID.X ), ",", Asset_Get( Asset_Get( self, RouteAssetID.FROM_PLOT ), CityAssetID.Y ) )	
	print( "to   =", Asset_Get( Asset_Get( self, RouteAssetID.TO_PLOT ), CityAssetID.X ), ",", Asset_Get( Asset_Get( self, RouteAssetID.TO_PLOT ), CityAssetID.Y ) )	
	--]]
	local next
	Asset_FindItem( self, RouteAssetID.NODES, function ( node, index )
		--if cx == node.x and cy == node.y then
		--print( "check  =", Asset_Get( node, PlotAssetID.X ), ",", Asset_Get( node, PlotAssetID.Y ), index )
		if node == cur then
			if Asset_Get( self, RouteAssetID.TO_PLOT ) == to then				
				next = Asset_GetListItem( self, RouteAssetID.NODES, index + 1 )
				--InputUtil_Pause( "find prev=", Asset_Get( next, PlotAssetID.X ), ",", Asset_Get( next, PlotAssetID.Y ) )
			else
				next = Asset_GetListItem( self, RouteAssetID.NODES, index - 1 )
				--InputUtil_Pause( "find next=", Asset_Get( next, PlotAssetID.X ), ",", Asset_Get( next, PlotAssetID.Y ) )
			end
			return true
		end
		return false
	end )
	--print( city, cur, next )	
	--print( "next =", Asset_Get( next, PlotAssetID.X ), ",", Asset_Get( next, PlotAssetID.Y ) )
	return next
end

function Route:FindPort( start )
	local from = Asset_Get( self, RouteAssetID.FROM_PLOT )
	return start == from and Asset_Get( self, RouteAssetID.TO_PLOT ) or from
end