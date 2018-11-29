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
	DISS            = 221,	--p
	
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
	centerplot = AssetAttrib_SetPointer    ( { id = CityAssetID.CENTER_PLOT,    type = CityAssetType.BASE_ATTRIB } ),
	plots      = AssetAttrib_SetPointerList( { id = CityAssetID.PLOTS,          type = CityAssetType.BASE_ATTRIB, setter = Entity_SetPlot } ),
	adjacents  = AssetAttrib_SetPointerList( { id = CityAssetID.ADJACENTS,      type = CityAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	
	level      = AssetAttrib_SetNumber( { id = CityAssetID.LEVEL,           type = CityAssetType.GROWTH_ATTRIB, min = 0, max = 20 } ),
	agri       = AssetAttrib_SetNumber( { id = CityAssetID.AGRICULTURE,     type = CityAssetType.GROWTH_ATTRIB, min = 0, max = 9999 } ),
	maxAgri    = AssetAttrib_SetNumber( { id = CityAssetID.MAX_AGRICULTURE, type = CityAssetType.GROWTH_ATTRIB, min = 0, max = 9999 } ),
	comm       = AssetAttrib_SetNumber( { id = CityAssetID.COMMERCE,        type = CityAssetType.GROWTH_ATTRIB, min = 0, max = 9999 } ),
	maxComm    = AssetAttrib_SetNumber( { id = CityAssetID.MAX_COMMERCE,    type = CityAssetType.GROWTH_ATTRIB, min = 0, max = 9999 } ),
	prod       = AssetAttrib_SetNumber( { id = CityAssetID.PRODUCTION,      type = CityAssetType.GROWTH_ATTRIB, min = 0, max = 9999 } ),
	maxProd    = AssetAttrib_SetNumber( { id = CityAssetID.MAX_PRODUCTION,  type = CityAssetType.GROWTH_ATTRIB, min = 0, max = 9999 } ),
	
	food       = AssetAttrib_SetNumber( { id = CityAssetID.FOOD,            type = CityAssetType.GROWTH_ATTRIB, min = 0, setter = watch_food } ),
	money      = AssetAttrib_SetNumber( { id = CityAssetID.MONEY,           type = CityAssetType.GROWTH_ATTRIB, min = 0 } ),
	material   = AssetAttrib_SetNumber( { id = CityAssetID.MATERIAL,        type = CityAssetType.GROWTH_ATTRIB } ),

	security   = AssetAttrib_SetDict  ( { id = CityAssetID.SECURITY,        type = CityAssetType.GROWTH_ATTRIB,  } ),	
	diss       = AssetAttrib_SetDict  ( { id = CityAssetID.DISS,            type = CityAssetType.GROWTH_ATTRIB,  } ),

	charas     = AssetAttrib_SetPointerList( { id = CityAssetID.CHARA_LIST,   type = CityAssetType.PROPERTY_ATTRIB, setter = Entity_SetChara } ),	
	officers   = AssetAttrib_SetPointerList( { id = CityAssetID.OFFICER_LIST, type = CityAssetType.PROPERTY_ATTRIB } ),
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

	if type == "PLOTS" then
		content = content .. " lv=" .. Asset_Get( self, CityAssetID.LEVEL )		
		Asset_Foreach( self, CityAssetID.PLOTS, function ( plot )
			content = content .. plot:ToString() .. ","
		end)
		content = content .. " plot=" .. Asset_GetDictSize( self, CityAssetID.PLOTS )
	end

	if type == "SIMPLE" then
		content = content .. "(" .. Asset_Get( self, CityAssetID.CENTER_PLOT ):ToString() ..  ")"
	end
	if type == "CONSTRUCTION" then
		content = content .. " "
		Asset_Foreach( self, CityAssetID.CONSTR_LIST, function ( constr )
			content = content .. constr.name .. ","
		end)		
	end
	if type == "OFFICER" then
		content = content .. " chars=" .. Asset_GetListSize( self, CityAssetID.CHARA_LIST )
		content = content .. " ofi=" .. Asset_GetListSize( self, CityAssetID.OFFICER_LIST )
		Asset_Foreach( self, CityAssetID.OFFICER_LIST, function ( data )
			content = content .. " [" .. MathUtil_FindName( CityJob, data.job ) .. "]=" .. data.officer.name
		end )

	elseif type == "ASSET" or type == "ALL" then
		content = content .. " food=" .. HelperUtil_CreateNumberDesc( Asset_Get( self, CityAssetID.FOOD ) )
		content = content .. " consume=" .. HelperUtil_CreateNumberDesc( self:GetConsumeFood() * DAY_IN_YEAR )
		content = content .. " harvest=" .. HelperUtil_CreateNumberDesc( City_GetFoodIncome( self ) )
		content = content .. " money=" .. HelperUtil_CreateNumberDesc( Asset_Get( self, CityAssetID.MONEY ) )		
		content = content .. " salary=" .. HelperUtil_CreateNumberDesc( self:GetSalary() * MONTH_IN_YEAR )
		content = content .. " income=" .. HelperUtil_CreateNumberDesc( City_GetYearTax( self ) )
		content = content .. " more_sol=" .. self:GetPotentialMilitary()
	
	--[[
	elseif type == "SUPPLY" then
		local food    = Asset_Get( self, CityAssetID.FOOD )
		local consume = self:GetConsumeFood()
		local money   = Asset_Get( self, CityAssetID.MONEY )
		local salary  = self:GetSalary()
		content = content .. " money=" .. money
		if true then
			content = content .. "+" .. math.ceil( money / salary ) .. "M"
		else
			content = content .. "+" .. math.ceil( money / salary * MONTH_IN_YEAR ) .. "P"
		end
		content = content .. " food=" .. food
		--content = content .. "-" .. consume
		if false and consume > 0 then
			content = content .. "+" .. math.ceil( food / ( DAY_IN_MONTH * ( consume ) ) ) .."M" .. "(" .. consume .. ")"
		else
			content = content .. "+" .. math.ceil( food / DAY_IN_YEAR ) .."P"
		end
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
		content = content .. " consume=" .. consume * DAY_IN_YEAR

	elseif type == "TAX" then
		content = content .. " person=" .. City_CalcPersonalTax( self )
		content = content .. " comm=" .. City_CalcCommerceTax( self )
		content = content .. " trade=" .. City_CalcTradeTax( self )
		content = content .. " salary=" .. self:GetSalary()

	elseif type == "BUDGET_YEAR" then
		local m_income_year = City_GetYearTax( self )		
		local f_income_year = City_GetFoodIncome( self )
		local m_pay_year = self:GetSalary() * 12
		local f_pay_year = self:GetConsumeFood() * DAY_IN_YEAR
		local m_surplus = m_income_year - m_pay_year
		local f_surplus = f_income_year - f_pay_year
		--content = content .. " money_budget=" .. m_surplus .. "+" .. math.ceil( m_surplus / self:GetSalary() ) .. "M"
		--content = content .. " food_budget=" .. f_surplus .. "+" .. math.ceil( f_surplus / self:GetConsumeFood() ) .. "D"
		content = content .. " money_in_yr="  .. HelperUtil_CreateNumberDesc( m_income_year )
		content = content .. " money_out_yr=" .. HelperUtil_CreateNumberDesc( m_pay_year )
		content = content .. " food_in_yr="   .. HelperUtil_CreateNumberDesc( f_income_year )
		content = content .. " food_out_yr="  .. HelperUtil_CreateNumberDesc( f_pay_year )

	elseif type == "BUDGET_MONTH" then
		content = content .. " money_in="  .. City_GetMonthTax( self )
		content = content .. " money_out=" .. self:GetSalary()
]]
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

	if type == "ALL" then
		--content = content .. "(" .. Asset_Get( self, CityAssetID.CENTER_PLOT ):ToString() ..  ")"
		content = content .. " chars=" .. Asset_GetListSize( self, CityAssetID.CHARA_LIST )
		content = content .. " corps=" .. Asset_GetListSize( self, CityAssetID.CORPS_LIST )
		content = content .. " offr=" .. Asset_GetListSize( self, CityAssetID.OFFICER_LIST )
		content = content .. " cons=" .. Asset_GetListSize( self, CityAssetID.CONSTR_LIST )
		content = content .. " popu=" .. Asset_Get( self, CityAssetID.POPULATION )
		content = content .. " secu=" .. MathUtil_Sum( Asset_GetDict( self, CityAssetID.SECURITY ) )
		content = content .. " diss=" .. MathUtil_Sum( Asset_GetDict( self, CityAssetID.DISS ) )
	end
	
	if type == "MILITARY" or type == "ALL" then
		content = content .. " popu="  .. Asset_Get( self, CityAssetID.POPULATION )
		content = content .. " sldr="  .. self:GetSoldier()
		content = content .. " resv="  .. self:GetPopu( CityPopu.RESERVES )
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
		content = content .. " POPU=" .. HelperUtil_CreateNumberDesc( total )
		Asset_Foreach( self, CityAssetID.POPU_STRUCTURE, function ( value, type )
			content = content .. " " .. MathUtil_FindName( CityPopu, type ) .. "=" .. HelperUtil_CreateNumberDesc( value ) .. "+" .. math.ceil( value * 100 / total ) .."%"
		end )
	end	

	if type == "STATUS" or type == "ALL" then
		Asset_Foreach( self, CityAssetID.STATUSES, function ( data, status )
			if typeof( data ) == "boolean" then
				if data == true then
					content = content .. " " .. MathUtil_FindName( CityStatus, status )
					--content = content .. "=" .. ( data and "1" or "0" )
				end
			else
				content = content .. " " .. MathUtil_FindName( CityStatus, status )
				content = content .. "=" .. data
			end
		end)		
	end	
	return content
end

------------------------------------------

function City:TrackData( dump )
	Track_Pop( "track_city_" .. self.id )
	Track_Data( "total popu", Asset_Get( self, CityAssetID.POPULATION ) )

	Track_Data( "agri", Asset_Get( self, CityAssetID.AGRICULTURE ) )
	Track_Data( "prod", Asset_Get( self, CityAssetID.PRODUCTION ) )
	Track_Data( "comm", Asset_Get( self, CityAssetID.COMMERCE ) )

	Track_Data( "money", Asset_Get( self, CityAssetID.MONEY ) )
	Track_Data( "food", Asset_Get( self, CityAssetID.FOOD ) )

	--for k, v  in pairs( CityPopu ) do Track_Data( k, Asset_GetDictItem( self, CityAssetID.POPU_STRUCTURE, v ), City_NeedPopu( self, k ) ) end
	
	if dump then
		Track_Dump("track_city_" .. self.id)
		Track_Reset()
	end
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
	
	self:UpdatePlots()

	self:InitPopu()

	--keep minimum food
	Asset_Set( self, CityAssetID.FOOD, self:GetConsumeFood() * 360 )

	--!!!we can check the city data here
	--InputUtil_Pause( self:ToString( 'CONSTRUCTION'), Asset_GetListSize( self, CityAssetID.CONSTR_LIST ) )
end

function City:UpdatePlots()
	local nums = {}
	function AddToNums( id, num )
		if not nums[id] then nums[id] = 0 end
		nums[id] = nums[id] + num
	end
	Asset_Foreach( self, CityAssetID.PLOTS, function( plot )		
		AddToNums( CityAssetID.POPULATION,      Asset_Get( plot, PlotAssetID.POPULATION ) )
		AddToNums( CityAssetID.AGRICULTURE,     Asset_Get( plot, PlotAssetID.AGRICULTURE ) )
		AddToNums( CityAssetID.MAX_AGRICULTURE, Asset_Get( plot, PlotAssetID.MAX_AGRICULTURE ) )
		AddToNums( CityAssetID.COMMERCE,        Asset_Get( plot, PlotAssetID.COMMERCE ) )
		AddToNums( CityAssetID.MAX_COMMERCE,    Asset_Get( plot, PlotAssetID.MAX_COMMERCE ) )
		AddToNums( CityAssetID.PRODUCTION,      Asset_Get( plot, PlotAssetID.PRODUCTION ) )
		AddToNums( CityAssetID.MAX_PRODUCTION,  Asset_Get( plot, PlotAssetID.MAX_PRODUCTION ) )
	end )
	for id, v in pairs( nums ) do
		Asset_Set( self, id, v )
	end
end

function City:InitPopu()
	City_DividePopuStructure( self )
end

function City:VerifyData()
	local city = self

	--print( self.name, "popu=" .. Asset_Get( self, CityAssetID.POPULATION ) )

	Asset_Foreach( self, CityAssetID.CORPS_LIST, function( corps )
		Asset_Set( corps, CorpsAssetID.ENCAMPMENT, city )
		Asset_Set( corps, CorpsAssetID.LOCATION, city )
	end )

	Asset_Foreach( self, CityAssetID.CHARA_LIST, function( chara )
		chara:JoinCity( city, true )
	end )

	Asset_VerifyList( self, CityAssetID.ADJACENTS )

	--verify adjacents
	Asset_Foreach( self, CityAssetID.ADJACENTS, function ( adjaCity )
		if not Asset_HasItem( adjaCity, CityAssetID.ADJACENTS, self ) then
			DBG_Trace( "data-verify", adjaCity.name .. " not connect to " .. self.name )
		end
	end)

	self:ElectExecutive()
end

-------------------------------------------
--getter

function City:GetExpandDuration()
	local level = Asset_Get( self, CityAssetID.LEVEL )
	return CityParams.ISOLATE_DURATION_MODULUS * level * level
end

function City:GetSecurity()
	local dict = Asset_GetDict( self, CityAssetID.SECURITY )
	return MathUtil_Sum( dict )
end

function City:GetDiss()
	return MathUtil_Sum( Asset_GetDict( self, CityAssetID.DISS ) )
end

--calculate how many guard/reserves/soldier can support in this city
function City:GetPotentialMilitary()
	local eat     = ( City_GetPopuParams( self ).POPU_CONSUME_FOOD.SOLDIER ) * DAY_IN_YEAR
	local salary  = ( City_GetPopuParams( self ).POPU_SALARY.SOLDIER ) * MONTH_IN_YEAR
	local money   = Asset_Get( self, CityAssetID.MONEY )
	local food    = Asset_Get( self, CityAssetID.FOOD )
	money = 0
	food  = 0
	local harvest = City_GetFoodIncome( self )
	local income  = City_GetYearTax( self )
	local num1 = math.floor( ( money + income ) / salary )
	local num2 = math.floor( ( food + harvest ) / eat )
	--print( "num=" .. num1 .. "," .. num2 .. " harvest=" .. harvest, "eat=" .. eat * num2 )
	return math.min( num1, num2 )
end

function City:GetPlan( plan )
	return Asset_GetDictItem( self, CityAssetID.PLANS, plan )
end

function City:SetPlan( plan, task )
	Asset_SetDictItem( self, CityAssetID.PLANS, plan, task )
end

function City:GetConstruction( id )
	return Asset_FindItem( self, CityAssetID.CONSTR_LIST, function ( constr )
		if constr.id == id then
			return true
		end
	end)
end

function City:GetConstructionByEffect( effType, sum )
	if sum then
		local total = 0
		Asset_Foreach( self, CityAssetID.CONSTR_LIST, function ( constr )
			for type, value in pairs( constr.effects ) do
				if CityConstrEffect[type] == effType then
					total = total + value
				end
			end
		end )		
		return total
	end
	local ret = Asset_FindItem( self, CityAssetID.CONSTR_LIST, function ( constr )
		for type, value in pairs( constr.effects ) do
			if CityConstrEffect[type] == effType then				
				return value
			end
		end
	end )
	return ret
end

function City:GetNumberOfConstruction( id )
	local number = 0
	Asset_Foreach( self, CityAssetID.CONSTR_LIST, function ( constr )
		if constr.id == id then number = number + 1 end
	end)
	return number
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

function City:GetCorpsSalary()
	local salary = 0
	Asset_Foreach( self, CityAssetID.CORPS_LIST, function( corps )
		if corps:IsAtHome() == false then
			local corpsSalary = corps:GetSalary()
			salary = salary + corpsSalary
			--print( corps:ToString("MILITARY"), "salary=" .. corpsSalary )
		end
	end )
	return salary
end

--return paid salary every month
function City:GetSalary()	
	return self:GetPopuValue( "POPU_SALARY" ) + self:GetCorpsSalary()
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

--return consumption food every day
function City:GetConsumeFood()
	return self:GetPopuValue( "POPU_CONSUME_FOOD" ) + self:GetSupplyFood()
end

function City:GetReqProperty( month )
	if not month then month = MONTH_IN_YEAR end
	local req_money = self:GetSalary() * month
	local req_food  = self:GetConsumeFood() * month
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
	local area = 0
	Asset_Foreach( self, CityAssetID.PLOTS, function ( plot )
		local template = Asset_Get( plot, PlotAssetID.TEMPLATE )	
		if template.type == PlotType.LAND then
			area = area + 4
		elseif template.type == PlotType.HILLS then
			area = area + 1
		end
		if template.terrain == PlotTerrainType.PLAINS then
			area = area + 2
		elseif template.terrain == PlotTerrainType.GRASSLAND then
			area = area + 1
		elseif template.terrain == PlotTerrainType.DESERT then
		elseif template.terrain == PlotTerrainType.TUNDRA then
		elseif template.terrain == PlotTerrainType.SNOW then
		elseif template.terrain == PlotTerrainType.LAKE then
		elseif template.terrain == PlotTerrainType.COAST then
		elseif template.terrain == PlotTerrainType.OCEAN then
		end
	end)
	return math.max( 10, area )
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
	if not number then error( "1") end
	local cur = self:GetPopu( popuType )
	if not cur then	cur = 0 end
	Asset_SetDictItem( self, CityAssetID.POPU_STRUCTURE, popuType, cur + number )
end

function City:LosePopu( number )
	--todo
end

--type from enum CityJob
function City:GetOfficer( job, index )
	if not index then index = 0 end
	local item = Asset_FindItem( self, CityAssetID.OFFICER_LIST, function ( data )
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
	Asset_FindItem( self, CityAssetID.OFFICER_LIST, function ( data )		
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
	return endPos - CityJob.POSITION_BEGIN + 1
end

--return list of characters not chara in any officer position
function City:FindNonOfficerFreeCharas( charaList )
	if not charaList then charaList = {} end
	Asset_Foreach( self, CityAssetID.CHARA_LIST, function( chara )
		if chara:IsAtHome() == false then
			--print( chara.name .. " not at home" )
			return
		end
		if chara:IsBusy() == true then
			--print( chara.name .. " is busy" )
			return
		end
		if Asset_Get( chara, CharaAssetID.CORPS ) then
			--print( chara.name .. " has corps" )
			return
		end
		if self:GetCharaJob( chara ) ~= CityJob.NONE then
			--print( chara.name .. " has job" )
			return
		end
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
--return corps_list, total_soldier, max_single_solider
function City:GetFreeCorps( fn )
	local list = {}
	local tot_soldier = 0
	local max_soldier = 0
	local power = 0
	Asset_Foreach( self, CityAssetID.CORPS_LIST, function ( corps )
		if corps:IsAtHome() == false then return end
		if corps:IsBusy() == true then return end

		--check troop
		if corps:GetSoldier() == 0 then
			DBG_TrackBug( "why no soldier" .. corps:ToString() )
			return
		end

		--check leader
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
		local soldier = corps:GetSoldier()
		tot_soldier = tot_soldier + soldier
		max_soldier = math.max( max_soldier, soldier )
	end )
	return list, tot_soldier, max_soldier
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

function City:FindNearbyFriendCities( group )
	if not group then group = Asset_Get( self, CityAssetID.GROUP ) end
	return self:FilterAdjaCities( function ( adja )		
		local adjaGroup = Asset_Get( adja, CityAssetID.GROUP )
		return adjaGroup == group
	end )
end

--find enemy( at war ) cities adjacent
function City:FindNearbyEnemyCities( group )
	if not group then group = Asset_Get( self, CityAssetID.GROUP ) end
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
function City:CharaJoin( chara, isEnterCity )
	--sanity checker
	if chara:GetStatus( CharaStatus.DEAD ) then
		DBG_Error( "why dead man", chara.name )
		return
	end
	if Asset_Get( chara, CharaAssetID.GROUP ) ~= Asset_Get( self, CityAssetID.GROUP ) then
		error( chara:ToString() .. " cann't join city, not belong group" .. Asset_Get( chara, CharaAssetID.GROUP ).name .. " " .. Asset_Get( self, CityAssetID.GROUP ).name )
	end

	chara:JoinCity( self, isEnterCity )

	Asset_AppendList( self, CityAssetID.CHARA_LIST, chara )
	
	Debug_Log( chara:ToString(), "join city=", self.name, isEnterCity and "true" or "false" )
end

function City:CharaLeave( chara )
	chara:JoinCity()

	Asset_RemoveListItem( self, CityAssetID.CHARA_LIST, chara )

	self:RemoveOfficer( chara )

	Debug_Log( chara:ToString(), "leave city=" .. self:ToString() )
end

--------------------------------------------
-- Corps relative

--corps join into city, but no means reach there
function City:CorpsJoin( corps, isEnterCity )
	--set encampment
	Asset_Set( corps, CorpsAssetID.ENCAMPMENT, self )
	if isEnterCity then corps:EnterCity( self ) end

	--insert trooplist
	Asset_AppendList( self, CityAssetID.CORPS_LIST, corps )

	--insert charalist
	Asset_Foreach( corps, CorpsAssetID.OFFICER_LIST, function ( chara )
		chara:JoinCity( self, isEnterCity )
		Asset_AppendList( self, CityAssetID.CHARA_LIST, chara )
	end)

	--add from group
	if not Asset_Get( corps, CorpsAssetID.GROUP ) then
		local group = Asset_Get( self, CityAssetID.GROUP )
		if group then
			group:AddCorps( corps )
		end
		--error( "corps no group" )
	end	

	Debug_Log( corps:ToString(), "setencamp city=" .. self.name )
end

function City:RemoveCorps( corps )	
	Asset_Set( corps, CorpsAssetID.ENCAMPMENT, nil )

	Asset_RemoveListItem( self, CityAssetID.CORPS_LIST, corps )

	--remove charalist
	Asset_Foreach( corps, CorpsAssetID.OFFICER_LIST, function ( chara )
		chara:JoinCity()
		Asset_RemoveListItem( self, CityAssetID.CHARA_LIST,   chara )
		Asset_RemoveListItem( self, CityAssetID.OFFICER_LIST, chara, "officer" )
	end)
end

--------------------------------------------
-- Character relative
--!!! should elect by the leader of group, to do
function City:ElectExecutive()
	local executive = self:GetOfficer( CityJob.EXECUTIVE )
	if executive then return end
	
	--find a leader from officer
	local charaList = Asset_GetList( self, CityAssetID.CHARA_LIST )
	officer = Chara_FindLeader( charaList )

	--executive = Random_GetListData( self, CityAssetID.CHARA_LIST )		
	--DBG_Trace( "city=" .. self.name .. " no executive, num_chara=" .. Asset_GetListSize( self, CityAssetID.CHARA_LIST ) )
	if not officer then return end

	--dismiss old job
	self:RemoveOfficer( officer )
	--assign new job as executive
	self:SetOfficer( officer, CityJob.EXECUTIVE )
	CRR_Tolerate( "city=" .. self.name .. " set default executive=" .. officer:ToString() )
	--InputUtil_Pause( "select chief executive=" .. executive.name )
end

--IMP, assign the officer to the fit job
--1. One should always do his old job
--2. One should do his best
--3. One with average ability, should assign to the short position
function City:AssignOfficer()
	local jobList = City_GetVacancyJobs( self )	
	local numOfJobs = #jobList
	if numOfJobs == 0 then	return end
	local charaList = self:FindNonOfficerFreeCharas()
	if #charaList == 0 then return end

	--print( "assignofficer-->" .. self:ToString("OFFICER"),  "chara=" .. #charaList, "job=" .. #jobList )
	--for k, chara in ipairs( charaList ) do Debug_Log( k, chara.name ) end

	local jobIndex = 1
	while #charaList > 0 and jobIndex < numOfJobs do
		local job = jobList[jobIndex]
		jobIndex = jobIndex + 1
		local chara = Chara_FindBestCharaForJob( job, charaList )
		self:SetOfficer( chara, job )
		--if self.id == 3 then print( "assign", chara:ToString(), MathUtil_FindName( CityJob, job ) ) end
	end

	Debug_Log( "assignofficer end" .. self:ToString("OFFICER") )
end

--exclude executive
function City:RemoveOfficer( chara )
	--sanity checker
	local job = self:GetCharaJob( chara )
	if job == CityJob.NONE then	return end
	Debug_Log( "remove job=" .. MathUtil_FindName( CityJob, job ), chara:ToString( "STATUS" )  )

	Asset_RemoveListItem( self, CityAssetID.OFFICER_LIST, chara, "officer" )
end

function City:ClearOfficer()
	local officer = self:GetOfficer( CityJob.EXECUTIVE )
	Asset_Clear( self, CityAssetID.OFFICER_LIST )
	self:SetOfficer( officer, CityJob.EXECUTIVE )
end

function City:SetOfficer( chara, job )
	if not chara then return end

	local oldJob = self:GetCharaJob( chara )
	if oldJob ~= CityJob.NONE then
		DBG_Error( chara.name .. " already has a job=" .. MathUtil_FindName( CityJob, oldJob ) .. " newjob=" .. MathUtil_FindName( CityJob, job ) )
	end

	--sanity checker
	Asset_Foreach( self, CityAssetID.OFFICER_LIST, function ( data )
		--print( chara.name, MathUtil_FindName( CityJob, job ) )
		if data.officer == chara then
			DBG_Error( "why add officer duplicated", chara.name, MathUtil_FindName( CityJob, job ) 	)
		end
	end)

	Asset_AppendList( self, CityAssetID.OFFICER_LIST, { officer = chara, job = job } )
	Debug_Log( self.name, "Assign " .. chara.name .. "-->" .. MathUtil_FindName( CityJob, job ) )	
	Stat_Add( "SetOfficer@" .. self.name, chara.name .. "=" .. MathUtil_FindName( CityJob, job ) .. " " .. g_Time:ToString(), StatType.LIST )
	Stat_Add( "SetJob@" .. chara.name, MathUtil_FindName( CityJob, job ) .. " " .. self.name .. " " .. g_Time:ToString(), StatType.LIST )
end

--------------------------------------------

function City:BuildConstruction( constr )
	--to avoid duplicated checker, insert the construction manually
	local list = Asset_GetList( self, CityAssetID.CONSTR_LIST )
	table.insert( list, constr )

	Stat_Add( "BuildConstr", 1, StatType.TIMES )
	Stat_Add( self.name .. "@Build", constr.name, StatType.LIST )
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
		local cond = constr.prerequsite
		if cond then
			if cond.city_lv and cond.city_lv > Asset_Get( self, CityAssetID.LEVEL ) then match = false end
			if cond.has_constr and self:GetConstruction( cond.has_constr ) == nil then match = false end
			if cond.singleton and self:GetConstruction( id ) then match = false end
			if cond.number and self:GetNumberOfConstruction( id ) >= cond.number then match = false end
		end
		if match then
			table.insert( constrList, constr )
		end
	end
	Asset_SetList( self, CityAssetID.CONSTRTABLE_LIST, constrList )
end

function City:UpdateSecurity()
	for typename, param in pairs( CitySecurityData ) do		
		local type = CitySecurity[typename]
		local value = Asset_GetDictItem( self, CityAssetID.SECURITY, type )
		if not value then value = param.def end		
		if value then			
			if param.normal then
				if value > param.normal then value = value - 1 end
				if value < param.normal then value = value + 1 end
			end
			if param.popu_bonus then
				local popuType = CityPopu[param.popu_bonus.popu]
				local has = self:GetPopu( popuType )
				value = math.ceil( has * param.popu_bonus.value )
				--if value ~= 0 then print( "hel", param.popu_bonus.popu, has, value ) end
			end
			if param.popu_need then
				local popuType = CityPopu[param.popu_need]
				local req = self:GetReqPopu( popuType )
				local has = self:GetPopu( popuType )
				if has < req then value = value - 1 end
				if has > req then value = value + 1 end
				--print( param.popu_need, has, req, value )
			end

			if param.min and param.max then value = MathUtil_Clamp( value, param.min, param.max ) end
			--if value ~= 0 then InputUtil_Pause( MathUtil_FindName( CitySecurity, type ), value ) end
			Asset_SetDictItem( self, CityAssetID.SECURITY, type, value )
		end
	end
end

function City:UpdateDiss()
	for typename, param in pairs( CityDissData ) do
		local type = CityDiss[typename]
		local value = Asset_GetDictItem( self, CityAssetID.DISS, type )
		if not value then value = param.def end
		if value then
			if param.normal then
				if value > param.normal then value = value - 1 end
				if value < param.normal then value = value + 1 end
			end

			if self:GetStatus( CityStatus[param.status] ) then
				value = value + ( param.increment or 0 )
			end

			if param.min and param.max then value = MathUtil_Clamp( value, param.min, param.max ) end

			Asset_SetDictItem( self, CityAssetID.DISS, type, value )
		end
	end
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
		--if month == 1 then self:ClearOfficer() end
		self:AssignOfficer()

		--sanity checker
		if Asset_GetListSize( self, CityAssetID.CHARA_LIST ) > Asset_GetListSize( self, CityAssetID.OFFICER_LIST ) + Asset_GetListSize( self, CityAssetID.OFFICER_LIST ) then
			--too many chara isn't officer, why?
			Asset_Foreach( self, CityAssetID.CHARA_LIST, function ( chara )
				--print( self.name .. " chara=" .. chara:ToString("TASK") .. " officer=" .. MathUtil_FindName( CityJob, self:GetCharaJob( chara ) ) )
			end )
			--InputUtil_Pause( self:ToString( "OFFICER" ) )
		end
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

		self:UpdateSecurity()
		self:UpdateDiss()
	end

	--cancel research
	if self:IsCapital() == false then
		Asset_Set( self, CityAssetID.RESEARCH, nil )
	end
end

--------------------------------------------

function City:CreateSpy( city, grade )
	return Intel_CreateSpy( city, self, grade )
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
		Asset_SetDictItem( self, CityAssetID.SPY_LIST, city.id, spy )
	end
	return spy
end

--execute an op will lose spy
function City:LoseSpy( city, decGrade )
	local spy = self:GetSpy( city )

	if not decGrade then decGrade = -1 end
	spy.intel = math.ceil( spy.intel * 0.5 )
	spy.grade = MathUtil_Clamp( spy.grade - decGrade, CitySpyParams.INIT_GRADE, CitySpyParams.MAX_GRADE )
	Stat_Add( "LoseSpy@" .. city.name, 1, StatType.TIMES )

	if spy.grade <= CitySpyParams.MIN_GRADE then
		--Intel_EvacuateSpy( spy )
	end
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

	self:AddStatus( CityStatus.VIGILANT, DAY_IN_MONTH )
end

function City:DestroyDefensive()
	City_DestroyDefensive( self )

	self:AddStatus( CityStatus.VIGILANT, DAY_IN_MONTH )
end

function City:Assassinate( target, killer )
	--!!!Should test the case about the leader of outside-corps
	Chara_Die( target )

	Stat_Add( "Assassinate", target:ToString() .. " by " .. killer:ToString(), StatType.LIST )
	--InputUtil_Pause( target:ToString() .. " was assassinated" )

	self:AddStatus( CityStatus.VIGILANT, DAY_IN_MONTH )
end

---------------------------------------

function City:UseMoney( money, comment )
	Asset_Reduce( self, CityAssetID.MONEY, money )
	Debug_Log( self.name .. " use money=" .. money .. "/" .. Asset_Get( self, CityAssetID.MONEY ) .. " for=", comment )
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
	--print( self:ToString() .. self.id .." recv food=" .. food, g_Time:ToString() )
	--if self:GetStatus( CityStatus.IN_SIEGE ) then InputUtil_Pause( "-------------", self.name, "receive food=" .. food ) end
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

function City:AddStatus( status, value )
	local current = self:GetStatus( status ) or 0
	current = current + value
	Asset_SetDictItem( self, CityAssetID.STATUSES, status, current )
	--print( self:ToString("STATUS"), MathUtil_FindName( CityStatus, status ), current )
	--InputUtil_Pause( "ADD STATUS", status, current)
end

function City:WatchBudget( reason )
	if reason then Debug_Log( "watchbudget=" .. self.name .."->" .. reason ) end
	Debug_Log( self:ToString("POPULATION") )		
	Debug_Log( self:ToString( "ASSET" ) )
	Debug_Log( self.name .. " personal=" .. City_CalcPersonalTax( self ), "comm=" .. City_CalcCommerceTax( self ), "trade=" .. City_CalcTradeTax( self ) )
	Debug_Log( "year tax=" .. City_GetYearTax( self ),  "salary=" .. self:GetSalary() * 12 )
	--[[
	local req_food, req_money = self:GetReqProperty( 1 )
	local salary = self:GetSalary()
	local food   = self:GetConsumeFood()
	if salary ~= req_money or food ~= req_food then
		print( salary, req_money, food, req_food )
		k.p = 1
	end
]]
	--if City_IsBudgetSafe( self ) == false then InputUtil_Pause("budget danger") end	
end

---------------------------------

function City:LevyTax()
	local value = Asset_GetDictItem( self, CityAssetID.DISS, CityDiss.LEVY_TAX )
	value = value + 10
	Asset_SetDictItem( self, CityAssetID.DISS, CityDiss.LEVY_TAX, value )
	--InputUtil_Pause( "levytax=" .. Asset_GetDictItem( self, CityAssetID.DISS, CityDiss.LEVY_TAX ) )
end

function City:Demonstrate( time )
	self:SetStatus( CityStatus.DEMONSTRATE, time )
end

function City:Strike( time )
	City_Pillage( self )
	self:SetStatus( CityStatus.STRIKE, time )
end

function City:FindExpandPlot()
	if Asset_Get( self, CityAssetID.LEVEL ) >= Entity_GetAssetAttrib( self, CityAssetID.LEVEL ).max then
		return
	end

	local plots = {}
	Asset_Foreach( self, CityAssetID.PLOTS, function ( plot )		
		plots = g_map:GetAdjoinPlots( Asset_Get( plot, PlotAssetID.X ), Asset_Get( plot, PlotAssetID.Y ), plots, function ( p )
			return not Asset_Get( p, PlotAssetID.CITY )
		end )
	end)
	local list = {}
	for _, plot in pairs( plots ) do
		local city = Asset_Get( plot, PlotAssetID.CITY )
		if not city then
			local plotType = plot:GetPlotType()
			if plotType == PlotType.LAND or plotType == PlotType.HILLS then
				table.insert( list, plot )
			end
		end
	end
	if #list == 0 then return end

	local plot = Random_GetListItem( list )
	self:SetStatus( CityStatus.EXPAND_PLOT, g_map:CreatePlotKey( plot ) )
	local road  = Asset_Get( plot, PlotAssetID.ROAD )
	local level = Asset_Get( self, CityAssetID.LEVEL )
	local dur   = CityParams.ISOLATE_DURATION_MODULUS * level * level
	self:SetStatus( CityStatus.EXPAND_DURATION, dur )

	--[[
	print( self:ToString( "POPULATION" ) )
	print( self:ToString( "DEVELOP" ) )
	print( self:ToString("PLOTS"), "find expand plot=" .. plot:ToString(), "dur=" .. dur )

	Track_Reset()
	Track_Data( "population", Asset_Get( self, CityAssetID.POPULATION ) )
	Track_Data( "agri", Asset_Get( self, CityAssetID.AGRICULTURE ) )
	Track_Data( "prod", Asset_Get( self, CityAssetID.PRODUCTION ) )
	Track_Data( "comm", Asset_Get( self, CityAssetID.COMMERCE ) )	
	--]]
end

function City:Expand()
	local id = self:GetStatus( CityStatus.EXPAND_PLOT )	
	local plot = id and g_map:GetPlotByKey( id ) or nil
	if not plot then return end
	Asset_AppendList( self, CityAssetID.PLOTS, plot )
	self:SetStatus( CityStatus.EXPAND_PLOT, nil )
	self:SetStatus( CityStatus.EXPAND_DURATION )

	City_DividePopuStructure( self, Asset_Get( plot, PlotAssetID.POPULATION ) )
	self:UpdatePlots()

	--[[
	print( self:ToString( "POPULATION" ) )
	print( self:ToString( "DEVELOP" ) )
	InputUtil_Pause( "expand", self:ToString("PLOTS") )
	
	Track_Data( "population", Asset_Get( self, CityAssetID.POPULATION ) )
	Track_Data( "agri", Asset_Get( self, CityAssetID.AGRICULTURE ) )
	Track_Data( "prod", Asset_Get( self, CityAssetID.PRODUCTION ) )
	Track_Data( "comm", Asset_Get( self, CityAssetID.COMMERCE ) )
	Track_Dump()
	--]]
end

function City:Isolate()
	--find outside plot
	local list = {}
	Asset_Foreach( self, CityAssetID.PLOTS, function ( plot )
		local plots = {}
		g_map:GetAdjoinPlots( Asset_Get( plot, PlotAssetID.X ), Asset_Get( plot, PlotAssetID.Y ), plots )
		for _, adPlot in ipairs( plots ) do
			if not Asset_Get( adPlot, PlotAssetID.CITY ) then
				table.insert( list, plot )
				break
			end
		end		
	end)
	if #list == 0 then return end

	--[[
	print( self:ToString( "PLOTS" ) )
	print( self:ToString( "POPULATION" ) )
	print( self:ToString( "DEVELOP" ) )
	
	Track_Reset()
	Track_Data( "population", Asset_Get( self, CityAssetID.POPULATION ) )
	Track_Data( "agri", Asset_Get( self, CityAssetID.AGRICULTURE ) )
	Track_Data( "prod", Asset_Get( self, CityAssetID.PRODUCTION ) )
	Track_Data( "comm", Asset_Get( self, CityAssetID.COMMERCE ) )
	]]

	--find 	
	local plot = Random_GetListItem( list )
	Asset_RemoveListItem( self, CityAssetID.PLOTS, plot )
	self:SetStatus( CityStatus.EXPAND_PLOT, nil )
	self:SetStatus( CityStatus.EXPAND_DURATION )	
	
	self:LosePopu( Asset_Get( plot, PlotAssetID.POPULATION ) )
	self:UpdatePlots()

	--[[
	print( self:ToString( "POPULATION" ) )
	print( self:ToString( "DEVELOP" ) )
	InputUtil_Pause( "isolate", plot:ToString(), self:ToString("PLOTS") )

	Track_Data( "population", Asset_Get( self, CityAssetID.POPULATION ) )
	Track_Data( "agri", Asset_Get( self, CityAssetID.AGRICULTURE ) )
	Track_Data( "prod", Asset_Get( self, CityAssetID.PRODUCTION ) )
	Track_Data( "comm", Asset_Get( self, CityAssetID.COMMERCE ) )
	Track_Dump()
	]]
end