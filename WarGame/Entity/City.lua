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
	DISSATISFACTION = 221,	--p
	
	CHARA_LIST      = 300,
	OFFICER_LIST    = 301,	
	CORPS_LIST      = 302,
	CONSTR_LIST     = 303,
	PRISONER_LIST   = 304,
	SPY_LIST        = 305,

	GUARD           = 310,
	DEFENSES        = 311,	
	TROOPTABLE_LIST = 312,

	INSTRUCTION     = 320,
	PLANS           = 321,
	RESEARCH        = 322,
}

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
	dissatisfaction = AssetAttrib_SetNumber( { id = CityAssetID.DISSATISFACTION,  type = CityAssetType.GROWTH_ATTRIB,  min = 0, max = 100, default = 50 } ),

	charas     = AssetAttrib_SetPointerList( { id = CityAssetID.CHARA_LIST,   type = CityAssetType.PROPERTY_ATTRIB, setter = Entity_SetChara } ),	
	officers   = AssetAttrib_SetPointerList( { id = CityAssetID.OFFICER_LIST, type = CityAssetType.PROPERTY_ATTRIB, setter = Entity_SetChara } ),
	corps      = AssetAttrib_SetPointerList( { id = CityAssetID.CORPS_LIST,   type = CityAssetType.PROPERTY_ATTRIB, setter = Entity_SetCorps } ),
	constrs    = AssetAttrib_SetPointerList( { id = CityAssetID.CONSTR_LIST,  type = CityAssetType.PROPERTY_ATTRIB, setter = Entity_SetConstruction } ),
	prisoner   = AssetAttrib_SetPointerList( { id = CityAssetID.PRISONER_LIST,type = CityAssetType.PROPERTY_ATTRIB, setter = Entity_SetChara } ),
	spys       = AssetAttrib_SetList       ( { id = CityAssetID.SPY_LIST,     type = CityAssetType.PROPERTY_ATTRIB } ),

	guard      = AssetAttrib_SetNumber( { id = CityAssetID.GUARD,           type = CityAssetType.PROPERTY_ATTRIB } ),
	defenses   = AssetAttrib_SetList  ( { id = CityAssetID.DEFENSES,        type = CityAssetType.PROPERTY_ATTRIB } ),		
	trooptables = AssetAttrib_SetPointerList( { id = CityAssetID.TROOPTABLE_LIST, type = CityAssetType.PROPERTY_ATTRIB, setter = Table_SetTroop } ),

	instruction = AssetAttrib_SetNumber( { id = CityAssetID.INSTRUCTION,    type = CityAssetType.PROPERTY_ATTRIB } ),
	plans       = AssetAttrib_SetList  ( { id = CityAssetID.PLANS,          type = CityAssetType.PROPERTY_ATTRIB } ),
	research    = AssetAttrib_SetData  ( { id = CityAssetID.RESEARCH,       type = CityAssetType.GROWTH_ATTRIB } ),
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
end

function City:ToString( type )
	local content = "[" .. self.name .. "]"
	local group = Asset_Get( self, CityAssetID.GROUP )
	content = content .. "[" .. ( group and group.name or "" ) .. "]"

	if type == "SIMPLE" then
		content = content .. "(" .. Asset_Get( self, CityAssetID.CENTER_PLOT ):ToString() ..  ")"

	elseif type == "ALL" then
		content = content .. "(" .. Asset_Get( self, CityAssetID.CENTER_PLOT ):ToString() ..  ")"
		content = content .. " chars=" .. Asset_GetListSize( self, CityAssetID.CHARA_LIST )
		content = content .. " corps=" .. Asset_GetListSize( self, CityAssetID.CORPS_LIST )
		content = content .. " offr=" .. Asset_GetListSize( self, CityAssetID.OFFICER_LIST )
		content = content .. " cons=" .. Asset_GetListSize( self, CityAssetID.CONSTR_LIST )
		content = content .. " popu=" .. Asset_Get( self, CityAssetID.POPULATION )
		content = content .. " resv=" .. Asset_GetListItem( self, CityAssetID.POPU_STRUCTURE, CityPopu.RESERVES )

	elseif type == "OFFICER" then
		content = content .. " chars=" .. Asset_GetListSize( self, CityAssetID.CHARA_LIST )
		Asset_ForeachList( self, CityAssetID.OFFICER_LIST, function ( officer, job )
			content = content .. " [" .. MathUtil_FindName( CityJob, job ) .. "]=" .. officer.name
		end )

	elseif type == "MILITARY" then
		content = content .. " corps=" .. Asset_GetListSize( self, CityAssetID.CORPS_LIST )
		content = content .. " soldier=" .. self:GetSoldier()
		content = content .. " reserved=" .. Asset_GetListItem( self, CityAssetID.POPU_STRUCTURE, CityPopu.RESERVES )

	end
	return content
end

------------------------------------------

function City:TrackData( dump )
	Track_Pop( "track_city_" .. self.id )
	Track_Data( "total popu", Asset_Get( self, CityAssetID.POPULATION ) )
	Track_Data( "security", Asset_Get( self, CityAssetID.SECURITY ) )
	Track_Data( "dissatisfaction", Asset_Get( self, CityAssetID.DISSATISFACTION ) )

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

function City:Init()
	local group = Asset_Get( self, CityAssetID.GROUP )
	Asset_ForeachList( self, CityAssetID.ADJACENTS, function ( city )
		local grade = CitySpyParams.INIT_GRADE
		if Asset_Get( city, CityAssetID.GROUP ) == group then
			grade = CitySpyParams.MAX_GRADE
		end
		Asset_AppendList( self, CityAssetID.SPY_LIST, { city = city, grade = grade, intel = 0 } )
	end )
	self:InitPlots()
	self:InitPopu()
end

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

	--print( self.name, "popu=" .. Asset_Get( self, CityAssetID.POPULATION ) )

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

function City:GetMaxBulidArea()
	local area = 10
	local center = Asset_Get( self, CityAssetID.CENTER_PLOT )
	local template = Asset_Get( center, PlotAssetID.TEMPLATE )	
	if template.type == PlotType.LAND then
		area = 16
	elseif template.type == PlotType.HILLS then
		area = 8
	elseif template.type == PlotType.MOUNTAIN then
		area = 4
	elseif template.type == PlotType.WATER then
		area = 12
	end

	if template.terrain == PlotTerrainType.PLAINS then
		area = area + 4
	elseif template.terrain == PlotTerrainType.GRASSLAND then
		area = area + 4
	elseif template.terrain == PlotTerrainType.DESERT then
		area = area - 4
	elseif template.terrain == PlotTerrainType.TUNDRA then
		area = area - 2
	elseif template.terrain == PlotTerrainType.SNOW then
		area = area - 2
	elseif template.terrain == PlotTerrainType.LAKE then
	elseif template.terrain == PlotTerrainType.COAST then
		area = area - 2
	elseif template.terrain == PlotTerrainType.OCEAN then
		area = 0
	end
	return math.max( 2, area )
end

--get number of population structure 
function City:GetPopu( citypopu )
	if not citypopu then
		print( "invalid City:GetPopu() params" )
		return 0
	end
	local data = Asset_Get( self, CityAssetID.POPU_STRUCTURE )	
	return data[citypopu]
end


--type from enum CityJob
function City:GetOfficer( type )	
	return Asset_GetListItem( self, CityAssetID.OFFICER_LIST, type )
end

function City:GetCharaJob( chara )
	local findJob = CityJob.NONE
	Asset_FindListItem( self, CityAssetID.OFFICER_LIST, function ( officer, job )		
		if officer == chara then
			--InputUtil_Pause( "checker", officer.name, chara.name, job )
			findJob = job
			return true
		end
	end )
	return findJob
end

function City:GetSoldier()
	--corps in city
	local soldier = 0
	local maxSoldier = 0
	Asset_ForeachList( self, CityAssetID.CORPS_LIST, function ( corps )
		Asset_ForeachList( corps, CorpsAssetID.TROOP_LIST, function( troop )
			local cur = Asset_Get( troop, TroopAssetID.SOLDIER )
			local max = Asset_Get( troop, TroopAssetID.MAX_SOLDIER )
			soldier = soldier + cur
			maxSoldier = maxSoldier + max
		end )
	end )

	return soldier, maxSoldier
end

--Get military power evaluation
function City:GetMilitaryPower()
	--corps in city
	local power = 0
	Asset_ForeachList( self, CityAssetID.CORPS_LIST, function ( corps )
		Asset_ForeachList( corps, CorpsAssetID.TROOP_LIST, function( troop )
			power = power + Asset_Get( troop, TroopAssetID.SOLDIER ) * TroopTable_GetPower( troop )
		end )
	end )

	--reserved

	return power
end

-------------------------------------------
--checker

function City:IsCapital()
	local group = Asset_Get( self, CityAssetID.GROUP )
	if not group then return false end
	return Asset_Get( group, GroupAssetID.CAPITAL ) == self
end

function City:IsCharaOfficer( type, chara )
	if not type or not chara then return false end
	return self:GetOfficer( type ) == chara
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

--chara is at home
--chara isn't in task
--chara isn't corps leader
function City:FindFreeCharas()
	local charaList = {}
	Asset_ForeachList( self, CityAssetID.CHARA_LIST, function( chara )
		if chara:IsAtHome() == false then return end
		if chara:IsBusy() == true then return end
		if Asset_Get( chara, CharaAssetID.CORPS ) then return end		
		table.insert( charaList, chara )
	end )
	return charaList
end

function City:GetNumOfOfficerSlot()
	local endPos = self:IsCapital() and CityJob.CAPITAL_POSITION_END or CityJob.POSITION_END
	return endPos - CityJob.POSITION_BEGIN
end

function City:FindVacancyOfficerPositions()
	local posList = {}
	local endPos = self:IsCapital() and CityJob.CAPITAL_POSITION_END or CityJob.POSITION_END
	for pos = CityJob.POSITION_BEGIN + 1, endPos do
		local officer = self:GetOfficer( pos )
		if not officer then
			table.insert( posList, pos )
		end
	end
	return posList
end

--return list of characters not chara in any officer position
function City:FindNonOfficerFreeCharas( charaList )
	if not charaList then charaList = {} end
	Asset_ForeachList( self, CityAssetID.CHARA_LIST, function( chara )
		if chara:IsAtHome() == false then return end
		if chara:IsBusy() == true then return end
		if Asset_HasItem( self, CityAssetID.OFFICER_LIST, chara ) == true then return end
		table.insert( charaList, chara )
	end )
	return charaList
end

function City:GetDefendCorps()
	local list = {}
	Asset_ForeachList( self, CityAssetID.CORPS_LIST, function ( corps )
		if corps:IsAtHome() == false then return end
		table.insert( list, corps )
	end )
	return list
end

--corps should at home
--corps should out of task
--corps should has a leader
function City:GetFreeCorps()
	local list = {}
	local soldier = 0
	local power = 0
	Asset_ForeachList( self, CityAssetID.CORPS_LIST, function ( corps )
		if corps:IsAtHome() == false then return end
		if corps:IsBusy() == true then return end
		if Asset_Get( corps, CorpsAssetID.LEADER ) == nil then return end
		table.insert( list, corps )
		soldier = soldier + corps:GetSoldier()
	end )
	return list, soldier
end

function City:FindHarassCityTargets( fn )
	local group = Asset_Get( self, CityAssetID.GROUP )
	return self:FilterAdjaCities( function ( adja )
		local adjaGroup = Asset_Get( adja, CityAssetID.GROUP )		
		if Dipl_IsAtWar( adjaGroup, group ) == false then return false end
		if fn( adja ) == false then return false end
		return true
	end )
end

function City:FindAttackCityTargets( fn )
	return self:FilterAdjaCities( function ( adja )		
		local adjaGroup = Asset_Get( adja, CityAssetID.GROUP )
		if adjaGroup == group then return false end
		if Dipl_IsAtWar( adjaGroup, group ) == false then return false end
		local adjaPower = Intel_GetMilPower( adja, self )	
		if fn( adja ) == false then return false end
		return true
	end )
end

function City:FindNearbyFriendCities()
	local group = Asset_Get( self, CityAssetID.GROUP )
	return self:FilterAdjaCities( function ( adja )		
		local adjaGroup = Asset_Get( adja, CityAssetID.GROUP )
		return adjaGroup == group
	end )
end

--------------------------------------------

function City:GetLimitPopuRatio( poputype )
	local cityparams = City_GetPopuParams( self )
	local limitparam  = cityparams.POPU_LIMIT_RATIO
	local popuname = MathUtil_FindName( CityPopu, poputype )
	local ratio = limitparam[popuname]
	return ratio or 0
end

--return maximum population of given population type
function City:GetLimitPopu( poputype )
	local ratio = self:GetLimitPopuRatio( poputype )
	return math.ceil( Asset_Get( self, CityAssetID.POPULATION ) * ratio )
end

--------------------------------------------
-- Chra relative

--character join into city, but no means he is there
function City:CharaJoin( chara )
	Asset_Set( chara, CharaAssetID.HOME, self )

	Asset_AppendList( self, CityAssetID.CHARA_LIST, chara )

	--Debug_Log( chara:ToString(), "join city=", self.name )
end

function City:CharaLeave( chara )
	Asset_Set( chara, CharaAssetID.HOME, nil )

	Asset_RemoveListItem( self, CityAssetID.CHARA_LIST, chara )

	Debug_Log( chara:ToString(), "leave city=", self.name )
end

--------------------------------------------
-- Corps relative

--corps join into city, but no means reach there
function City:AddCorps( corps )
	Asset_Set( corps, CorpsAssetID.ENCAMPMENT, self )
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

	--add from group
	local group = Asset_Get( self, CityAssetID.GROUP )
	if group then
		group:AddCorps( corps )
	end

	--Debug_Log( corps:ToString(), "join city=", self.name )
end

function City:RemoveCorps( corps )	
	Asset_Set( corps, CorpsAssetID.ENCAMPMENT, nil )

	Asset_RemoveListItem( self, CityAssetID.CORPS_LIST, corps )

	--remove charalist
	Asset_ForeachList( corps, CorpsAssetID.OFFICER_LIST, function ( chara )
		Asset_Set( chara, CharaAssetID.HOME, nil )
		Asset_RemoveListItem( self, CityAssetID.CHARA_LIST,   chara )
		Asset_RemoveListItem( self, CityAssetID.OFFICER_LIST, chara )
	end)

	local group = Asset_Get( self, CityAssetID.GROUP )
	if group then
		group:RemoveCorps( corps )
	end
end

--------------------------------------------
-- Character relative
function City:ElectExecutive()
	local executive = self:GetOfficer( CityJob.CHIEF_EXECUTIVE )
	if not executive then
		--find a leader from officer
		local charaList = Asset_GetList( self, CityAssetID.CHARA_LIST )
		executive = Chara_FindLeader( charaList )

		--executive = Random_GetListData( self, CityAssetID.CHARA_LIST )		
		--DBG_Trace( "city=" .. self.name .. " no executive, num_chara=" .. Asset_GetListSize( self, CityAssetID.CHARA_LIST ) )
		if executive then
			Asset_SetListItem( self, CityAssetID.OFFICER_LIST, CityJob.CHIEF_EXECUTIVE, executive )
			CRR_Tolerate( "city=" .. self.name .. " set default executive=" .. executive.name )
			--InputUtil_Pause( "select chief executive=" .. executive.name )
		end
	end
end

function City:AssignVacancyOfficer()
	if 1 then return end
	local posList = self:FindVacancyOfficerPositions()
	if #posList ~= 0 then
		local charaList = self:FindNonOfficerFreeCharas()
		if #charaList == 0 then return false end

		function FindSuitChara( pos, list )
			--no skill, todo
			return 1
		end

		for _, pos in ipairs( posList ) do
			local charaInx = FindSuitChara( pos, charaList )
			local chara = charaList[charaInx]
			self:SetOfficer( chara, pos )
			
			table.remove( charaList, charaInx )
			if #charaList == 0 then break end
		end
		--InputUtil_Pause( "assign vacancy")
		return
	end

	--find better one, todo
	--local numOfSlot = self:GetNumOfOfficerSlot()
	return
end

function City:SetOfficer( chara, position )
	local old = Asset_GetListItem( self, CityAssetID.OFFICER_LIST, position )
	if old then
		InputUtil_Pause( "Old Officer=" .. old.name )
	end
	Asset_SetListItem( self, CityAssetID.OFFICER_LIST, position, chara )
	Debug_Log( self.name, "Assign " .. chara.name .. "-->" .. MathUtil_FindName( CityJob, position ) )
end

--------------------------------------------

function City:Update()
	local day = g_Time:GetDay()

	--no executive? find one
	self:ElectExecutive()

	if day == 1 then self:AssignVacancyOfficer() end

	if day == 1 then Meeting_Hold( self ) end

	--print( self.name, "food=" .. Asset_Get( self, CityAssetID.FOOD ))

	if day == 1 then
		--Track_HistoryRecord( "soldier", { name = self.name, soldier = self:GetSoldier(), date = g_Time:GetDateValue() } )
		--Track_HistoryRecord( "reserves", { name = self.name, reserves = Asset_GetListItem( self, CityAssetID.POPU_STRUCTURE, CityPopu.RESERVES ), date = g_Time:GetDateValue() } )
		--Track_HistoryRecord( "dev", { name = self.name, agr = Asset_Get( self, CityAssetID.AGRICULTURE ), comm = Asset_Get( self, CityAssetID.COMMERCE ), prod = Asset_Get( self, CityAssetID.PRODUCTION ), date = g_Time:GetDateValue() } )
	end

	--cancel research
	if self:IsCapital() == false then
		Asset_Set( self, CityAssetID.RESEARCH, nil )
	end
end

--------------------------------------------

function City:GetSpy( city )
	local spy = Asset_FindListItem( self, CityAssetID.SPY_LIST, function( s )
		return s.city == city
	end )
	if not spy then
		spy =  { city = city, grade = CitySpyParams.INIT_GRADE, intel = 0 }
		Asset_AppendList( self, CityAssetID.SPY_LIST, spy )
	end
	return spy 
end

function City:LoseSpy( city, grade )
	spy = self:GetSpy( city )	
	if not grade then grade = -1 end
	spy.intel = math.ceil( spy.intel * 0.5 )
	spy.grade = MathUtil_Clamp( spy.grade - grade, CitySpyParams.INIT_GRADE, CitySpyParams.MAX_GRADE )
end

function City:Reconnoitre( city, intel )
	spy = self:GetSpy( city )
	spy.intel = spy.intel + intel
	if spy.intel > CitySpyParams.GRADE_INTEL[spy.grade] then
		spy.intel = 0
		spy.grade = MathUtil_Clamp( spy.grade + 1, CitySpyParams.INIT_GRADE, CitySpyParams.MAX_GRADE )
		--InputUtil_Pause( "gain intel", spy.grade, spy.city.name, self.name )
	end
end

function City:Sabotage()
	City_Pillage( self )
	--InputUtil_Pause( "sabotage" )
end

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

--------------------------------------------
