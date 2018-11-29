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
	local content = ""
	content = content .. self.id
	content = content .. " " .. Asset_Get( self, MoveAssetID.ACTOR ):ToString()

	content = content .. MathUtil_FindName( MoveStatus, Asset_Get( self, MoveAssetID.STATUS ) )
	
	local curplot = Asset_Get( self, MoveAssetID.CUR_PLOT )
	if curplot then content = content .. " cur=" .. curplot:ToString() end

	local fromCity = Asset_Get( self, MoveAssetID.FROM_CITY )
	content = content .. " from=" .. fromCity:ToString( "SIMPLE" )	
	
	local tocity = Asset_Get( self, MoveAssetID.TO_CITY )
	if tocity then
		content = content .. " dst=" .. tocity:ToString("SIMPLE")
	else
		content = content .. " dst=" .. Asset_Get( self, MoveAssetID.DEST_PLOT ):ToString()	
	end

	if type == "TRACK" then
		content = content .. " next=" ..  Asset_Get( self, MoveAssetID.NEXT_PLOT ):ToString()
	end

	if type == "PATH" then
		for _, plot in pairs( path ) do
			content = content .. plot:ToString() .. ","
		end
	end

	content = content .. " beg=" .. g_Time:CreateDateDescByValue( Asset_Get( self, MoveAssetID.BEGIN_TIME ) )
	
	if type == "END" then
		content = content .. " day=" .. g_Time:CalcDiffDayByDates( Asset_Get( self, MoveAssetID.END_TIME ), Asset_Get( self, MoveAssetID.BEGIN_TIME ) )
	elseif type == "DEBUG" then
		content = content .. " prg=" .. Asset_Get( self, MoveAssetID.PROGRESS )
		content = content .. " dur=" .. Asset_Get( self, MoveAssetID.DURATION )
	else
		content = content .. " pas=" .. self:GetPassDay()
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

function Move:IsMoving()
	return Asset_Get( self, MoveAssetID.STATUS ) == MoveStatus.MOVING
end

function Move:GetMovement()	
	local actor = Asset_Get( self, MoveAssetID.ACTOR )
	local role = Asset_Get( self, MoveAssetID.ROLE )	
	if role == MoveRole.CORPS then
		return Asset_Get( actor, CorpsAssetID.MOVEMENT )
	elseif role == MoveRole.CHARA then
		return Move_GetCharaMovement( actor )
	end
	return 1
end

function Move:GetPassDay()
	return g_Time:CalcDiffDayByDate( Asset_Get( self, MoveAssetID.BEGIN_TIME ) )
end

--------------------------------------------

function Move:Wait( time )
	if time then
		local movement = self:GetMovement()
		Asset_Plus( self, MoveAssetID.DURATION, movement * time )
	end
end

function Move:Suspend()
	--InputUtil_Pause( "suspend", move:ToString() )
	--print( 'suspend', self:ToString() )
	Asset_Set( self, MoveAssetID.STATUS, MoveStatus.SUSPEND )
end

function Move:Start()
	Asset_Set( self, MoveAssetID.STATUS, MoveStatus.MOVING )

	local actor = Asset_Get( self, MoveAssetID.ACTOR )
	local role = Asset_Get( self, MoveAssetID.ROLE )	
	if role == MoveRole.CORPS then
		actor:SetStatus( CorpsStatus.OUTSIDE, true )
	elseif role == MoveRole.CHARA then
		actor:SetStatus( CharaStatus.OUTSIDE, true )
	end
end

function Move:End()
	Asset_Set( self, MoveAssetID.STATUS, MoveStatus.END )

	local actor = Asset_Get( self, MoveAssetID.ACTOR )
	local role = Asset_Get( self, MoveAssetID.ROLE )	
	if role == MoveRole.CHARA then
		actor:SetStatus( CharaStatus.OUTSIDE )
	elseif role == MoveRole.CORPS then
		actor:SetStatus( CorpsStatus.OUTSIDE )
	end
end