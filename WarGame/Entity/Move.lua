-------------------------------------------

MoveAssetType = 
{
	BASE_ATTRIB = 1,
}

MoveAssetID = 
{
	ROLE       = 1,
	ACTOR      = 2,
	FROM_CITY  = 3,
	TO_CITY    = 4,
	CUR_PLOT   = 5,
	NEXT_PLOT  = 6,
	DEST_PLOT  = 7,
	BEGIN_TIME = 10,
	END_TIME   = 11,
	STATUS     = 12,
	PROGRESS   = 13,
	DURATION   = 14,
	PATH       = 15,
}

MoveAssetAttrib = 
{
	role     = AssetAttrib_SetNumber ( { id = MoveAssetID.ROLE,       type = MoveAssetType.BASE_ATTRIB, enum = MoveRole } ),
	actor    = AssetAttrib_SetPointer( { id = MoveAssetID.ACTOR,      type = MoveAssetType.BASE_ATTRIB } ),
	fromcity = AssetAttrib_SetPointer( { id = MoveAssetID.FROM_CITY,  type = MoveAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	tocity   = AssetAttrib_SetPointer( { id = MoveAssetID.TO_CITY,    type = MoveAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	curplot  = AssetAttrib_SetPointer( { id = MoveAssetID.CUR_PLOT,   type = MoveAssetType.BASE_ATTRIB, setter = Entity_SetPlot } ),
	nextplot = AssetAttrib_SetPointer( { id = MoveAssetID.NEXT_PLOT,  type = MoveAssetType.BASE_ATTRIB, setter = Entity_SetPlot } ),
	destplot = AssetAttrib_SetPointer( { id = MoveAssetID.DEST_PLOT,  type = MoveAssetType.BASE_ATTRIB, setter = Entity_SetPlot } ),
	begtime  = AssetAttrib_SetNumber ( { id = MoveAssetID.BEGIN_TIME, type = MoveAssetType.BASE_ATTRIB } ),
	endtime  = AssetAttrib_SetNumber ( { id = MoveAssetID.END_TIME,   type = MoveAssetType.BASE_ATTRIB } ),
	status   = AssetAttrib_SetNumber ( { id = MoveAssetID.STATUS,     type = MoveAssetType.BASE_ATTRIB, enum = MoveStatus } ),
	progress = AssetAttrib_SetNumber ( { id = MoveAssetID.PROGRESS,   type = MoveAssetType.BASE_ATTRIB } ),
	duration = AssetAttrib_SetNumber ( { id = MoveAssetID.DURATION,   type = MoveAssetType.BASE_ATTRIB } ),
	path     = AssetAttrib_SetPointer( { id = MoveAssetID.PATH,       type = MoveAssetType.BASE_ATTRIB } ),
}


-------------------------------------------


Move = class()

function Move:__init( ... )
	Entity_Init( self, EntityType.MOVE, MoveAssetAttrib )
end

function Move:ToString( type )
	local content = Asset_Get( self, MoveAssetID.ACTOR ):ToString()
	local curplot = Asset_Get( self, MoveAssetID.CUR_PLOT )
	if curplot then content = content .. " cur=" .. curplot:ToString() end
	content = content .. " dst=" .. Asset_Get( self, MoveAssetID.DEST_PLOT ):ToString()
	if type == "END" then
		content = content .. " day=" .. g_calendar:CalcDiffDayByDates( Asset_Get( self, MoveAssetID.END_TIME ), Asset_Get( self, MoveAssetID.BEGIN_TIME ) )
	end
	return content
end

function Move:Load( data )
	self.id = data.id

	--to do
end

function Move:IsArrived()
	return Asset_Get( self, MoveAssetID.PROGRESS ) >= Asset_Get( self, MoveAssetID.DURATION )
end

--------------------------------------------
