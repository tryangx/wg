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
	ROUTE      = 15,
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
	route    = AssetAttrib_SetPointer( { id = MoveAssetID.ROUTE,      type = MoveAssetType.BASE_ATTRIB } ),
}


-------------------------------------------


Move = class()

function Move:__init( ... )
	Entity_Init( self, EntityType.MOVE, MoveAssetAttrib )
end

function Move:Load( data )
	self.id = data.id

	--to do
end

function Move:IsReachNext()
	return Asset_Get( self, MoveAssetID.PROGRESS ) >= Asset_Get( self, MoveAssetID.DURATION )
end