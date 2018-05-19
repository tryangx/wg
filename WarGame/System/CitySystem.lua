---------------------------------------

--function City_GetCity
function City_GetSupportPopu( city )
	local popustparams = Scenario_GetData( "CITY_POPUSTRUCTURE_PARAMS" )[1]
	local agr = Asset_Get( city, CityAssetID.AGRICULTURE )
	local farmer = Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.FARMER )
	local useagr = math.ceil( farmer / popustparams.POPU_PER_UNIT.FARMER )
	local supportPopu = math.ceil( useagr * PlotParams.FOOD_PER_AGRICULTURE / GlobalTime.TIME_PER_YEAR )
	local maxSupport = math.ceil( agr * PlotParams.FOOD_PER_AGRICULTURE / GlobalTime.TIME_PER_YEAR )
	local popu = Asset_Get( city, CityAssetID.POPULATION )
	print( city.name .. "popu=" .. popu .. "/" .. supportPopu .. "(" .. math.ceil( popu * 100 / supportPopu ) .. "%)" .. " Max:" .. maxSupport .. "(" .. math.ceil( popu * 100 / maxSupport ) .. "%)" )
	return popu
end

-----------------------------------------------

function City_GetPopuParams( city )
	local params = Scenario_GetData( "CITY_POPUSTRUCTURE_PARAMS" )[1]
	if not params.POPU_NEED_RATIO.req_total or not params.POPU_NEED_RATIO.max_total then
		local req_total = 0
		local max_total = 0
		for _, ratio in pairs( params.POPU_NEED_RATIO ) do
			req_total = req_total + ratio.req
			max_total = max_total + ratio.max
		end
		params.POPU_NEED_RATIO.req_total = req_total
		params.POPU_NEED_RATIO.max_total = max_total
		--InputUtil_Pause( "need ratio=" .. params.POPU_NEED_RATIO.req_total, params.POPU_NEED_RATIO.max_total )
	end
	if not params.POPU_CONSUME_FOOD._total then
		local total = 0	
		for _, ratio in pairs( params.POPU_CONSUME_FOOD ) do
			total = total + ratio * params.POPU_NEED_RATIO.req_total
		end
		params.POPU_CONSUME_FOOD._total = total
		--InputUtil_Pause( "food cons=" .. params.POPU_CONSUME_FOOD._total )
	end
	return params
end

function City_GetPopuTypeByDevIndex( id )
	if id == CityAssetID.AGRICULTURE then
		return "FARMER"
	elseif id == CityAssetID.COMMERCE then
		return "MERCHANT"
	elseif id == CityAssetID.PRODUCTION then
		return "WORKER"
	end
	return "NONE"
end

-- !!! VERY IMPORTANT
-- Measure how many population in every career required by the development index.
function City_NeedPopu( city, popuname )
	local cityparams = City_GetPopuParams( city )
	local needparam  = cityparams.POPU_NEED_RATIO
	local unitparam  = cityparams.POPU_PER_UNIT

	--some career needs the fixed ratio of the total population
	if needparam[popuname] then
		local popu   = Asset_Get( city, CityAssetID.POPULATION )
		return math.floor( needparam[popuname].req * popu )
	end

	--some career needs the number of population per development index 
	if popuname == "FARMER" then
		return Asset_Get( city, CityAssetID.AGRICULTURE ) * unitparam[popuname]
	elseif popuname == "WORKER" then
		return Asset_Get( city, CityAssetID.PRODUCTION ) * unitparam[popuname]
	elseif popuname == "MERCHANT" then
		return Asset_Get( city, CityAssetID.COMMERCE ) * unitparam[popuname]
	end
	
	return 0
end

function City_NeedDevIndex( city, id )
	local cityparams = City_GetPopuParams( city )
	local unitparam  = cityparams.POPU_PER_UNIT

	if id == CityAssetID.AGRICULTURE then
		return math.ceil( Asset_Get( city, CityAssetID.AGRICULTURE ) / unitparam.FARMER )
	elseif id == CityAssetID.COMMERCE then
		return math.ceil( Asset_Get( city, CityAssetID.COMMERCE ) / unitparam.MERCHANT )
	elseif id == CityAssetID.PRODUCTION then
		return math.ceil( Asset_Get( city, CityAssetID.PRODUCTION ) / unitparam.WORKER )
	end

	return 0
end

-------------------------------------------------------

-------------------------------------------------------

--collet material
function City_Produce( city )
	local income = 0
	local popustparams = City_GetPopuParams( city )
	for type, _ in pairs( CityPopu ) do
		local value = popustparams.POPU_PRODUCE[type]
		if value then
			local num = Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu[type] )
			income = income + num * value
		end
	end
	Asset_Plus( city, CityAssetID.MATERIAL, income )

	Stat_Add( "ProduceMat@" .. city.name, income, StatType.ACCUMULATION )
	--InputUtil_Pause( "City=" .. city.name .. " produce mat=" .. income .. " Material=" .. Asset_Get( city, CityAssetID.MATERIAL ) )	
end

function City_GetFoodIncome( city )
	local income = 0
	local popustparams = City_GetPopuParams( city )
	local agri         = Asset_Get( city, CityAssetID.AGRICULTURE )
	local maxAgri      = Asset_Get( city, CityAssetID.MAX_AGRICULTURE )
	--0.5 ~ 1.5
	local modifer      = ( agri + agri ) / maxAgri
	for type, _ in pairs( CityPopu ) do
		local value = popustparams.POPU_HARVEST[type]
		if value then
			local num = Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu[type] )
			income = income + modifer * num * value
		end
	end
	return math.ceil( income )
end

--collect food
function City_Harvest( city )
	local income = City_GetFoodIncome( city )

	city:ReceiveFood( income )
	Stat_Add( "FoodHarvest@" .. city.name, income, StatType.ACCUMULATION )
end

--------------------------------------
-- City Population Structure

function City_InitPopuStructure( city )
	local popu   = Asset_Get( city, CityAssetID.POPULATION )
	local popustparams = City_GetPopuParams( city )
	local needparam  = popustparams.POPU_NEED_RATIO
	local plebparam  = popustparams.IS_PLEB
	local initparam  = popustparams.POPU_INIT
	
	local nums = {}	
	local notpleb = 0
	for k, v  in pairs( CityPopu ) do
		if not plebparam[k] and initparam[k] then
			local num = math.floor( popu * needparam[k].req * Random_GetInt_Sync( initparam[k].min, initparam[k].max ) * 0.01 )
			nums[v] = num
			notpleb = notpleb + num
		end
	end

	local needfarmer   = City_NeedPopu( city, "FARMER" )
	local needworker   = City_NeedPopu( city, "WORKER" )
	local needmerchant = City_NeedPopu( city, "MERCHANT" )
	local needpleb = needfarmer + needworker + needmerchant
	
	local leftpopu = popu - notpleb
	local plebrate = leftpopu / needpleb
	nums[CityPopu.FARMER]   = math.floor( needfarmer * plebrate )
	nums[CityPopu.WORKER]   = math.floor( needworker * plebrate )
	nums[CityPopu.MERCHANT] = math.floor( needmerchant* plebrate )
	nums[CityPopu.HOBO] = nums[CityPopu.HOBO] + ( leftpopu - nums[CityPopu.FARMER] - nums[CityPopu.WORKER] - nums[CityPopu.MERCHANT] )

	for k, v in pairs( CityPopu ) do
		Asset_SetListItem( city, CityAssetID.POPU_STRUCTURE, v, nums[v] )
		--InputUtil_Pause( k, v, nums[v], Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, v ) )
	end

	--city:DumpPopu()
end

function City_PopuConv( city )
	local security = Asset_Get( city, CityAssetID.SECURITY )
	local dissatisfaction = Asset_Get( city, CityAssetID.DISSATISFACTION )

	local lv       = Asset_Get( city, CityAssetID.LEVEL )	
	local list     = Asset_GetList( city, CityAssetID.POPU_STRUCTURE )
	local popu     = Asset_Get( city, CityAssetID.POPULATION )
	local unit     = lv * 5 + 5

	local popustparams = City_GetPopuParams( city )
	local unitparam  = popustparams.POPU_PER_UNIT
	local needparam = popustparams.POPU_NEED_RATIO
	
	Track_Reset()

	local needlist = {}
	for k, v  in pairs( CityPopu ) do
		needlist[v] = City_NeedPopu( city, k )
		Track_Data( k,   list[v],   needlist[v] )	
	end

	function ConvPopu( target, current, need, max )
		if need == -1 then need = current + max end
		if target < 0 or need - current < 0 then
			--print( "no need to conv", target, need, current )
			return target, current, need
		end
		local inc = math.floor( math.min( target, need - current ) * Random_GetInt_Sync( 60, 100 ) * 0.01 )	
		if max then inc = math.min( max, inc ) end
		inc = math.floor( inc * Random_GetInt_Sync( 60, 100 ) * 0.01 )
		target  = target - inc
		need    = need - inc
		current = current + inc
		return target, current, need
	end

	local security_delta = 0
	for _, flow in pairs( popustparams.POPU_CONV_COND ) do
		local fromid = CityPopu[flow.from]
		if needlist[fromid] > list[fromid] * 0.5 then
			local valid = true
			if valid == true and flow.sec_more_than and security < flow.sec_more_than then valid = false end
			if valid == true and flow.sec_less_than and security > flow.sec_less_than then valid = false end
			--if valid == true and flow.sat_more_than and satisfaction < flow.sat_more_than then valid = false end			
			--if valid == true and flow.sat_less_than and satisfaction > flow.sat_less_than then valid = false end
			if valid == true and flow.prob and Random_GetInt_Sync( 1, 100 ) > flow.prob then valid = false end
			if valid == true then				
				local toid   = CityPopu[flow.to]
				list[fromid], list[toid] = ConvPopu( list[fromid], list[toid], flow.force_conv and -1 or needlist[toid], flow.ratio and math.floor( flow.ratio * list[fromid] ) or unit )
				if flow.sec then
					security_delta = security_delta + flow.sec
				end
				--if flow.ratio then print( flow.from, flow.to, list[fromid], list[toid], math.floor( flow.ratio * list[fromid] ) ) end
			end
		end
	end

	Asset_Set( city, CityAssetID.SECURITY, security + security_delta )
	
	for k, v  in pairs( CityPopu ) do
		Track_Data( k, list[v] )
	end
	--Track_Dump()

	--InputUtil_Pause()
end

function City_Mental( city )	
	local list     = Asset_GetList( city, CityAssetID.POPU_STRUCTURE )
	local popu     = Asset_Get( city, CityAssetID.POPULATION )
	local soldier  = list[CityPopu.RESERVES] or 0
	local officer  = list[CityPopu.OFFICER] or 0
	local rich     = list[CityPopu.RICH] or 0
	local noble    = list[CityPopu.NOBLE] or 0
	local middle   = list[CityPopu.MIDDLE] or 0
	local hobo     = list[CityPopu.HOBO] or 0

	local popustparams = City_GetPopuParams( city )
	local mentalparams = popustparams.POPU_MENTAL_RATIO
	local maxparams  = popustparams.POPU_MENTAL_MAX
	local minparams  = popustparams.POPU_MENTAL_MIN

	local security = Asset_Get( city, CityAssetID.SECURITY )	
	local soldiersec = math.min( soldier * mentalparams.SOLDIER / popu, maxparams.SOLDIER )
	local officersec = math.min( officer * mentalparams.OFFICER / popu, maxparams.OFFICER )
	local hobosec    = math.max( hobo * mentalparams.HOBO / popu, minparams.HOBO )	
	local security_std = math.max( 50, math.ceil( 60 + soldiersec + officersec + hobosec ) )
	
	local dissatisfaction = Asset_Get( city, CityAssetID.DISSATISFACTION )
	local richsat  = math.min( rich * mentalparams.RICH / popu, maxparams.RICH )
	local noblesat = math.min( noble * mentalparams.NOBLE / popu, maxparams.NOBLE )
	local midsat   = math.min( middle * mentalparams.MIDDLE / popu, maxparams.MIDDLE )
	local satisfaction_std = math.max( 40, math.ceil( 50 + richsat + noblesat + midsat ) )
	
	--print( soldiersec, officersec, hobosec )
	--print( richsat, noblesat, midsat )
	
	Track_Reset()
	Track_Data( "security", security, security_std )
	Track_Data( "satisfaction", satisfaction, satisfaction_std )

	--security keeps approach the standard value
	if security < security_std then
		security = security + math.floor( ( security_std - security ) * 0.1 + 1 )
	end

	--[[
	if satisfaction > security then
		satisfaction = satisfaction - math.floor( ( satisfaction - security ) * 0.1 + 1 )
	elseif security > 50 then
		if satisfaction < satisfaction_std and security > satisfaction then
			satisfaction = satisfaction + math.floor( ( satisfaction_std - satisfaction ) * 0.1 + 1 )
		end
	end	
	]]	

	Asset_Set( city, CityAssetID.SECURITY, security )
	Asset_Set( city, CityAssetID.DISSATISFACTION, dissatisfaction )

	Track_Data( "security", security )
	Track_Data( "dissatisfaction", dissatisfaction )
	--Track_Dump()

	--if security < satisfaction then InputUtil_Pause() end
end

function City_PopuGrow( city )
	local rate  = 1 / GlobalTime.MONTH_PER_YEAR
	local population = Asset_Get( city, CityAssetID.POPULATION )
	local growthRate = Random_GetInt_Sync( PopulationParams.GROWTH_MIN_RATE , PopulationParams.GROWTH_MAX_RATE )
	local sec = Asset_Get( city, CityAssetID.SECURITY )
	local diss = Asset_Get( city, CityAssetID.DISSATISFACTION )

	--increase children
	local increase = math.ceil( population * growthRate * rate * ( 100 + ( sec - diss ) ) * 0.000005 )
	local children = Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.CHILDREN )

	Track_Reset()
	Track_Data( "children", children )
	Track_Data( "popu", population )

	Asset_SetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.CHILDREN, children + increase )
	Asset_Plus( city, CityAssetID.POPULATION, increase )

	Track_Data( "children", Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.CHILDREN ) )
	Track_Data( "popu", Asset_Get( city, CityAssetID.POPULATION ) )
	--Track_Dump()
end

--------------------------------------

--------------------------------------

function City_CheckFlag( city )	
	--development evalution
	local score = 0
	local security = Asset_Get( city, CityAssetID.SECURITY )
	local agr     = Asset_Get( city, CityAssetID.AGRICULTURE )
	local maxagr  = Asset_Get( city, CityAssetID.MAX_AGRICULTURE )
	local comm    = Asset_Get( city, CityAssetID.COMMERCE )
	local maxcomm = Asset_Get( city, CityAssetID.MAX_COMMERCE )
	local prod    = Asset_Get( city, CityAssetID.PRODUCTION )
	local maxprod = Asset_Get( city, CityAssetID.MAX_PRODUCTION )
	if agr < maxagr * 0.5 then score = score + 1 end
	if comm < maxcomm * 0.5 then score = score + 1 end
	if prod < maxprod * 0.5 then score = score + 1 end
	if security < 70 then score = score + 1 end
	if security < 50 then score = score + 1 end
	Asset_SetListItem( city, CityAssetID.STATUSES, CityStatus.DEVELOPMENT_WEAK, score > 3 )
	Asset_SetListItem( city, CityAssetID.STATUSES, CityStatus.DEVELOPMENT_DANGER, score > 6 )

	--military evaluation
	local score = 0
	local group = Asset_Get( city, CityAssetID.GROUP )
	local power = city:GetMilitaryPower( city )
	if power == 0 then score = 4 end

	Asset_SetListItem( city, CityAssetID.STATUSES, CityStatus.SAFETY, true )
	Asset_ForeachList( city, CityAssetID.ADJACENTS, function( adjaCity )
		local adjaGroup = Asset_Get( adjaCity, CityAssetID.GROUP )
		if adjaGroup ~= group then
			Asset_SetListItem( city, CityAssetID.STATUSES, CityStatus.SAFETY, nil )

			if Dipl_IsAtWar( adjaGroup, group ) then
				Asset_SetListItem( city, CityAssetID.STATUSES, CityStatus.BATTLEFRONT, true )
			end			

			if typeof( adjaCity ) ~= "table" then
				--should to do
			end
			local adjaPower = Intel_GetSoldier( adjaCity, city )
			if adjaPower > ( power + power + power ) then score = score + 1 end
			if adjaPower > ( power + power ) then score = score + 1 end
			if adjaPower > power * 1.5 then score = score + 1 end
			if adjaPower > power * 1.2 then score = score + 1 end
		end
	end )
	Asset_SetListItem( city, CityAssetID.STATUSES, CityStatus.MILITARY_WEAK,   score > 3 )
	Asset_SetListItem( city, CityAssetID.STATUSES, CityStatus.MILITARY_DANGER, score > 6 )

	--debug flag
	Asset_ForeachList( city, CityAssetID.STATUSES, function ( value, status )
		if value == true then
			--print( city.name .. "_" .. MathUtil_FindName( CityStatus, status ) .. "=", value )
		end
	end)
end

--------------------------------------

function City_Event( city )	
	--System_Get( SystemType.EVENT_SYS ):Trigger( city )
end

--------------------------------------

function City_IncreaseDevelopment( city, params )
	if 1 then return end
	if params.agri then
		local cur = Asset_Get( city, CityAssetID.AGRICULTURE )
		local max = Asset_Get( city, CityAssetID.MAX_AGRICULTURE )
		Asset_Set( city, CityAssetID.AGRICULTURE, math.min( max, cur + params.agri ) )
		Stat_Add( "Dev@Agr_" .. ( params.agri > 0 and "INC" or "DEC" ), params.agri, StatType.TIMES )
	end
	if params.comm then
		local cur = Asset_Get( city, CityAssetID.COMMERCE )
		local max = Asset_Get( city, CityAssetID.MAX_COMMERCE )
		Asset_Set( city, CityAssetID.COMMERCE, math.min( max, cur + params.comm ) )
		Stat_Add( "Dev@Comm_" .. ( params.comm > 0 and "INC" or "DEC" ), params.comm, StatType.TIMES )
	end
	if params.prod then
		local cur = Asset_Get( city, CityAssetID.PRODUCTION )
		local max = Asset_Get( city, CityAssetID.MAX_PRODUCTION )
		Asset_Set( city, CityAssetID.PRODUCTION, math.min( max, cur + params.prod ) )		
		Stat_Add( "Dev@Prod_" .. ( params.prod > 0 and "INC" or "DEC" ), params.prod, StatType.TIMES )
	end
end

function City_DevelopmentVary( city )
	local security = Asset_Get( city, CityAssetID.SECURITY )
	local isSiege = Asset_GetListItem( city, CityAssetID.STATUSES, CityStatus.IN_SIEGE )

	local methods
	for _, item in pairs( Scenario_GetData( "CITY_DEVELOPMENT_VARY_PARAMS" ) ) do
		local match = true
		local conditions = item.conditions
		MathUtil_Dump( conditions )
		if match == true and conditions.prob and Random_GetInt_Sync( 1, 100 ) > conditions.prob then match = false end
		if match == true and conditions.insiege and conditions.insiege ~= isSiege then match = false end
		if match == true and conditions.security_more_than and security < conditions.security_more_than then match = false end
		if match == false then methods = item.methods break end
	end
	if not methods then return end

	if not methods.total_prob then
		methods.total_prob = 0
		for _, method in ipairs( methods ) do
			methods.total_prob = methods.total_prob + method.prob
			method.prob        = methods.total_prob
		end
	end

	local prob = Random_GetInt_Sync( 1, methods.total_prob )
	local selectMethod	
	for _, method in ipairs( methods ) do
		if prob <= method.prob then
			selectMethod = method
			break
		end
	end
	if not selectMethod then error( "invalid development vary" ) end

	City_IncreaseDevelopment( city, { agri = selectMethod.agri, comm = selectMethod.comm, prod = selectMethod.prod } )
end

function City_Develop( city, progress, id )
	local methods
	for _, item in pairs( Scenario_GetData( "CITY_DEVELOP_PARAMS" ) ) do
		local match = true
		local conditions = item.conditions
		if conditions.progress_min and conditions.progress_min > progress then match = false end
		if match == true then methods = item.methods break end
	end
	if not methods then return end

	if not methods.total_prob then
		methods.total_prob = 0
		for _, method in ipairs( methods ) do
			methods.total_prob = methods.total_prob + method.prob
			method.prob        = methods.total_prob
		end
	end
	local prob = Random_GetInt_Sync( 1, methods.total_prob )
	local selectMethod 
	for _, method in ipairs( methods ) do
		if prob < method.prob then
			selectMethod = method
			break
		end
	end
	if not selectMethod then return end

	local agri = selectMethod.agri or 0
	local comm = selectMethod.comm or 0
	local prod = selectMethod.prod or 0
	if id == CityAssetID.AGRICULTURE then agri = agri + selectMethod.main or 0 end
	if id == CityAssetID.COMMERCE    then comm = comm + selectMethod.main or 0 end
	if id == CityAssetID.PRODUCTION  then prod = prod + selectMethod.main or 0 end	
	City_IncreaseDevelopment( city, { agri = agri, comm = comm, prod = prod } )

	--InputUtil_Pause( "city dev", agri, comm, prod )
end

--Income
-- 1.personal
-- 2.commerce
-- 3.trade

function City_CalcPersonalTax( city )
	local tax = 0
	local popustparams = City_GetPopuParams( city )
	for type, _ in pairs( CityPopu ) do
		local value = popustparams.POPU_PERSONAL_TAX[type]
		if value then
			local num = Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu[type] )
			if num then
				tax = tax + value * num
				--print( MathUtil_FindName( CityPopu, type ) .. "=" .. num .. "*" .. value )
			end
		end
	end
	return math.ceil( tax )
end

function City_CalcCommerceTax( city )
	local tax = 0
	local popustparams = City_GetPopuParams( city )
	local comm     = Asset_Get( city, CityAssetID.COMMERCE )
	local maxComm  = Asset_Get( city, CityAssetID.MAX_COMMERCE )
	local commMod  = ( comm + comm ) / maxComm
	for type, _ in pairs( CityPopu ) do
		local value = popustparams.POPU_COMMERCE_TAX[type]
		if value then
			local num = Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu[type] )
			tax = tax + commMod * num * value
		end
	end
	return math.ceil( tax )
end

function City_CalcTradeTax( city )
	local tax = 0
	local popustparams = City_GetPopuParams( city )
	local prod         = Asset_Get( city, CityAssetID.PRODUCTION )
	local maxProd      = Asset_Get( city, CityAssetID.MAX_PRODUCTION )
	local group = Asset_Get( city, CityAssetID.GROUP )
	Asset_ForeachList( city, CityAssetID.ADJACENTS, function ( adjaCity )		
		local factor = 0.5
		local adjaGroup = Asset_Get( adjaCity, CityAssetID.GROUP )
		if adjaGroup ~= group then
			factor = factor + 0.5
		end
		if Dipl_IsAtWar( adjaGroup, group ) == true then
			factor = factor * 0.25
		end
		local curProd = math.min( prod, Asset_Get( adjaCity, CityAssetID.PRODUCTION ) )
		local bonus = curProd / maxProd
		for type, _ in pairs( CityPopu ) do
			local value = popustparams.POPU_TRADE_TAX[type]
			if value then
				local num = Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu[type] )
				tax = tax + num * bonus * value
			end
		end
	end )
	return math.ceil( tax )
end

function City_GetMonthTax( city )
	local income, tradeTax, personalTax, commerTax = 0, 0, 0, 0
	local month = g_Time:GetMonth()
	if month == 3 or month == 6 or month == 9 or month == 12 then		
		tradeTax = City_CalcTradeTax( city )
		income = income + tradeTax
	end
	if month == 1 then
		personalTax = City_CalcPersonalTax( city )	
		income = income + personalTax
	end
	commerceTax = City_CalcCommerceTax( city )
	income = income + commerceTax
	return income
end

function City_GetYearTax( city )
	local income = 0
	income = income + City_CalcPersonalTax( city )
	income = income + City_CalcCommerceTax( city ) * 12
	income = income + City_CalcTradeTax( city ) * 4
	return income
end

--collect money
function City_CollectTax( city )	
	local income = City_GetMonthTax( city )

	city:ReceiveMoney( income )
	Stat_Add( "CollectTax@City_" .. city.name, income, StatType.ACCUMULATION )
end

function City_PaySalary( city )
	local salary = city:GetSalary( city )
	local corpsSalary = city:GetCorpsSalary()
	salary = salary + corpsSalary
	city:UseMoney( salary )	
	Stat_Add( "PaySalary@City_" .. city.name, salary, StatType.ACCUMULATION )
end

--levy money
function City_LevyTax( city, progress )
	local income = 0
	income = income + City_CalcPersonalTax( city )
	
	--bonus by progress
	income = math.ceil( income * math.min( 2.5, math.max( 0.2, progress * 0.01 ) ) )

	Asset_Plus( city, CityAssetID.MONEY, income )
	Stat_Add( city.name .. "@LevyTax", "money=" .. income, StatType.LIST )
	--Debug_Log( "City=" .. city.name .. " Levy tax=" .. income .. " Money=" .. Asset_Get( city, CityAssetID.MONEY ) )	
	return income
end

function City_Build( city )

end

function City_Pillage( city )
	local agri = math.ceil( Asset_Get( city, CityAssetID.AGRICULTURE ) * -0.1 )
	local comm = math.ceil( Asset_Get( city, CityAssetID.COMMERCE ) * -0.1 )
	local prod = math.ceil( Asset_Get( city, CityAssetID.PRODUCTION ) * -0.1 )
	City_IncreaseDevelopment( city, { agri = agri, comm = comm, prod = prod } )
	--InputUtil_Pause( "pillage")
end

function City_ConvReserves( city, params )
	local totalNum = 0
	for _, item in pairs( params ) do
		local from = CityPopu[item.from]
		local to   = CityPopu[item.to]
		if Random_GetInt_Sync( 1, 100 ) < item.prob then
			local rate = Random_GetInt_Sync( item.min_rate, item.max_rate )
			local old  = Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, from )
			local new  = Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, to )
			local number = math.ceil( old * rate * 0.0001 )
			totalNum = totalNum + number
			Asset_SetListItem( city, CityAssetID.POPU_STRUCTURE, from, old - number )
			Asset_SetListItem( city, CityAssetID.POPU_STRUCTURE, to,   new + number )
			--Debug_Log( "Conv " .. item.from .. ":" .. old .. "-" .. number .. " --> " .. item.to .. ":" .. new .. "+" .. number )
		end
	end
	return totalNum
end

--------------------------------------

CitySystem = class()

function CitySystem:__init()
	System_Setup( self, SystemType.CITY_SYS, "GrowthSystem" )
end

function CitySystem:Start()
end

function CitySystem:Update()
	local month = g_Time:GetMonth()
	local day   = g_Time:GetDay()
	Entity_Foreach( EntityType.CITY, function ( city )
		--print( "##############################" )
		--city:DumpStats()
		--city:DumpPopu()
		--city:DumpGrowthAttrs()
		--city:DumpProperty()
		city:Update()
		
		if day % 15 == 0 then
			City_Event( city )
		end

		if day == 1 then
			--City_Produce( city )
		end
		
		if day == 1 then			
			City_CollectTax( city )
			City_PaySalary( city )
		end

		if month == 9 and day == 1 then
			City_Harvest( city )
		end

		if day == 1 then
			City_Produce( city )
		end

		if day % 10 == 0 then City_Mental( city ) end		

		--if day % 15 == 1 then City_DevelopmentVary( city ) end

		if day == 1 then
			City_PopuConv( city )
			City_PopuGrow( city )
		end

		if day % 10 == 0 then
			City_CheckFlag( city )
		end

		if day == 1 then
			if month == 1 then				
				--print( city:ToString( "BUDGET_YEAR" ) )
				--print( city:ToString( "GROWTH" ) )
				--print( city:ToString( "POPULATION" ) )
				--print( city:ToString( "SUPPLY" ) )
				--print( city:ToString( "TAX" ) )
			end
			--print( city:ToString( "BUDGET_MONTH" ) )			
		end
	end )	
	if month == 1 and day == 1 then
		--InputUtil_Pause( g_Time:ToString() )
	end
end