--[[
	City 

	Development	
		Agriculture -> Food+++, Labour+
		Commerce -> Money+++, Labour+
		Production -> Build+++, Labour+

	Popu Structure
		FARMER   	Agriculture+
		WORKER   	Production+
		MERCHANT 	Commerce+
		MIDDLE      OTHER POPU+-
		BACHELOR 	Tech+
		OFFICER  	Tax+
		RICH     	Tax+
		NOBLE    	Culture+
		SOLDIER  	Security+
		HOBO     	Security-

	Task
		Policy
		Build
		Levy Tax
		Hire
		Establish corps
--]]


CityAssetType = 
{
	BASE_ATTRIB     = 1,
	GROWTH_ATTRIB   = 2,
	PROPERTY_ATTRIB = 3,
}

CityAssetID = 
{
	GROUP           = 100,
	POPULATION      = 101,
	POPU_STRUCTURE  = 102,
	STATUSES        = 110,
	X               = 120,
	Y               = 121,
	CENTER_PLOT     = 122,	
	PLOTS           = 123,
	ADJACENTS       = 124,

	LEVEL           = 200,
	AGRICULTURE     = 203,
	MAX_AGRICULTURE = 204,
	COMMERCE        = 205,
	MAX_COMMERCE    = 206,
	PRODUCTION      = 207,
	MAX_PRODUCTION  = 208,

	FOOD            = 210,
	MONEY           = 211,
	MATERIAL        = 212,
	SECURITY        = 220,	--enough officer
	SATISFACTION    = 221,	--p
	
	CHARA_LIST      = 300,
	OFFICER_LIST    = 301,	
	CORPS_LIST      = 302,
	CONSTR_LIST     = 303,	

	GUARD           = 310,
	DEFENSES        = 311,	
	TROOPTABLE_LIST = 312,

	INSTRUCTION     = 320,
	POLICY          = 321,
	TASKS           = 322,
}

local function City_InitPolicy()
	local policy = {}
	policy.type     = CityPolicy.NONE
	policy.duration = 0
	policy.progress = 0
	return policy
end

CityAssetAttrib = 
{
	group      = AssetAttrib_SetPointer    ( { id = CityAssetID.GROUP,          type = CityAssetType.BASE_ATTRIB, setter = Entity_SetGroup } ),
	popu       = AssetAttrib_SetNumber     ( { id = CityAssetID.POPULATION,     type = CityAssetType.BASE_ATTRIB } ),
	popu_st    = AssetAttrib_SetList       ( { id = CityAssetID.POPU_STRUCTURE, type = CityAssetType.BASE_ATTRIB } ),
	statuses   = AssetAttrib_SetList       ( { id = CityAssetID.STATUSES,       type = CityAssetType.BASE_ATTRIB } ),
	x          = AssetAttrib_SetNumber     ( { id = CityAssetID.X,              type = CityAssetType.BASE_ATTRIB } ),
	y          = AssetAttrib_SetNumber     ( { id = CityAssetID.Y,              type = CityAssetType.BASE_ATTRIB } ),
	centerplot = AssetAttrib_SetPointer    ( { id = CityAssetID.CENTER_PLOT,    type = CityAssetType.BASE_ATTRIB, setter = Entity_SetPlot } ),
	plots      = AssetAttrib_SetPointerList( { id = CityAssetID.PLOTS,          type = CityAssetType.BASE_ATTRIB, setter = Entity_SetPlot } ),
	adjacents  = AssetAttrib_SetPointerList( { id = CityAssetID.ADJACENTS,      type = CityAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	
	level      = AssetAttrib_SetNumber( { id = CityAssetID.LEVEL,           type = CityAssetType.GROWTH_ATTRIB, min = 0, max = 20 } ),
	agri       = AssetAttrib_SetNumber( { id = CityAssetID.AGRICULTURE,     type = CityAssetType.GROWTH_ATTRIB, min = 0, max = 9999 } ),
	maxAgri    = AssetAttrib_SetNumber( { id = CityAssetID.MAX_AGRICULTURE, type = CityAssetType.GROWTH_ATTRIB, min = 0, max = 9999 } ),
	comm       = AssetAttrib_SetNumber( { id = CityAssetID.COMMERCE,        type = CityAssetType.GROWTH_ATTRIB, min = 0, max = 9999 } ),
	maxComm    = AssetAttrib_SetNumber( { id = CityAssetID.MAX_COMMERCE,    type = CityAssetType.GROWTH_ATTRIB, min = 0, max = 9999 } ),
	prod       = AssetAttrib_SetNumber( { id = CityAssetID.PRODUCTION,      type = CityAssetType.GROWTH_ATTRIB, min = 0, max = 9999 } ),
	maxProd    = AssetAttrib_SetNumber( { id = CityAssetID.MAX_PRODUCTION,  type = CityAssetType.GROWTH_ATTRIB, min = 0, max = 9999 } ),
	
	food       = AssetAttrib_SetNumber( { id = CityAssetID.FOOD,            type = CityAssetType.GROWTH_ATTRIB } ),
	money      = AssetAttrib_SetNumber( { id = CityAssetID.MONEY,           type = CityAssetType.GROWTH_ATTRIB } ),
	material   = AssetAttrib_SetNumber( { id = CityAssetID.MATERIAL,        type = CityAssetType.GROWTH_ATTRIB } ),
	security   = AssetAttrib_SetNumber( { id = CityAssetID.SECURITY,        type = CityAssetType.GROWTH_ATTRIB,  min = 0, max = 100, default = 50 } ),	
	satisfaction = AssetAttrib_SetNumber( { id = CityAssetID.SATISFACTION,  type = CityAssetType.GROWTH_ATTRIB,  min = 0, max = 100, default = 50 } ),

	charas     = AssetAttrib_SetPointerList( { id = CityAssetID.CHARA_LIST,   type = CityAssetType.PROPERTY_ATTRIB, setter = Entity_SetChara } ),
	officers   = AssetAttrib_SetPointerList( { id = CityAssetID.OFFICER_LIST, type = CityAssetType.PROPERTY_ATTRIB, setter = Entity_SetChara } ),
	corps      = AssetAttrib_SetPointerList( { id = CityAssetID.CORPS_LIST,   type = CityAssetType.PROPERTY_ATTRIB, setter = Entity_SetCorps } ),
	constrs    = AssetAttrib_SetPointerList( { id = CityAssetID.CONSTR_LIST,  type = CityAssetType.PROPERTY_ATTRIB, setter = Entity_SetConstruction } ),
	instruction= AssetAttrib_SetPointerList( { id = CityAssetID.INSTRUCTION,  type = CityAssetType.PROPERTY_ATTRIB, default = CityInstruction.NONE } ),

	guard      = AssetAttrib_SetNumber( { id = CityAssetID.GUARD,           type = CityAssetType.PROPERTY_ATTRIB } ),
	defenses   = AssetAttrib_SetList  ( { id = CityAssetID.DEFENSES,        type = CityAssetType.PROPERTY_ATTRIB } ),		
	trooptables = AssetAttrib_SetPointerList( { id = CityAssetID.TROOPTABLE_LIST, type = CityAssetType.PROPERTY_ATTRIB, setter = Table_SetTroop } ),

	instruction = AssetAttrib_SetNumber( { id = CityAssetID.INSTRUCTION,    type = CityAssetType.PROPERTY_ATTRIB } ),
	policy      = AssetAttrib_SetData  ( { id = CityAssetID.POLICY,         type = CityAssetType.PROPERTY_ATTRIB, initer = City_InitPolicy } ),
	tasks       = AssetAttrib_SetPointerList( { id = CityAssetID.TASKS,     type = CityAssetType.PROPERTY_ATTRIB } ),
}

-------------------------------------------

City = class()

function City:__init( ... )
	Entity_Init( self, EntityType.CITY, CityAssetAttrib )
end

--[[
function City:Test()
	self.name = "Test City"

	--create testing data
	Asset_Set( self, CityAssetID.LEVEL, 10 )
	Asset_Set( self, CityAssetID.X, 1 )
	Asset_Set( self, CityAssetID.Y, 1 )	
	Asset_CopyList( self, CityAssetID.ADJACENTS, nil )

	Asset_Plus( self, CityAssetID.AGRICULTURE,     500,  1000 )
	Asset_Plus( self, CityAssetID.MAX_AGRICULTURE, 1000, 1500 )
	Asset_Plus( self, CityAssetID.COMMERCE,        500,  1000 )
	Asset_Plus( self, CityAssetID.MAX_COMMERCE,    1000, 1500 )
	Asset_Plus( self, CityAssetID.PRODUCTION,      500,  1000 )
	Asset_Plus( self, CityAssetID.MAX_PRODUCTION,  1000, 1500 )
	
	Asset_Set( self, CityAssetID.POPULATION,        200000 )
	Asset_CopyList( self, CityAssetID.OFFICER_LIST, nil )
	Asset_CopyList( self, CityAssetID.CHARA_LIST,   nil )
	Asset_CopyList( self, CityAssetID.CORPS_LIST,   nil )

	Asset_CopyList( self, CityAssetID.TROOPTABLE_LIST, { 1, 2 } )

	Asset_Set( self, CityAssetID.MONEY,    100000 )
	Asset_Set( self, CityAssetID.MATERIAL, 100000 )	
end
]]

function City:Load( data )
	--for test
	if not data.food then
		data.food = 10000000
	end

	self.id = data.id
	self.name = data.name

	Asset_Set( self, CityAssetID.LEVEL, data.level )
	Asset_Set( self, CityAssetID.X, data.coordinate.x )
	Asset_Set( self, CityAssetID.Y, data.coordinate.y )	
	
	Asset_CopyList( self, CityAssetID.ADJACENTS, data.adjacents )

	Asset_CopyList( self, CityAssetID.CORPS_LIST,      data.corpes )
	Asset_CopyList( self, CityAssetID.CONSTR_LIST,     data.constrs )
	Asset_CopyList( self, CityAssetID.OFFICER_LIST,    data.officers )
	Asset_CopyList( self, CityAssetID.CHARA_LIST,      data.charas )
	
	Asset_Set( self, CityAssetID.MONEY,    data.money )
	Asset_Set( self, CityAssetID.FOOD,     data.food )
	Asset_Set( self, CityAssetID.MATERIAL, data.material )	
	Asset_Set( self, CityAssetID.SECURITY, data.security )
	Asset_Set( self, CityAssetID.GUARD,    data.guard )	
	Asset_CopyList( self, CityAssetID.DEFENSES,  data.defenses )

	if not data.trooptables then
		Asset_CopyList( self, CityAssetID.TROOPTABLE_LIST, { 100, 200, 300 } )
	else
		Asset_CopyList( self, CityAssetID.TROOPTABLE_LIST, data.trooptables)
	end

	--need to load more
	--InputUtil_Pause( self.name, "init food=" .. Asset_Get( self, CityAssetID.FOOD ))
end

------------------------------------------

function City:TrackData( dump )
	Track_Pop( "track_city_" .. self.id )
	Track_Data( "total popu", Asset_Get( self, CityAssetID.POPULATION ) )
	Track_Data( "security", Asset_Get( self, CityAssetID.SECURITY ) )
	Track_Data( "satisfaction", Asset_Get( self, CityAssetID.SATISFACTION ) )

	Track_Data( "agri", Asset_Get( self, CityAssetID.AGRICULTURE ) )
	Track_Data( "prod", Asset_Get( self, CityAssetID.PRODUCTION ) )
	Track_Data( "comm", Asset_Get( self, CityAssetID.COMMERCE ) )

	for k, v  in pairs( CityPopu ) do
		Track_Data( k, Asset_GetListItem( self, CityAssetID.POPU_STRUCTURE, v ), City_NeedPopu( self, k ) )
	end
	if dump then
		Track_Dump()
	end
end

function City:DumpStats()
	print( self.name .. "("..self.id..")" )
	print( "lv=" .. Asset_Get( self, CityAssetID.LEVEL ) )
	print( "plots=" .. Asset_GetListSize( self, CityAssetID.PLOTS ) )
end

function City:DumpPopu()
	local popu = Asset_Get( self, CityAssetID.POPULATION )
	Asset_ForeachList( self, CityAssetID.POPU_STRUCTURE, function ( value, type )
		local cur = value .. "(".. math.ceil( value * 100 / popu ) .."%)"
		local need = City_NeedPopu( self, MathUtil_FindName( CityPopu, type ) )
		local req = "->" .. need .. "("..math.ceil( value * 100 / need ) .. "%)"
		print( StringUtil_Abbreviate( MathUtil_FindName( CityPopu, type ), 8 ) .." = " .. cur .. " " .. req )
	end )
	City_GetSupportPopu( self )
	print( StringUtil_Abbreviate( "POPU", 8 ) .. " = " .. Asset_Get( self, CityAssetID.POPULATION ) )
end

function City:DumpPlots()
	Asset_ForeachList( self, CityAssetID.PLOTS, function( plot )
	end )
end

function City:DumpGrowthAttrs()
	Entity_ForeachAttrib( self, function ( k, attrib )
		if attrib.type == CityAssetType.GROWTH_ATTRIB then
			print( MathUtil_FindName( CityAssetID, k ), "=", Asset_Get( self, attrib.id ) )
		end
	end)
end

function City:DumpProperty( ... )
	Entity_ForeachAttrib( self, function ( k, attrib )
		if attrib.type == CityAssetType.PROPERTY_ATTRIB then
			print( MathUtil_FindName( CityAssetID, k ), "=", Asset_Get( self, attrib.id ) )
		end
	end)
end

------------------------------------------

function City:InitPlots()
	Asset_ForeachList( self, CityAssetID.PLOTS, function( plot )
		Asset_Plus( self, CityAssetID.POPULATION,  Asset_Get( plot, PlotAssetID.POPULATION ) )

		Asset_Plus( self, CityAssetID.AGRICULTURE,     Asset_Get( plot, PlotAssetID.AGRICULTURE ) )
		Asset_Plus( self, CityAssetID.MAX_AGRICULTURE, Asset_Get( plot, PlotAssetID.MAX_AGRICULTURE ) )
		Asset_Plus( self, CityAssetID.COMMERCE,        Asset_Get( plot, PlotAssetID.COMMERCE ) )
		Asset_Plus( self, CityAssetID.MAX_COMMERCE,    Asset_Get( plot, PlotAssetID.MAX_COMMERCE ) )
		Asset_Plus( self, CityAssetID.PRODUCTION,      Asset_Get( plot, PlotAssetID.PRODUCTION ) )
		Asset_Plus( self, CityAssetID.MAX_PRODUCTION,  Asset_Get( plot, PlotAssetID.MAX_PRODUCTION ) )
	end )
end

function City:InitPopu()
	City_InitPopuStructure( self )
end

function City:VerifyData()
	local city = self

	print( self.name, "popu=" .. Asset_Get( self, CityAssetID.POPULATION ) )

	Asset_ForeachList( self, CityAssetID.CORPS_LIST, function( corps )
		Asset_Set( corps, CorpsAssetID.ENCAMPMENT, city )
		Asset_Set( corps, CorpsAssetID.LOCATION, city )
	end )

	Asset_ForeachList( self, CityAssetID.CHARA_LIST, function( chara )
		Asset_Set( chara, CharaAssetID.HOME, city )
		Asset_Set( chara, CharaAssetID.LOCATION, city )
	end )

	Asset_VerifyList( self, CityAssetID.ADJACENTS )

	self:ElectExecutive()
end

-------------------------------------------
--getter

--get number of population structure 
function City:GetPopu( citypopu )
	if not citypopu then
		print( "invalid City:GetPopu() params" )
		return 0
	end
	local data = Asset_Get( self, CityAssetID.POPU_STRUCTURE )	
	return data[citypopu]
end


--type from enum CityOfficer
function City:GetOfficer( type )	
	return Asset_GetListItem( self, CityAssetID.OFFICER_LIST, type )
end

-------------------------------------------
--checker

function City:IsCapital()
	local group = Asset_Get( self, CityAssetID.GROUP )
	if not group then return false end
	return Asset_Get( group, GroupAssetID.CAPITAL ) == self
end

-------------------------------------------

function City:ReducePopu( poputype, number )
	local cur = Asset_GetListItem( self, CityAssetID.POPU_STRUCTURE, poputype )
	if cur < number then return false end
	Asset_SetListItem( self, CityAssetID.POPU_STRUCTURE, poputype, cur - number )
	Asset_Reduce( self, CityAssetID.POPULATION, number )
end

-------------------------------------------

function City:FilterAdjaCities( filter )
	local list = {}	
	Asset_ForeachList( self, CityAssetID.ADJACENTS, function ( adja )
		if filter( adja ) == true then
			table.insert( list, adja )
		end
	end)
	return list
end

function City:FilterOfficer( filter )
	local list = {}
	Asset_ForeachList( self, CityAssetID.OFFICER_LIST, function ( chara )
		if filter( chara ) == true then
			table.insert( list, chara )
		end
	end)
	return list
end

function City:GetNumOfFreeCorps()
	--has corps
	local freeCorps = 0
	Asset_ForeachList( self, CityAssetID.CORPS_LIST, function ( corps )
		if Asset_Get( corps, CorpsAssetID.LOCATION ) == Asset_Get( corps, CorpsAssetID.ENCAMPMENT ) then
			local ret = Asset_GetListItem( corps, CorpsAssetID.STATUSES, CorpsStatus.IN_TASK )
			if not ret or ret ~= true then
				freeCorps = freeCorps + 1
			end
		end
	end)
	return freeCorps
end

function City:FindFreeCorps()
	local list = {}
	Asset_ForeachList( self, CityAssetID.CORPS_LIST, function ( corps )
		if Asset_Get( corps, CorpsAssetID.LOCATION ) == Asset_Get( corps, CorpsAssetID.ENCAMPMENT ) then
			local ret = Asset_GetListItem( corps, CorpsAssetID.STATUSES, CorpsStatus.IN_TASK )
			if not ret or ret ~= true then
				table.insert( list, corps )
			end
		end
	end)
	return list
end

function City:FindHarassCityTargets()
	local group = Asset_Get( self, CityAssetID.GROUP )
	local selfPower = City_GetMilitaryPower( self )
	return self:FilterAdjaCities( function ( adja )
		local adjaGroup = Asset_Get( adja, CityAssetID.GROUP )
		return Group_IsAtWar( adjaGroup, group )
	end )
end

function City:FindAttackCityTargets()
	local group = Asset_Get( self, CityAssetID.GROUP )
	local selfPower = City_GetMilitaryPower( self )
	return self:FilterAdjaCities( function ( adja )		
		local adjaGroup = Asset_Get( adja, CityAssetID.GROUP )
		if adjaGroup == group then print( "same group") return false end		
		if Group_IsAtWar( adjaGroup, group ) == false then return false end
		local adjaPower = City_GetMilitaryPowerWithIntel( adja, group )	
		--if adjaPower > selfPower then return false end
		return true
	end )
end

--------------------------------------------

function City:CorpsJoin( corps )
	--[[
	--allot food
	local reservedfood = corps:GetConsumeFood() * 30
	local food = Asset_Get( self, CityAssetID.FOOD )
	reservedfood = math.min( food, reservedfood )
	Asset_Set( corps, CorpsAssetID.FOOD, reservedfood )
	food = food - reservedfood
	Asset_Set( self, CityAssetID.FOOD )
	]]

	--insert trooplist
	Asset_AppendList( self, CityAssetID.CORPS_LIST, corps )

	--insert charalist
	Asset_ForeachList( corps, CorpsAssetID.OFFICER_LIST, function ( chara )
		Asset_AppendList( self, CityAssetID.CHARA_LIST, chara )
	end)
end

function City:CorpsLeave( corps )
	--remove from trooplist
	Asset_RemoveListItem( self, CityAssetID.CORPS_LIST, corps )

	--remove charalist
	Asset_ForeachList( corps, CorpsAssetID.OFFICER_LIST, function ( chara )
		Asset_RemoveListItem( self, CityAssetID.CHARA_LIST,   chara )
		Asset_RemoveListItem( self, CityAssetID.OFFICER_LIST, chara )
	end)
end

--------------------------------------------

function City:ElectExecutive()
	local executive = self:GetOfficer( CityOfficer.EXECUTIVE )
	if not executive then
		--find a leader from officer
		executive = Random_GetListData( self, CityAssetID.CHARA_LIST )		
		DBG_Trace( "city=" .. self.name .. " no executive", executive )
		if executive then
			Asset_SetListItem( self, CityAssetID.OFFICER_LIST, CityOfficer.EXECUTIVE, executive )
			CRR_Tolerate( "city=" .. self.name .. " set default executive=" .. executive.name )			
		end
	end
end

function City:Update()
	--no executive? find one
	self:ElectExecutive()

	local day = g_calendar:GetDay()
	if day == 1 then
		--Message_Post( MessageType.CITY_HOLD_MEETING, { city = self } )
		Meeting_Hold( self )
	end

	--print( self.name, "food=" .. Asset_Get( self, CityAssetID.FOOD ))

	if day == 1 then
		--Track_HistoryRecord( "soldier", { name = self.name, soldier = City_GetSoldier( self ), date = g_calendar:GetDateValue() } )
		--Track_HistoryRecord( "dev", { name = self.name, agr = Asset_Get( self, CityAssetID.AGRICULTURE ), comm = Asset_Get( self, CityAssetID.COMMERCE ), prod = Asset_Get( self, CityAssetID.PRODUCTION ), date = g_calendar:GetDateValue() } )
	end
end

--------------------------------------------

function City:Starvation()
	local cur = Asset_GetListItem( self, CityAssetID.STATUSES, CityStatus.STARVATION )
	if not cur then cur = 1 end
	Asset_SetListItem( self, CityAssetID.STATUSES, cur + 1 )
end

--[[
function City:ConsumeFood( consume )
	local food = Asset_Get( city, CityAssetID.FOOD )
	if food < consume then
		--not enough
		return false
	end
	Asset_Set( city, CityAssetID.FOOD, food - consume )
	--print( city.name, "consume food=" .. consume, "remain=" .. food - consume )
	return true
end
]]