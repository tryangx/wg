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
	DISS = 221,	--p
	
	CHARA_LIST      = 300,
	OFFICER_LIST    = 301,	
	CORPS_LIST      = 302,
	CONSTR_LIST     = 303,
	PRISONER_LIST   = 304,
	SPY_LIST        = 305,

	GATES           = 311,	
	TROOPTABLE_LIST = 312,
	CONSTRTABLE_LIST = 313,

	--plan means plan-task i s exclusive, only one valid
	PLANS           = 321,
	RESEARCH        = 322,
}

CityAssetAttrib = 
{
	group      = AssetAttrib_SetPointer    ( { id = CityAssetID.GROUP,          type = CityAssetType.BASE_ATTRIB, setter = Entity_SetGroup } ),
	popu       = AssetAttrib_SetNumber     ( { id = CityAssetID.POPULATION,     type = CityAssetType.BASE_ATTRIB } ),
	popu_st    = AssetAttrib_SetDict       ( { id = CityAssetID.POPU_STRUCTURE, type = CityAssetType.BASE_ATTRIB } ),
	statuses   = AssetAttrib_SetDict       ( { id = CityAssetID.STATUSES,       type = CityAssetType.BASE_ATTRIB } ),
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
	
	food       = AssetAttrib_SetNumber( { id = CityAssetID.FOOD,            type = CityAssetType.GROWTH_ATTRIB, min = 0 } ),
	money      = AssetAttrib_SetNumber( { id = CityAssetID.MONEY,           type = CityAssetType.GROWTH_ATTRIB, min = 0 } ),
	material   = AssetAttrib_SetNumber( { id = CityAssetID.MATERIAL,        type = CityAssetType.GROWTH_ATTRIB } ),
	security   = AssetAttrib_SetNumber( { id = CityAssetID.SECURITY,        type = CityAssetType.GROWTH_ATTRIB,  min = 0, max = 100, default = 50 } ),	
	DISS = AssetAttrib_SetNumber( { id = CityAssetID.DISS,  type = CityAssetType.GROWTH_ATTRIB,  min = 0, max = 100, default = 50 } ),

	charas     = AssetAttrib_SetPointerList( { id = CityAssetID.CHARA_LIST,   type = CityAssetType.PROPERTY_ATTRIB, setter = Entity_SetChara } ),	
	officers   = AssetAttrib_SetPointerList( { id = CityAssetID.OFFICER_LIST, type = CityAssetType.PROPERTY_ATTRIB, setter = Entity_SetChara } ),
	corps      = AssetAttrib_SetPointerList( { id = CityAssetID.CORPS_LIST,   type = CityAssetType.PROPERTY_ATTRIB, setter = Entity_SetCorps } ),
	constrs    = AssetAttrib_SetPointerList( { id = CityAssetID.CONSTR_LIST,  type = CityAssetType.PROPERTY_ATTRIB, setter = Entity_SetConstruction } ),
	prisoner   = AssetAttrib_SetPointerList( { id = CityAssetID.PRISONER_LIST,type = CityAssetType.PROPERTY_ATTRIB, setter = Entity_SetChara } ),
	spys       = AssetAttrib_SetDict       ( { id = CityAssetID.SPY_LIST,     type = CityAssetType.PROPERTY_ATTRIB } ),

	defenses   = AssetAttrib_SetList  ( { id = CityAssetID.GATES,             type = CityAssetType.PROPERTY_ATTRIB } ),		
	trooptables  = AssetAttrib_SetPointerList( { id = CityAssetID.TROOPTABLE_LIST, type = CityAssetType.PROPERTY_ATTRIB, setter = Table_SetTroop } ),
	constrtables = AssetAttrib_SetList( { id = CityAssetID.CONSTRTABLE_LIST, type = CityAssetType.PROPERTY_ATTRIB } ),

	plans       = AssetAttrib_SetDict  ( { id = CityAssetID.PLANS,          type = CityAssetType.PROPERTY_ATTRIB } ),
	research    = AssetAttrib_SetData  ( { id = CityAssetID.RESEARCH,       type = CityAssetType.GROWTH_ATTRIB } ),
}

-------------------------------------------

City = class()

function City:__init( ... )
	Entity_Init( self, EntityType.CITY, CityAssetAttrib )
end

function City:Load( data )
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
	Asset_CopyList( self, CityAssetID.GATES,  data.gates )

	if not data.trooptables then
		Asset_CopyList( self, CityAssetID.TROOPTABLE_LIST, { 100, 200, 300 } )
	else
		Asset_CopyList( self, CityAssetID.TROOPTABLE_LIST, data.trooptables )
	end
end

function City:ToString( type )
	local content = "[" .. self.name .. "]"
	local group = Asset_Get( self, CityAssetID.GROUP )
	content = content .. "[" .. ( group and group.name or "" ) .. "]"

	if type == "SIMPLE" then
		content = content .. "(" .. Asset_Get( self, CityAssetID.CENTER_PLOT ):ToString() ..  ")"
	end
	if type == "CONSTRUCTION" then
		content = content .. " "
		Asset_Foreach( self, CityAssetID.CONSTR_LIST, function ( constr )
			content = content .. constr.name .. ","
		end)		
	end
	if type == "BRIEF" then
		content = content .. "(" .. Asset_Get( self, CityAssetID.CENTER_PLOT ):ToString() ..  ")"
		content = content .. " chars=" .. Asset_GetListSize( self, CityAssetID.CHARA_LIST )
		content = content .. " corps=" .. Asset_GetListSize( self, CityAssetID.CORPS_LIST )
		content = content .. " offr=" .. Asset_GetListSize( self, CityAssetID.OFFICER_LIST )
		content = content .. " cons=" .. Asset_GetListSize( self, CityAssetID.CONSTR_LIST )
		content = content .. " popu=" .. Asset_Get( self, CityAssetID.POPULATION )
		content = content .. " resv=" .. self:GetPopu( CityPopu.RESERVES )
	
	elseif type == "OFFICER" then
		content = content .. " chars=" .. Asset_GetListSize( self, CityAssetID.CHARA_LIST )
		content = content .. " ofi=" .. Asset_GetListSize( self, CityAssetID.OFFICER_LIST )
		Asset_Foreach( self, CityAssetID.OFFICER_LIST, function ( data )
			content = content .. " [" .. MathUtil_FindName( CityJob, data.job ) .. "]=" .. data.officer.name
		end )
	
	elseif type == "SUPPLY" then
		local food    = Asset_Get( self, CityAssetID.FOOD )
		local consume = self:GetConsumeFood()
		local supply  = self:GetSupplyFood()
		local money   = Asset_Get( self, CityAssetID.MONEY )
		local salary  = self:GetSalary()
		content = content .. " money=" .. money
		content = content .. "+" .. math.ceil( money / salary ) .. "M"
		content = content .. " food=" .. food
		--content = content .. "-" .. consume
		content = content .. "+" .. math.ceil( food / ( DAY_IN_MONTH * ( consume + supply ) ) ) .."M" .. "(" .. consume .. "+" .. supply .. ")"
		content = content .. " mat=" .. Asset_Get( self, CityAssetID.MATERIAL )

	elseif type == "CONSUME" then
		local consume = 0
		local popustparams = City_GetPopuParams( self )
		for type, _ in pairs( CityPopu ) do
			local value = popustparams.POPU_CONSUME_FOOD[type]
			if value then
				local num = Asset_GetDictItem( self, CityAssetID.POPU_STRUCTURE, CityPopu[type] )
				if num then
					consume = consume + num * value
					content = content .. " " .. type .. "=" .. num * value
				end				
			end
		end
		content = content .. " tot=" .. consume

	elseif type == "TAX" then
		content = content .. " person=" .. City_CalcPersonalTax( self )
		content = content .. " comm=" .. City_CalcCommerceTax( self )
		content = content .. " trade=" .. City_CalcTradeTax( self )
		content = content .. " salary=" .. self:GetSalary()

	elseif type == "BUDGET_YEAR" then
		local m_income_year = City_GetYearTax( self )
		local m_pay_year = self:GetSalary() * 12
		local f_income_year = City_GetFoodIncome( self )
		local f_pay_year = self:GetConsumeFood() * DAY_IN_YEAR
		local m_surplus = m_income_year - m_pay_year
		local f_surplus = f_income_year - f_pay_year
		content = content .. " money_budget=" .. m_surplus .. "+" .. math.ceil( m_surplus / self:GetSalary() ) .. "M"
		content = content .. " food_budget=" .. f_surplus .. "+" .. math.ceil( f_surplus / self:GetConsumeFood() ) .. "D"
		content = content .. " money_in_yr="  .. m_income_year
		content = content .. " money_out_yr=" .. m_pay_year
		content = content .. " food_in_yr="   .. f_income_year
		content = content .. " food_out_yr="  .. f_pay_year

	elseif type == "BUDGET_MONTH" then
		content = content .. " money_in="  .. City_GetMonthTax( self )
		content = content .. " money_out=" .. self:GetSalary()

	elseif type == "DEVELOP" then
		content = content .. " agri=" .. Asset_Get( self, CityAssetID.AGRICULTURE ) .. "/" .. Asset_Get( self, CityAssetID.MAX_AGRICULTURE )
		content = content .. " comm=" .. Asset_Get( self, CityAssetID.COMMERCE ) .. "/" .. Asset_Get( self, CityAssetID.MAX_COMMERCE )
		content = content .. " prod=" .. Asset_Get( self, CityAssetID.PRODUCTION ) .. "/" .. Asset_Get( self, CityAssetID.MAX_PRODUCTION )
		content = content .. " farmer=" .. self:GetPopu( CityPopu.FARMER ) .. "/" .. City_NeedPopu( self, "FARMER" ) 
		content = content .. " merchant=" .. self:GetPopu( CityPopu.MERCHANT ) .. "/" .. City_NeedPopu( self, "MERCHANT" )
		content = content .. " worker=" .. self:GetPopu( CityPopu.WORKER ) .. "/" .. City_NeedPopu( self, "WORKER" )

	elseif type == "ADJACENT" then
		Asset_Foreach( self, CityAssetID.ADJACENTS, function ( adjaCity )
			local group = Asset_Get( self, CityAssetID.GROUP )
			local adjaGroup = Asset_Get( adjaCity, CityAssetID.GROUP )
			content = content .. " " .. adjaCity.name .. "-" .. String_ToStr( adjaGroup, "name" )
			local rel = Dipl_GetRelation( group, adjaGroup )
			if rel then content = content .. " dip=" .. rel:ToString() end
		end )

	elseif type == "CORPS" then
		content = content .. " corps=" .. Asset_GetListSize( self, CityAssetID.CORPS_LIST )
		Asset_Foreach( self, CityAssetID.CORPS_LIST, function ( corps )
			content = content .. " " .. corps:ToString( "STATUS" ) .. "/"
		end )
	end


	if type == "CHARA" then-- or type == "ALL" then
		content = content .. " chars=" .. Asset_GetListSize( self, CityAssetID.CHARA_LIST )
		Asset_Foreach( self, CityAssetID.CHARA_LIST, function ( chara )
			content = content .. " " .. chara.name .. ","
		end )
	end

	if type == "STATUS" or type == "ALL" then
		Asset_Foreach( self, CityAssetID.STATUSES, function ( data, status )			
			if typeof( data ) == "boolean" then
				if data == true then
					content = content .. " " .. MathUtil_FindName( CityStatus, status )
					--content = content .. "=" .. ( data and "1" or "0" )
				end
			end
		end)
	end	
	
	if type == "MILITARY" or type == "ALL" then
		content = content .. " popu=" .. Asset_Get( self, CityAssetID.POPULATION )
		content = content .. " chars=" .. Asset_GetListSize( self, CityAssetID.CHARA_LIST )
		content = content .. " corps=" .. Asset_GetListSize( self, CityAssetID.CORPS_LIST )
		content = content .. " sldr=" .. self:GetSoldier()
		content = content .. " resv=" .. self:GetPopu( CityPopu.RESERVES )
		content = content .. " guard=" .. self:GetPopu( CityPopu.GUARD )
	end

	if type == "GROWTH" then-- or type == "ALL" then
		content = content .. " POPU=" .. Asset_Get( self, CityAssetID.POPULATION )
		content = content .. " agri=" .. Asset_Get( self, CityAssetID.AGRICULTURE ) .. "/" .. Asset_Get( self, CityAssetID.MAX_AGRICULTURE )
		content = content .. " comm=" .. Asset_Get( self, CityAssetID.COMMERCE ) .. "/" .. Asset_Get( self, CityAssetID.MAX_COMMERCE )
		content = content .. " prod=" .. Asset_Get( self, CityAssetID.PRODUCTION ) .. "/" .. Asset_Get( self, CityAssetID.MAX_PRODUCTION )
	end

	if type == "POPULATION" then-- or type == "ALL" then
		local total = Asset_Get( self, CityAssetID.POPULATION )
		content = content .. " POPU=" .. total
		Asset_Foreach( self, CityAssetID.POPU_STRUCTURE, function ( value, type )
			content = content .. " " .. MathUtil_FindName( CityPopu, type ) .. "=" .. value .. "+" .. math.ceil( value * 100 / total ) .."%"
		end )
	end
	return content
end

------------------------------------------

function City:TrackData( dump )
	Track_Pop( "track_city_" .. self.id )
	Track_Data( "total popu", Asset_Get( self, CityAssetID.POPULATION ) )
	Track_Data( "security", Asset_Get( self, CityAssetID.SECURITY ) )
	Track_Data( "DISS", Asset_Get( self, CityAssetID.DISS ) )

	Track_Data( "agri", Asset_Get( self, CityAssetID.AGRICULTURE ) )
	Track_Data( "prod", Asset_Get( self, CityAssetID.PRODUCTION ) )
	Track_Data( "comm", Asset_Get( self, CityAssetID.COMMERCE ) )

	for k, v  in pairs( CityPopu ) do
		Track_Data( k, Asset_GetDictItem( self, CityAssetID.POPU_STRUCTURE, v ), City_NeedPopu( self, k ) )
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

--[[
function City:DumpPopu()
	local popu = Asset_Get( self, CityAssetID.POPULATION )
	Asset_Foreach( self, CityAssetID.POPU_STRUCTURE, function ( value, type )
		local cur = value .. "(".. math.ceil( value * 100 / popu ) .."%)"
		local need = City_NeedPopu( self, MathUtil_FindName( CityPopu, type ) )
		local req = "->" .. need .. "("..math.ceil( value * 100 / need ) .. "%)"
		print( StringUtil_Abbreviate( MathUtil_FindName( CityPopu, type ), 8 ) .." = " .. cur .. " " .. req )
	end )
	--City_GetSupportPopu( self )
	print( StringUtil_Abbreviate( "POPU", 8 ) .. " = " .. Asset_Get( self, CityAssetID.POPULATION ) )
end
]]

function City:DumpPlots()
	Asset_Foreach( self, CityAssetID.PLOTS, function( plot )
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
	if group then
		Asset_Foreach( self, CityAssetID.ADJACENTS, function ( city )
			local grade = CitySpyParams.INIT_GRADE
			if Asset_Get( city, CityAssetID.GROUP ) == group then
				--print( "check", city.name, String_ToStr( group, "name" ), String_ToStr( Asset_Get( city, CityAssetID.GROUP ), "name" ) )
				grade = CitySpyParams.MAX_GRADE
			end
			Asset_SetDictItem( self, CityAssetID.SPY_LIST, city, self:CreateSpy( city, grade ) )
		end )
	end
	self:InitPlots()
	self:InitPopu()

	--keep minimum food
	Asset_Set( self, CityAssetID.FOOD, ( self:GetConsumeFood() + self:GetSupplyFood() ) * 360 )
end

function City:InitPlots()
	Asset_Foreach( self, CityAssetID.PLOTS, function( plot )
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

	Asset_Foreach( self, CityAssetID.CORPS_LIST, function( corps )
		Asset_Set( corps, CorpsAssetID.ENCAMPMENT, city )
		Asset_Set( corps, CorpsAssetID.LOCATION, city )
	end )

	Asset_Foreach( self, CityAssetID.CHARA_LIST, function( chara )
		Asset_Set( chara, CharaAssetID.HOME, city )
		Asset_Set( chara, CharaAssetID.LOCATION, city )
	end )

	Asset_VerifyList( self, CityAssetID.ADJACENTS )

	--verify adjacents
	Asset_Foreach( self, CityAssetID.ADJACENTS, function ( adjaCity )
		if not Asset_HasItem( adjaCity, CityAssetID.ADJACENTS, self ) then
			error( adjaCity.name .. " not connect to " .. self.name )
		end
	end)

	self:ElectExecutive()
end

-------------------------------------------
--getter

function City:GetPlan( plan )
	return Asset_GetDictItem( self, CityAssetID.PLANS, plan )
end

function City:SetPlan( plan, task )
	Asset_SetDictItem( self, CityAssetID.PLANS, plan, task )
end

function City:GetConstruction( id )
	return Asset_FindListItem( self, CityAssetID.CONSTR_LIST, function ( constr )
		if constr.id == id then return constr end
	end)
end

function City:GetStatus( status )
	return Asset_GetDictItem( self, CityAssetID.STATUSES, status )
end

function City:GetPopuValue( paramType, popuType )
	local sum = 0
	local popuparams = City_GetPopuParams( _city )
	for type, _ in pairs( CityPopu ) do
		if not popuType or popuType == type then
			local value = popuparams[paramType][type]
			if value then
				local num = Asset_GetDictItem( self, CityAssetID.POPU_STRUCTURE, CityPopu[type] )
				if num and num > 0 then
					sum = sum + value * num
				end
			end
		end
	end
	return math.ceil( sum )
end

function City:GetDevelopCost()
	return self:GetPopuValue( "POPU_DEVELOP_COST" )
end

function City:GetSalary()
	return self:GetPopuValue( "POPU_SALARY" )
end

function City:GetCorpsSalary()
	local salary = 0
	Asset_Foreach( self, CityAssetID.CORPS_LIST, function( corps )
		salary = salary + corps:GetSalary()
	end )
	return salary
end

--supply food for population in city
function City:GetConsumeFood()
	return self:GetPopuValue( "POPU_CONSUME_FOOD" )
end

--supply food for outside corps
function City:GetSupplyFood()
	local food = 0
	Asset_Foreach( self, CityAssetID.CORPS_LIST, function ( corps )
		if corps:IsAtHome() == false then
			food = food + corps:GetConsumeFood()
		end
	end )
	return food
end

function City:GetReqProperty()
	local req_money = self:GetSalary() * MONTH_IN_SEASON
	local req_food  = ( self:GetConsumeFood() + self:GetSupplyFood() ) * MONTH_IN_YEAR
	return req_food, req_money
end

function City:GetTransCapacity()
	local troopTable = TroopTable_Get( Scenario_GetData( "TROOP_PARAMS" ).TRANSPORT_ID )
	if not troopTable then
		return 0, 0, 0
	end
	local corvee     = self:GetPopu( CityPopu.CORVEE )
	return corvee * ( troopTable.capacity.FOOD or 0 ), ( corvee * troopTable.capacity.MONEY or 0 ), ( corvee * troopTable.capacity.MATERIAL or 0 )
end

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
function City:GetPopu( popuType )
	if not popuType or popuType == CityPopu.ALL then
		return Asset_Get( self, CityAssetID.POPULATION )
	end
	return Asset_GetDictItem( self, CityAssetID.POPU_STRUCTURE, popuType )
end

function City:SetPopu( popuType, number )
	Asset_SetDictItem( self, CityAssetID.POPU_STRUCTURE, popuType, number )
end
function City:AddPopu( popuType, number )
	local cur = self:GetPopu( popuType )
	Asset_SetDictItem( self, CityAssetID.POPU_STRUCTURE, popuType, cur + number )
end

--type from enum CityJob
function City:GetOfficer( job, index )
	if not index then index = 0 end
	local item = Asset_FindListItem( self, CityAssetID.OFFICER_LIST, function ( data )
		if data.job == job then
			if index == 0 then
				return true
			end
			index = index - 1
		end
	end)
	return item and item.officer
end

function City:GetNumberOfOfficer( job )
	local number = 0
	Asset_Foreach( self, CityAssetID.OFFICER_LIST, function ( data )
		if data.job == job then
			number = number + 1
		end
	end)
	return number
end

function City:GetCharaJob( chara )
	local findJob = CityJob.NONE
	Asset_FindListItem( self, CityAssetID.OFFICER_LIST, function ( data )		
		if data.officer == chara then
			--InputUtil_Pause( "checker", officer.name, chara.name, job )
			findJob = data.job
			return true
		end
	end )
	return findJob
end

--get reality number of soldier, dynamic
function City:GetSoldier()
	--corps in city
	local soldier = 0
	local maxSoldier = 0
	Asset_Foreach( self, CityAssetID.CORPS_LIST, function ( corps )
		Asset_Foreach( corps, CorpsAssetID.TROOP_LIST, function( troop )
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
	Asset_Foreach( self, CityAssetID.CORPS_LIST, function ( corps )
		Asset_Foreach( corps, CorpsAssetID.TROOP_LIST, function( troop )
			power = power + Asset_Get( troop, TroopAssetID.SOLDIER ) * TroopTable_GetPower( troop )
		end )
	end )

	--reserved

	return power
end

--return 100
function City:GetDevelopScore( devAssetId )
	function GetDevRatio( assetId )
		local cur, max
		if assetId == CityAssetID.AGRICULTURE then
			maxid = CityAssetID.MAX_AGRICULTURE
		elseif assetId == CityAssetID.COMMERCE then
			maxid = CityAssetID.MAX_COMMERCE
		elseif assetId == CityAssetID.PRODUCTION then
			maxid = CityAssetID.MAX_PRODUCTION
		end
		cur = Asset_Get( self, assetId )
		max = Asset_Get( self, maxid )
		return math.ceil( cur * 100 / max )
	end
	
	if not devAssetId then
		local agriScore = GetDevRatio( CityAssetID.AGRICULTURE ) 
		local commScore = GetDevRatio( CityAssetID.COMMERCE ) 
		local prodScore = GetDevRatio( CityAssetID.PRODUCTION ) 
		return agriScore + commScore + prodScore
	end

	return GetDevRatio( devAssetId )	
end

-------------------------------------------
--checker

function City:IsCapital()
	local group = Asset_Get( self, CityAssetID.GROUP )
	if not group then return false end
	return Asset_Get( group, GroupAssetID.CAPITAL ) == self
end

function City:IsAdjaCity( city )
	return Asset_FindDictItem( self, CityAssetID.ADJACENTS, function ( adjaCity )
		return adjaCity == city
	end )
end

function City:IsEnemeyCity( adjaCity )
	local adjaGroup = Asset_Get( adjaCity, CityAssetID.GROUP )
	if not adjaGroup then
		return true
	end
	local group = Asset_Get( self, CityAssetID.GROUP )
	return Dipl_IsAtWar( group, adjaGroup )
end

function City:IsCharaOfficer( type, chara )
	if not type or not chara then return false end
	local job = self:GetCharaJob( chara )
	return job == type
end

-------------------------------------------

function City:ReducePopu( popuType, number )
	local cur = Asset_GetDictItem( self, CityAssetID.POPU_STRUCTURE, popuType )
	if cur < number then return false end
	Asset_SetDictItem( self, CityAssetID.POPU_STRUCTURE, popuType, cur - number )
	Asset_Reduce( self, CityAssetID.POPULATION, number )

	Stat_Add( "ConvertPopu@" .. self.name .. "_" .. MathUtil_FindName( CityPopu, popuType ), number, StatType.ACCUMULATION )
end

-------------------------------------------

function City:FilterAdjaCities( filter )
	local list = {}	
	Asset_Foreach( self, CityAssetID.ADJACENTS, function ( adja )
		if filter( adja ) == true then
			table.insert( list, adja )
		end
	end)
	return list
end

function City:FilterOfficer( filter )
	local list = {}
	Asset_Foreach( self, CityAssetID.OFFICER_LIST, function ( data )
		if filter( data.officer, data.job ) == true then
			table.insert( list, chara )
		end
	end)
	return list
end

function City:GetNumOfFreeCorps()
	--has corps
	local freeCorps = 0
	Asset_Foreach( self, CityAssetID.CORPS_LIST, function ( corps )
		if Asset_Get( corps, CorpsAssetID.LOCATION ) == Asset_Get( corps, CorpsAssetID.ENCAMPMENT ) then
			local ret = corps:GetTask()
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
function City:FindFreeCharas( fn )
	local charaList = {}
	Asset_Foreach( self, CityAssetID.CHARA_LIST, function( chara )
		if chara:IsAtHome() == false then
			--Debug_Log( chara.name, "no at home" )
			return
		end
		if chara:IsBusy() == true then
			--Debug_Log( chara.name, "busy" )
			return						
		end
		if fn and not fn( chara ) then return end
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
	local endPos = CityJob.POSITION_BEGIN + self:GetNumOfOfficerSlot() - 1
	for job = CityJob.POSITION_BEGIN + 1, endPos do
		local officer = self:GetOfficer( job )
		if not officer then
			--print( "add pos", MathUtil_FindName( CityJob, job ) )
			if job == CityJob.CAPITAL_POSITION_END then error( "wrong" .. endPos ) end
			table.insert( posList, job )
		end
	end
	return posList
end

--return list of characters not chara in any officer position
function City:FindNonOfficerFreeCharas( charaList )
	if not charaList then charaList = {} end
	Asset_Foreach( self, CityAssetID.CHARA_LIST, function( chara )
		if chara:IsAtHome() == false then return end
		if chara:IsBusy() == true then return end
		if Asset_Get( chara, CharaAssetID.CORPS ) then return end
		if self:GetCharaJob( chara ) ~= CityJob.NONE then return end
		table.insert( charaList, chara )
	end )
	return charaList
end

function City:GetDefendCorps()
	local list = {}
	Asset_Foreach( self, CityAssetID.CORPS_LIST, function ( corps )
		if corps:IsAtHome() == false then return end
		table.insert( list, corps )
	end )
	return list
end

--corps should at home
--corps should out of task
--corps should has a leader
function City:GetFreeCorps( fn )
	local list = {}
	local soldier = 0
	local power = 0
	Asset_Foreach( self, CityAssetID.CORPS_LIST, function ( corps )
		if corps:IsAtHome() == false then return end
		if corps:IsBusy() == true then return end
		local leader = Asset_Get( corps, CorpsAssetID.LEADER )
		if leader then
			if leader:IsBusy() then return end
		else
			--InputUtil_Pause( "no leader, not free corps" )
		end
		if fn and not fn( corps ) then
			return
		end
		table.insert( list, corps )
		soldier = soldier + corps:GetSoldier()
	end )
	return list, soldier
end

function City:GetMilitaryCorps( understaffed )
	if not understaffed then understaffed = 20 end
	return self:GetFreeCorps( function ( corps )
		if not Asset_Get( corps, CorpsAssetID.LEADER ) then
			return false
		end
		return corps:GetStatus( CorpsStatus.UNDERSTAFFED ) < understaffed
	end)
end

function City:FindNearbyFriendCities()
	local group = Asset_Get( self, CityAssetID.GROUP )
	return self:FilterAdjaCities( function ( adja )		
		local adjaGroup = Asset_Get( adja, CityAssetID.GROUP )
		return adjaGroup == group
	end )
end

--find enemy( at war ) cities adjacent
function City:FindNearbyEnemyCities()
	local group = Asset_Get( self, CityAssetID.GROUP )
	return self:FilterAdjaCities( function ( adja )
		local adjaGroup = Asset_Get( adja, CityAssetID.GROUP )
		if group then
			return Dipl_IsAtWar( group, adjaGroup )
		end
		return Dipl_IsAtWar( adjaGroup, group )
	end )
end

--------------------------------------------

function City:GetLimitPopuRatio( popuType )
	local cityparams = City_GetPopuParams( self )
	local needparams = cityparams.POPU_NEED_RATIO
	local popuname = MathUtil_FindName( CityPopu, popuType )
	local ratio = needparams[popuname].limit
	return ratio or 0
end

--return maximum population of given population type
function City:GetLimitPopu( popuType )
	local ratio = self:GetLimitPopuRatio( popuType )	
	return math.ceil( Asset_Get( self, CityAssetID.POPULATION ) * ratio )
end

function City:GetReqPopuRatio( popuType )
	local cityparams = City_GetPopuParams( self )
	local needparams = cityparams.POPU_NEED_RATIO
	local popuname = MathUtil_FindName( CityPopu, popuType )
	local ratio = needparams[popuname].req
	return ratio or 0
end

function City:GetReqPopu( popuType )
	local ratio = self:GetReqPopuRatio( popuType )
	return math.ceil( Asset_Get( self, CityAssetID.POPULATION ) * ratio )
end

--------------------------------------------
-- Chra relative

--character join into city, but no means he is there
function City:CharaJoin( chara )
	--debug
	if chara:GetStatus( CharaStatus.DEAD ) then
		DBG_Error( "why dead man", chara.name )
		return
	end

	Asset_Set( chara, CharaAssetID.HOME, self )

	Asset_AppendList( self, CityAssetID.CHARA_LIST, chara )
	
	Debug_Log( chara:ToString(), "join city=", self.name, Asset_GetListSize( self, CityAssetID.CHARA_LIST ) )
end

function City:CharaLeave( chara )
	Asset_Set( chara, CharaAssetID.HOME, nil )

	Asset_RemoveListItem( self, CityAssetID.CHARA_LIST, chara )

	self:RemoveOfficer( chara )

	Debug_Log( chara:ToString(), "leave city=" .. self:ToString() )
end

--------------------------------------------
-- Corps relative

--corps join into city, but no means reach there
function City:AddCorps( corps )
	Asset_Set( corps, CorpsAssetID.ENCAMPMENT, self )

	--insert trooplist
	Asset_AppendList( self, CityAssetID.CORPS_LIST, corps )

	--insert charalist
	Asset_Foreach( corps, CorpsAssetID.OFFICER_LIST, function ( chara )
		Asset_AppendList( self, CityAssetID.CHARA_LIST, chara )
	end)

	--add from group
	local group = Asset_Get( self, CityAssetID.GROUP )
	if group then
		group:AddCorps( corps )
	end

	Debug_Log( corps:ToString(), "garrison city=" .. self.name )
end

function City:RemoveCorps( corps )	
	Asset_Set( corps, CorpsAssetID.ENCAMPMENT, nil )

	Asset_RemoveListItem( self, CityAssetID.CORPS_LIST, corps )

	--remove charalist
	Asset_Foreach( corps, CorpsAssetID.OFFICER_LIST, function ( chara )
		Asset_Set( chara, CharaAssetID.HOME, nil )
		Asset_RemoveListItem( self, CityAssetID.CHARA_LIST,   chara )
		Asset_RemoveListItem( self, CityAssetID.OFFICER_LIST, chara, "officer" )
	end)
end

--------------------------------------------
-- Character relative
function City:ElectExecutive()
	local executive = self:GetOfficer( CityJob.EXECUTIVE )
	if not executive then
		--find a leader from officer
		local charaList = Asset_GetList( self, CityAssetID.CHARA_LIST )
		executive = Chara_FindLeader( charaList )

		--executive = Random_GetListData( self, CityAssetID.CHARA_LIST )		
		--DBG_Trace( "city=" .. self.name .. " no executive, num_chara=" .. Asset_GetListSize( self, CityAssetID.CHARA_LIST ) )
		if executive then
			self:SetOfficer( executive, CityJob.EXECUTIVE )
			CRR_Tolerate( "city=" .. self.name .. " set default executive=" .. executive.name )
			--InputUtil_Pause( "select chief executive=" .. executive.name )
		end
	end
end

function City:AssignOfficer()
	local jobList = self:FindVacancyOfficerPositions()
	if #jobList == 0 then
		return
	end
	local charaList = self:FindNonOfficerFreeCharas()
	if #charaList == 0 then
		return
	end

	--print( self:ToString("OFFICER"),  #charaList, #jobList )

	--fill vacancy position
	local vacancies = #charaList - #jobList
	while vacancies > 0 do
		local job = City_GetNextJob( self )
		table.insert( jobList, job )
		vacancies = vacancies - 1
		--print( "add ", MathUtil_FindName( CityJob, job ), job )
	end

	local jobIndex = 1
	while #charaList > 0 do
		local job = jobList[jobIndex]
		jobIndex = jobIndex + 1
		local chara = Chara_FindBestCharaForJob( job, charaList )
		self:SetOfficer( chara, job )
		--print( "setofficer", chara.name, MathUtil_FindName( CityJob, job ) )
	end
end

--exclude executive
function City:RemoveOfficer( chara )
	local job = self:GetCharaJob( chara )
	if job == CityJob.NONE then	return end
	Debug_Log( "remove job=" .. MathUtil_FindName( CityJob, job ), chara:ToString( "STATUS")  )
	Asset_RemoveListItem( self, CityAssetID.OFFICER_LIST, chara, "officer" )end

function City:ClearOfficer()
	local executive = self:GetOfficer( CityJob.EXECUTIVE )
	Asset_Clear( self, CityAssetID.OFFICER_LIST )
	self:SetOfficer( executive, CityJob.EXECUTIVE )
end

function City:SetOfficer( chara, job )
	if not chara then return end

	local oldJob = self:GetCharaJob( chara )
	if oldJob ~= CityJob.NONE then
		error( chara.name .. " already has a job" )
	end

	Asset_AppendList( self, CityAssetID.OFFICER_LIST, { officer = chara, job = job } )	
	Debug_Log( self.name, "Assign " .. chara.name .. "-->" .. MathUtil_FindName( CityJob, job ) )
	Stat_Add( "SetOfficer@" .. self.name, 1, StatType.TIMES )

	--InputUtil_Pause( "set officer", chara.name, MathUtil_FindName( CityJob, job ) )
end

--------------------------------------------

function City:UpdatePopu( ... )
	--only calculate soldier in the city
	local soldier = 0
	Asset_Foreach( self, CityAssetID.CORPS_LIST, function ( corps )
		if corps:IsAtHome() then
			soldier = soldier + corps:GetSoldier()
		end
	end)
	Asset_SetDictItem( self, CityAssetID.POPU_STRUCTURE, CityPopu.SOLDIER, soldier )
end

function City:UpdateConstrList()
	Asset_Clear( self, CityAssetID.CONSTRTABLE_LIST )

	local constrList = {}
	local constrDatas = Scenario_GetData( "CITY_CONSTR_DATA" )
	for id, constr in pairs( constrDatas ) do
		local match = true
		if constr.prerequsite then
			for cond, value in pairs( constr.prerequsite ) do
				if cond.city_lv and cond.city_lv > Asset_Get( self, CityAssetID.LEVEL ) then match = false end
				if cond.has_constr and self:GetConstruction( cond.constr ) == nil then match = false end
				if cond.singleton and self:GetConstruction( id ) then match = false end
			end
		end
		if match then
			table.insert( constrList, constr )
		end
	end
	Asset_SetList( self, CityAssetID.CONSTRTABLE_LIST, constrList )
end

function City:Update()
	local month = g_Time:GetMonth()
	local day = g_Time:GetDay()

	--no executive? find one
	if day == 1 then
		self:ElectExecutive()
	end
	
	if day == 1 then
		--dismiss
		if month == 1 then self:ClearOfficer() end
		self:AssignOfficer()
	end

	--print( self.name, "food=" .. Asset_Get( self, CityAssetID.FOOD ))

	if day == 1 then
		--Track_HistoryRecord( "soldier", { name = self.name, soldier = self:GetSoldier(), date = g_Time:GetDateValue() } )
		--Track_HistoryRecord( "reserves", { name = self.name, reserves = Asset_GetDictItem( self, CityAssetID.POPU_STRUCTURE, CityPopu.RESERVES ), date = g_Time:GetDateValue() } )
		--Track_HistoryRecord( "dev", { name = self.name, agr = Asset_Get( self, CityAssetID.AGRICULTURE ), comm = Asset_Get( self, CityAssetID.COMMERCE ), prod = Asset_Get( self, CityAssetID.PRODUCTION ), date = g_Time:GetDateValue() } )
	end

	if day == 1 then
		self:UpdatePopu()
	end

	if day == DAY_IN_MONTH then
		self:UpdateConstrList()
	end

	--cancel research
	if self:IsCapital() == false then
		Asset_Set( self, CityAssetID.RESEARCH, nil )
	end
end

--------------------------------------------

function City:CreateSpy( city, grade )
	return { sour = self, city = city, grade = grade, intel = 0 }
end

function City:GetSpy( city )
	if city == self then
		k.p = 1
	end
	local spy = Asset_FindDictItem( self, CityAssetID.SPY_LIST, function( s )
		return s.city == city
	end )
	if not spy then
		spy = self:CreateSpy( city, CitySpyParams.INIT_GRADE )
		Asset_SetDictItem( self, CityAssetID.SPY_LIST, city, spy )
	end
	return spy
end

--execute an op will lose spy
function City:LoseSpy( city, grade )
	spy = self:GetSpy( city )	
	if not grade then grade = -1 end
	spy.intel = math.ceil( spy.intel * 0.5 )
	spy.grade = MathUtil_Clamp( spy.grade - grade, CitySpyParams.INIT_GRADE, CitySpyParams.MAX_GRADE )

	Stat_Add( "LoseSpy@" .. city.name, 1, StatType.TIMES )
end

function City:Reconnoitre( city, intel )
	spy = self:GetSpy( city )
	spy.intel = spy.intel + intel
	local maxIntel = CitySpyParams.GRADE_INTEL[spy.grade]
	if not maxIntel then return end
	if spy.intel > maxIntel then
		spy.intel = 0
		spy.grade = MathUtil_Clamp( spy.grade + 1, CitySpyParams.INIT_GRADE, CitySpyParams.MAX_GRADE )
		Stat_Add( "Reconnoitre@" .. city.name, 1, StatType.TIMES )
	end
end

function City:Sabotage()
	City_Pillage( self )
	--InputUtil_Pause( "sabotage" )

	Asset_SetDictItem( self, CityAssetID.STATUSES, CityStatus.VIGILANT, DAY_IN_SEASON )	
end

function City:UseMoney( money, comment )
	Asset_Reduce( self, CityAssetID.MONEY, money )
	--print( self.name .. " use money for=", comment )
end

function City:ReceiveMoney( money )
	Asset_Plus( self, CityAssetID.MONEY, money )
	--[[
	print( self:ToString( "GROWTH" ) )
	print( self:ToString( "POPULATION" ) )
	print( self:ToString( "TAX" ) )	
	InputUtil_Pause( "City=" .. self.name .. " collect tax=" .. money .. " Money=" .. Asset_Get( self, CityAssetID.MONEY ) )
	--]]
end

function City:Starve()
	local cur = Asset_GetDictItem( self, CityAssetID.STATUSES, CityStatus.STARVATION )
	if not cur then cur = 1 end
	Asset_SetDictItem( self, CityAssetID.STATUSES, CityStatus.STARVATION, math.ceil( cur * 1.5 ) )

	Stat_Add( "Starve@" .. self.name, 1, StatType.TIMES )
end

function City:EatFood()
	local value = Asset_GetDictItem( self, CityAssetID.STATUSES, CityStatus.STARVATION )
	if not value or value == 0 then return end
	Asset_SetDictItem( self, CityAssetID.STATUSES, CityStatus.STARVATION, math.floor( value * 0.5 ) )

	Stat_Add( "EatFood@" .. self.name, 1, StatType.TIMES )
end

function City:ConsumeFood( food )
	local hasFood = Asset_Get( self, CityAssetID.FOOD )
	if hasFood >= food then		
		self:EatFood()
	else
		self:Starve()
		food = hasFood
	end
	Stat_Add( "Food@Eat" .. self.name, food, StatType.ACCUMULATION )

	hasFood = hasFood - food
	Asset_Set( self, CityAssetID.FOOD, hasFood )

	--Stat_Add( "FoodConsume@" .. self.name,  g_Time:CreateCurrentDateDesc() .. " " .. hasFood .. "-" .. food, StatType.LIST )	
end

function City:ReceiveFood( food )
	Asset_Plus( self, CityAssetID.FOOD, food )	
	--[[
	print( self:ToString( "GROWTH" ) )
	print( self:ToString( "SUPPLY" ) )
	print( self:ToString( "POPULATION" ) )
	print( self:ToString( "CONSUME" ) )	
	InputUtil_Pause( g_Time:CreateCurrentDateDesc() .. " City=" .. self.name .. " harvest food=" .. food .. " Food=" .. Asset_Get( self, CityAssetID.FOOD ) )
	--]]
end

function City:ReceiveMaterial( material )
	Asset_Plus( self, CityAssetID.MATERIAL, material )
end

function City:UseMaterial( material )
	Asset_Reduce( self, CityAssetID.MATERIAL, material )
end

function City:SetStatus( status, value )
	Asset_SetDictItem( self, CityAssetID.STATUSES, status, value )
end