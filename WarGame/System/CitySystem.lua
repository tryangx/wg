---------------------------------------

--function City_GetCity
--[[
function City_GetSupportPopu( city )
	local popustparams = Scenario_GetData( "CITY_POPUSTRUCTURE_PARAMS" )[1]
	local agr = Asset_Get( city, CityAssetID.AGRICULTURE )
	local farmer = Asset_GetDictItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.FARMER )
	local useagr = math.ceil( farmer / popustparams.POPU_PER_UNIT.FARMER )
	local supportPopu = math.ceil( useagr * PlotParams.FOOD_PER_AGRICULTURE / GlobalTime.TIME_PER_YEAR )
	local maxSupport = math.ceil( agr * PlotParams.FOOD_PER_AGRICULTURE / GlobalTime.TIME_PER_YEAR )
	local popu = Asset_Get( city, CityAssetID.POPULATION )
	print( city.name .. "popu=" .. popu .. "/" .. supportPopu .. "(" .. math.ceil( popu * 100 / supportPopu ) .. "%)" .. " Max:" .. maxSupport .. "(" .. math.ceil( popu * 100 / maxSupport ) .. "%)" )
	return popu
end
]]
-----------------------------------------------

function City_GetNextJob( city )
	local isCapital = city:IsCapital()
	local params = Scenario_GetData( "CITY_JOB_PARAMS" )
	for _, item in pairs( params ) do
		local valid = true
		if valid == true and item.capital and isCapital == false then valid = false end
		if valid == true and item.prob and Random_GetInt_Sync( 1, 100 ) > item.prob then valid = false end
		if valid == true and item.max and city:GetNumberOfOfficer( CityJob[item.job] ) >= item.max then valid = false end
		if valid == true then
			return CityJob[item.job]
		end
	end
	--default commander
	return CityJob.COMMANDER
end

function City_GetPopuParams( city )
	local params = Scenario_GetData( "CITY_POPUSTRUCTURE_PARAMS" )[1]
	if not params.POPU_NEED_RATIO.req_total or not params.POPU_NEED_RATIO.limit_total then
		local req_total = 0
		local limit_total = 0
		for _, ratio in pairs( params.POPU_NEED_RATIO ) do
			req_total = req_total + ratio.req
			limit_total = limit_total + ratio.limit
		end
		params.POPU_NEED_RATIO.req_total = req_total
		params.POPU_NEED_RATIO.limit_total = limit_total
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

--[[
function City_GetPopuTypeByAssetID( id )
	if id == CityAssetID.AGRICULTURE then
		return "FARMER"
	elseif id == CityAssetID.COMMERCE then
		return "MERCHANT"
	elseif id == CityAssetID.PRODUCTION then
		return "WORKER"
	end
end
]]
--[[
function City_GetAssetIDByPopuName( popuname )
	if popuname == "FARMER" then
		return CityAssetID.MAX_AGRICULTURE
	elseif popuname == "WORKER" then
		return CityAssetID.MAX_PRODUCTION
	elseif popuname == "MERCHANT" then
		return CityAssetID.MAX_COMMERCE
	end	
end
]]

----------------------------------------------------------------------------------
-- !!! VERY IMPORTANT
-- Measure how many population in every career required by the development index.
function City_NeedPopu( city, popuname )
	--get params
	local cityparams = City_GetPopuParams( city )
	local needparam  = cityparams.POPU_NEED_RATIO
	--local unitparam  = cityparams.POPU_PER_UNIT

	--some career needs the fixed ratio of the total population
	if needparam[popuname] then
		local popu   = Asset_Get( city, CityAssetID.POPULATION )
		return math.floor( needparam[popuname].req * popu )
	end

	return 0
	--[[
	--some career needs the number of population per development index
	local assetid = City_GetAssetIDByPopuName( popuname )
	if not assetid then
		InputUtil_Pause( "0")
		return 0
	end


	return Asset_Get( city, assetid ) * unitparam[popuname]

	]]
end

-------------------------------------------------------
-- City Statu

--
-- Budget Safty Conditions
-- 1. Monthly income > Salary( High )
-- 2. Current Property > Req Property( One Year )
function City_IsBudgetSafe( city )
	local req = city:GetSalary()
	--check salary covered by commerce tax( monthly )
	if City_CalcCommerceTax( city ) < req then
		return false
	end
	--print( city:ToString( "POPULATION" ) )
	--print( "budget" .. city:ToString( "BUDGET_MONTH" ) )

	local req_food, req_money = city:GetReqProperty( MONTH_PER_YEAR )

	--check salary reserve
	if Asset_Get( city, CityAssetID.MONEY ) < req_money then
		--InputUtil_Pause( city.name, "danger money reserve" )
		return false
	end

	--check food reserve
	if Asset_Get( city, CityAssetID.FOOD ) < req_food then
		--InputUtil_Pause( city.name, "danger food reserve" )
		return false
	end
	--InputUtil_Pause( "budget safe")
	return true
end

-- Budget Danger Conditions
-- 1. Curernt Property < Req Property ( One month )
function City_IsBudgetDanger( city )
	local req_food, req_money = city:GetReqProperty( 1 )
	
	--check salary reserve
	if Asset_Get( city, CityAssetID.MONEY ) < req_money then
		--print( "budgetdanger", city.name, Asset_Get( city, CityAssetID.MONEY ) .."/".. req_money, Asset_Get( city, CityAssetID.FOOD ) .."/".. req_food )
		--InputUtil_Pause( city.name, "danger money reserve" )
		return true
	end

	--check food reserve
	if Asset_Get( city, CityAssetID.FOOD ) < req_food * 4 then
		--print( "budgetdanger", city.name, Asset_Get( city, CityAssetID.MONEY ) .."/".. req_money, Asset_Get( city, CityAssetID.FOOD ) .."/".. req_food )
		--InputUtil_Pause( city.name, "danger food reserve" )
		return true
	end
	--InputUtil_Pause( "budget safe")
	return false
end


-------------------------------------------------------

--collet material
function City_Produce( city )
	local income = 0
	local popustparams = City_GetPopuParams( city )
	for type, _ in pairs( CityPopu ) do
		local value = popustparams.POPU_PRODUCE[type]
		if value then
			local num = Asset_GetDictItem( city, CityAssetID.POPU_STRUCTURE, CityPopu[type] )
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
	for type, _ in pairs( CityPopu ) do
		local value = popustparams.POPU_HARVEST[type]
		if value then
			local num = Asset_GetDictItem( city, CityAssetID.POPU_STRUCTURE, CityPopu[type] )
			income = income + num * value
		end
	end
	--simply random from 40~80
	--we should seperate the modifier into Water, Plough, Disease etc
	local modifier = Random_GetInt_Sync( 20, 100 ) * 0.01
	income = math.ceil( income * modifier )
	return income
end

--collect food
function City_Harvest( city )
	local income = City_GetFoodIncome( city )

	city:ReceiveFood( income )
	Stat_Add( "FoodHarvest@" .. city.name, income, StatType.ACCUMULATION )
end

--------------------------------------
-- City Population Structure

-- #Initialize
--   Determined by the given constant ratio
--
-- #Convert flow
--   Determined by the City Index( Development, Security, etc )
--
--
function City_InitPopuStructure( city )
	--get params
	local popu   = Asset_Get( city, CityAssetID.POPULATION )
	local popustparams = City_GetPopuParams( city )
	local needparam  = popustparams.POPU_NEED_RATIO
	local initparam  = popustparams.POPU_INIT
	
	--initalize population structure
	local nums = {}	
	for k, v  in pairs( CityPopu ) do
		if initparam[k] then
			local num = math.floor( popu * math.min( needparam[k].limit, needparam[k].req * Random_GetInt_Sync( initparam[k].min, initparam[k].max ) * 0.01 ) )
			nums[v] = num
		end
	end

	--check pleb is in the range of limitation
	local lastPleb = nums[CityPopu.FARMER] + nums[CityPopu.WORKER] + nums[CityPopu.MERCHANT]		
	local needPleb = popu * needparam["PLEB"].limit
	if lastPleb >= needPleb then
		local ratio = needPleb / lastPleb
		nums[CityPopu.FARMER]   = math.floor( nums[CityPopu.FARMER] * ratio )
		nums[CityPopu.WORKER]   = math.floor( nums[CityPopu.WORKER] * ratio )
		nums[CityPopu.MERCHANT] = math.floor( nums[CityPopu.MERCHANT] * ratio )
		local curPleb = nums[CityPopu.FARMER] + nums[CityPopu.WORKER] + nums[CityPopu.MERCHANT]			
	end

	--calculate the hobo
	local hobo = popu
	for k, v  in pairs( CityPopu ) do
		if initparam[k] and v ~= CityPopu.HOBO then
			hobo = hobo - nums[v]
		end
	end

	for k, v in pairs( CityPopu ) do
		city:SetPopu( v, nums[v] )
		if nums[v] then
			--print( city.name .. " " .. k  .. "=" .. nums[v] .. "+" .. PercentString( nums[v] / popu ) )
		end		
	end
	--InputUtil_Pause( k, v, nums[v], Asset_GetDictItem( city, CityAssetID.POPU_STRUCTURE, v ) )

	--[[
	local needfarmer   = City_NeedPopu( city, "FARMER" )
	local needworker   = City_NeedPopu( city, "WORKER" )
	local needmerchant = City_NeedPopu( city, "MERCHANT" )
	
	local nums = {}	
	local notpleb = 0
	for k, v  in pairs( CityPopu ) do
		if initparam[k] then
			local num = math.floor( popu * needparam[k].req * Random_GetInt_Sync( initparam[k].min, initparam[k].max ) * 0.01 )
			nums[v] = num
			notpleb = notpleb + num
		end
	end

	local needpleb = needfarmer + needworker + needmerchant
	
	local leftpopu = popu - notpleb
	local plebrate = leftpopu / needpleb
	nums[CityPopu.FARMER]   = math.floor( needfarmer * plebrate )
	nums[CityPopu.WORKER]   = math.floor( needworker * plebrate )
	nums[CityPopu.MERCHANT] = math.floor( needmerchant* plebrate )
	nums[CityPopu.HOBO] = nums[CityPopu.HOBO] + ( leftpopu - nums[CityPopu.FARMER] - nums[CityPopu.WORKER] - nums[CityPopu.MERCHANT] )

	for k, v in pairs( CityPopu ) do
		city:SetPopu( v, nums[v] )
		--InputUtil_Pause( k, v, nums[v], Asset_GetDictItem( city, CityAssetID.POPU_STRUCTURE, v ) )
	end
	]]
end

function City_PopuConv( city )
	local security = Asset_Get( city, CityAssetID.SECURITY )
	local DISS = Asset_Get( city, CityAssetID.DISS )

	local lv       = Asset_Get( city, CityAssetID.LEVEL )	
	local list     = Asset_GetList( city, CityAssetID.POPU_STRUCTURE )
	local popu     = Asset_Get( city, CityAssetID.POPULATION )	

	local popustparams = City_GetPopuParams( city )
	--local unitparam  = popustparams.POPU_PER_UNIT
	local needparam = popustparams.POPU_NEED_RATIO
	
	local needlist = {}
	Track_Reset()	
	for k, v  in pairs( CityPopu ) do
		needlist[v] = City_NeedPopu( city, k )
		Track_Data( k,   list[v],   needlist[v] )	
	end

	function ConvPopu( target, current, need, max )
		if need == -1 then need = current + max end
		if target < 0 or need - current < 0 then
			--print( "no need to conv", target, need, current )
			return target, current, need, 0
		end
		--print( target, current, need, max )
		local inc = math.floor( math.min( target, need - current ) * Random_GetInt_Sync( 60, 100 ) * 0.01 )	
		if max then inc = math.min( max, inc ) end
		inc = math.floor( inc * Random_GetInt_Sync( 60, 100 ) * 0.01 )
		target  = target - inc
		need    = need - inc
		current = current + inc		
		return target, current, need, inc
	end

	local security_delta = 0
	for _, flow in pairs( popustparams.POPU_CONV_COND ) do
		local fromid = CityPopu[flow.from]
		if needlist[fromid] > list[fromid] * 0.5 then
			local valid = true
			local inc = 0
			if valid == true and flow.need_popu then
				local poputype = CityPopu[flow.need_popu]				
				if needlist[poputype] < list[poputype] then
					--InputUtil_Pause( "enough", flow.need_popu, needlist[poputype], list[poputype] )
					valid = false
				end
			end
			if valid == true and flow.sec_more_than and security < flow.sec_more_than then valid = false end
			if valid == true and flow.sec_less_than and security > flow.sec_less_than then valid = false end
			--if valid == true and flow.sat_more_than and satisfaction < flow.sat_more_than then valid = false end			
			--if valid == true and flow.sat_less_than and satisfaction > flow.sat_less_than then valid = false end
			if valid == true and flow.prob and Random_GetInt_Sync( 1, 100 ) > flow.prob then valid = false end
			if valid == true then				
				local toid   = CityPopu[flow.to]
				local convRatio = flow.ratio or ( lv + 10 ) * 0.0005				
				list[fromid], list[toid], _, inc = ConvPopu( list[fromid], list[toid], flow.force_conv and -1 or needlist[toid], math.floor( convRatio * list[fromid] ) )				
				if flow.sec then
					security_delta = security_delta + flow.sec
				end
				--if flow.ratio then print( flow.from, flow.to, list[fromid], list[toid], math.floor( flow.ratio * list[fromid] ) ) end
			end
			if valid == true and flow.debug and inc then
				--InputUtil_Pause( flow.from .. "->" .. flow.to, inc )
				Stat_Add( flow.from .. "->" .. flow.to, inc, StatType.ACCUMULATION )
			end
		end
	end

	Asset_Set( city, CityAssetID.SECURITY, security + security_delta )
	
	for k, v  in pairs( CityPopu ) do
		Track_Data( k, list[v] )
	end
	--Track_Dump()
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
	
	local DISS = Asset_Get( city, CityAssetID.DISS )
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
	Asset_Set( city, CityAssetID.DISS, DISS )

	Track_Data( "security", security )
	Track_Data( "DISS", DISS )
	--Track_Dump()

	--if security < satisfaction then InputUtil_Pause() end
end

function City_PopuGrow( city )
	local rate  = 1 / MONTH_IN_YEAR
	local population = Asset_Get( city, CityAssetID.POPULATION )
	local growthRate = Random_GetInt_Sync( PopulationParams.GROWTH_MIN_RATE , PopulationParams.GROWTH_MAX_RATE )
	local sec = Asset_Get( city, CityAssetID.SECURITY )
	local diss = Asset_Get( city, CityAssetID.DISS )

	--increase children
	local increase = math.ceil( population * growthRate * rate * ( 100 + ( sec - diss ) ) * 0.000005 )
	local children = Asset_GetDictItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.CHILDREN )

	Track_Reset()
	Track_Data( "children", children )
	Track_Data( "popu", population )

	city:SetPopu( CityPopu.CHILDREN, children + increase )
	Asset_Plus( city, CityAssetID.POPULATION, increase )

	Track_Data( "children", Asset_GetDictItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.CHILDREN ) )
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
	city:SetStatus( CityStatus.DEVELOPMENT_WEAK, score > 3 )
	city:SetStatus( CityStatus.DEVELOPMENT_DANGER, score > 6 )

	--military evaluation
	local adjaPower
	local group = Asset_Get( city, CityAssetID.GROUP )
	local power, maxPower = city:GetSoldier( city )
	local reserves = city:GetPopu( CityPopu.RESERVES )

	--set default flag
	city:SetStatus( CityStatus.OLD_CAPITAL, city:IsCapital() or nil )
	city:SetStatus( CityStatus.SAFETY )
	city:SetStatus( CityStatus.BATTLEFRONT )
	city:SetStatus( CityStatus.FRONTIER )
	city:SetStatus( CityStatus.BUDGET_DANGER, City_IsBudgetDanger( city ) )

	city:SetStatus( CityStatus.DEFENSIVE_WEAK )
	city:SetStatus( CityStatus.DEFENSIVE_DANGER )

	--soldier less than half
	city:SetStatus( CityStatus.RESERVE_NEED, maxPower - power )
	city:SetStatus( CityStatus.RESERVE_UNDERSTAFFED, power + power < maxPower )

	local defenderScores = 
	{
		{ ratio = 4,   score = 80, },
		{ ratio = 3,   score = 60, },
		{ ratio = 2,   score = 40, },
		{ ratio = 1.5, score = 30, },
		{ ratio = 1,   score = 20,  },
	}

	local attackerScores = 
	{
		{ ratio = 1,   score = 0, },
		{ ratio = 1.5, score = 20, },
		{ ratio = 2,   score = 50, },
		{ ratio = 3,   score = 80, },
		{ ratio = 4,   score = 90, },
	}
	
	--city:SetStatus( CityStatus.PRODUCTION_BASE, true )
	Asset_Foreach( city, CityAssetID.ADJACENTS, function( adjaCity )
		local adjaGroup = Asset_Get( adjaCity, CityAssetID.GROUP )
		if adjaGroup ~= group then
			city:SetStatus( CityStatus.SAFETY, nil )

			if Dipl_IsAtWar( adjaGroup, group ) then
				--print( String_ToStr( city, "name" ), String_ToStr( adjaCity, "name" ), String_ToStr( adjaGroup, "name" ), String_ToStr( group, "name" ) )
				city:SetStatus( CityStatus.BATTLEFRONT, true )
				--Debug_Log( city.name, "is battlefront" )
				Debug_Log( "status=" .. city:ToString( "STATUS" ) )
			else				
				city:SetStatus( CityStatus.FRONTIER, true )
			end

			if typeof( adjaCity ) ~= "table" then
				--should to do
			end

			adjaPower = Intel_Get( adjaCity, city, CityIntelType.DEFENDER )
			if adjaPower == -1 then
				return
			end
			
			local atkEvl = MathUtil_Approximate( ( power + reserves ) / adjaPower, attackerScores, "ratio", true )			
			if atkEvl.score <= 20 then
				if Random_GetInt_Sync( 1, 100 ) < 50 then
					--InputUtil_Pause( city.name, "self=" .. power + reserves, "adja=" .. adjaPower, adjaCity:ToString( "MILITARY") )
					city:SetStatus( CityStatus.AGGRESSIVE_WEAK, true )
					city:SetStatus( CityStatus.AGGRESSIVE_ADV )
				end
			elseif atkEvl.score >= 80 then
				if Random_GetInt_Sync( 1, 100 ) < 50 then
					--InputUtil_Pause( city.name, "self=" .. power + reserves, "adja=" .. adjaPower, adjaCity:ToString( "MILITARY") )
					city:SetStatus( CityStatus.AGGRESSIVE_ADV, true )
					city:SetStatus( CityStatus.AGGRESSIVE_WEAK )
				end
			end

			adjaPower = Intel_Get( adjaCity, city, CityIntelType.SOLDIER )
			if adjaPower == -1 then
				return
			end

			local defEvl = MathUtil_Approximate( adjaPower / power, defenderScores, "ratio" )
			if defEvl.score >= 80 then
				if Random_GetInt_Sync( 1, 100 ) < 50 then
					city:SetStatus( CityStatus.DEFENSIVE_DANGER, true )
				end
			elseif defEvl.score >= 20 then
				if Random_GetInt_Sync( 1, 100 ) < 50 then
					city:SetStatus( CityStatus.DEFENSIVE_WEAK, true )
				end
			end
		end
	end )

	--Reduce time
	local cur = Asset_GetDictItem( city, CityAssetID.STATUSES, CityStatus.VIGILANT )
	if cur then
		cur = cur - g_elapsed
		city:SetStatus( CityStatus.VIGILANT, cur <= 0 and nil or cur )
	end

	--debug flag
	Asset_Foreach( city, CityAssetID.STATUSES, function ( value, status )
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
	if params.agri then
		local cur = Asset_Get( city, CityAssetID.AGRICULTURE )
		local max = Asset_Get( city, CityAssetID.MAX_AGRICULTURE )
		Asset_Set( city, CityAssetID.AGRICULTURE, math.min( max, cur + params.agri ) )
		Stat_Add( "Dev@Agr", params.agri, StatType.ACCUMULATION )
		Stat_Add( "Agr@" .. ( params.agri > 0 and "INC_TIMES" or "DEC_TIMES" ), 1, StatType.TIMES )
	end
	if params.comm then
		local cur = Asset_Get( city, CityAssetID.COMMERCE )
		local max = Asset_Get( city, CityAssetID.MAX_COMMERCE )
		Asset_Set( city, CityAssetID.COMMERCE, math.min( max, cur + params.comm ) )
		Stat_Add( "Dev@Comm", params.comm, StatType.ACCUMULATION )
		Stat_Add( "Comm@" .. ( params.comm > 0 and "INC_TIMES" or "DEC_TIMES" ), 1, StatType.TIMES )
	end
	if params.prod then
		local cur = Asset_Get( city, CityAssetID.PRODUCTION )
		local max = Asset_Get( city, CityAssetID.MAX_PRODUCTION )
		Asset_Set( city, CityAssetID.PRODUCTION, math.min( max, cur + params.prod ) )		
		Stat_Add( "Dev@Comm", params.prod, StatType.ACCUMULATION )
		Stat_Add( "Prod@" .. ( params.prod > 0 and "INC_TIMES" or "DEC_TIMES" ), 1, StatType.TIMES )
	end
	--InputUtil_Pause( "dev", params.agri, params.comm, params.prod )
end

--development natural change
function City_DevelopmentVary( city )
	local security = Asset_Get( city, CityAssetID.SECURITY )
	local isSiege = Asset_GetDictItem( city, CityAssetID.STATUSES, CityStatus.IN_SIEGE )

	local methods
	for _, item in pairs( Scenario_GetData( "CITY_DEVELOPMENT_VARY_RESULT" ) ) do
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

incagri = 0

--development changed by task
function City_Develop( city, progress, id )
	local methods
	for _, item in pairs( Scenario_GetData( "CITY_DEVELOP_RESULT" ) ) do
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
	incagri = incagri + agri
	--print( "city dev", incagri, agri )
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
			local num = Asset_GetDictItem( city, CityAssetID.POPU_STRUCTURE, CityPopu[type] )
			if num then
				tax = tax + value * num
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
	for type, _ in pairs( CityPopu ) do
		local value = popustparams.POPU_COMMERCE_TAX[type]
		if value then
			local num = Asset_GetDictItem( city, CityAssetID.POPU_STRUCTURE, CityPopu[type] )
			if num then
				tax = tax + num * value
			end
		end
	end
	local modifier = Random_GetInt_Sync( 40, 80 ) * 0.01
	return math.ceil( tax * modifier )
end

function City_CalcTradeTax( city )
	local tax = 0
	local popustparams = City_GetPopuParams( city )
	local group = Asset_Get( city, CityAssetID.GROUP )
	Asset_Foreach( city, CityAssetID.ADJACENTS, function ( adjaCity )		
		local factor = 0.5
		local adjaGroup = Asset_Get( adjaCity, CityAssetID.GROUP )
		if adjaGroup ~= group then
			factor = factor + 0.25
		end
		if Dipl_IsBelong( adjaGroup, group ) or Dipl_IsBelong( group, adjaGroup ) then
			factor = factor + 0.25
		end
		if Dipl_HasPact( group, adjaGroup, RelationPact.TRADE ) then
			factor = factor + 0.5
		end
		if Dipl_IsAtWar( adjaGroup, group ) == true then
			factor = factor * 0.25
		end
		for type, _ in pairs( CityPopu ) do
			local value = popustparams.POPU_TRADE_TAX[type]
			if value then
				local num = Asset_GetDictItem( city, CityAssetID.POPU_STRUCTURE, CityPopu[type] )
				tax = tax + num * factor * value
			end
		end
	end )
	return math.ceil( tax )
end

function City_GetMonthTax( city, month )
	local income, tradeTax, personalTax, commerTax = 0, 0, 0, 0
	if not month then
		month = g_Time:GetMonth()
	end
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
	print( "personal=" .. City_CalcPersonalTax( city ), "comm=" .. City_CalcCommerceTax( city ), "trade=" .. City_CalcTradeTax( city ) )
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
	local money = Asset_Get( city, CityAssetID.MONEY )
	if money >= salary then
		city:UseMoney( salary )
		Stat_Add( "PaySalary@City_" .. city.name, salary, StatType.ACCUMULATION )

		Asset_Foreach( city, CityAssetID.CORPS_LIST, function ( corps )
			Asset_Foreach( corps, CorpsAssetID.TROOP_LIST, function ( troop )
				local value = troop:GetStatus( TroopStatus.DOWNCAST )
				if value then
					if value < 10 then
						value = 0
					else
						value = value * 0.5
					end
					troop:SetStatus( TroopStatus.DOWNCAST, value )
				end
			end )
		end)
	else
		city:UseMoney( money )		
		Stat_Add( "PaySalary@City_" .. city.name, money, StatType.ACCUMULATION )

		Asset_Foreach( city, CityAssetID.CORPS_LIST, function ( corps )
			Asset_Foreach( corps, CorpsAssetID.TROOP_LIST, function ( troop )
				local value = ( troop:GetStatus( TroopStatus.DOWNCAST ) or 10 ) * 2
				troop:SetStatus( TroopStatus.DOWNCAST, value )
			end )
		end)
	end
end

--levy money
function City_LevyTax( city, progress )
	local income = 0
	income = income + City_CalcPersonalTax( city )
	
	--bonus by progress
	income = math.ceil( income * math.min( 2.5, math.max( 0.2, progress * 0.01 ) ) )

	Asset_Plus( city, CityAssetID.MONEY, income )
	--Stat_Add( city.name .. "@LevyTax", "money=" .. income, StatType.LIST )
	Stat_Add( city.name .. "@LevyTax", income, StatType.ACCUMULATION )
	--Debug_Log( "City=" .. city.name .. " Levy tax=" .. income .. " Money=" .. Asset_Get( city, CityAssetID.MONEY ) )	
	return income
end

function City_Build( city, construction )
	--insert list manually to pass the sanity checker
	city:BuildConstruction( construction )
end

function City_Pillage( city )
	local agri = math.ceil( Asset_Get( city, CityAssetID.AGRICULTURE ) * -0.01 )
	local comm = math.ceil( Asset_Get( city, CityAssetID.COMMERCE ) * -0.01 )
	local prod = math.ceil( Asset_Get( city, CityAssetID.PRODUCTION ) * -0.01 )
	City_IncreaseDevelopment( city, { agri = agri, comm = comm, prod = prod } )	
	Stat_Add( "Pillage@" .. city.name, 1, StatType.TIMES )
	Debug_Log( "pillage in=" .. city:ToString() )
end

function City_DestroyDefensive( city )
	local list = {}
	Asset_Foreach( city, CityAssetID.CONSTR_LIST, function ( constr, index )		
		if constr.type == "DEFENSIVE" then
			table.insert( list, index )
		end
	end )
	if #list == 0 then
		DBG_Warning( "why no defensive", city:ToString("CONSTRUCTION") .. " no defensive" )
	end

	local index = Random_GetListItem( list )
	Asset_RemoveIndexItem( city, CityAssetID.CONSTR_LIST, index )
end

function City_ConvReserves( city, params )
	local totalNum = 0
	for _, item in pairs( params ) do
		local from = CityPopu[item.from]
		local to   = CityPopu[item.to]
		if Random_GetInt_Sync( 1, 100 ) < item.prob then
			local rate = Random_GetInt_Sync( item.min_rate, item.max_rate )
			local old  = Asset_GetDictItem( city, CityAssetID.POPU_STRUCTURE, from )
			local new  = Asset_GetDictItem( city, CityAssetID.POPU_STRUCTURE, to )
			local number = math.ceil( old * rate * 0.0001 )
			totalNum = totalNum + number
			city:SetPopu( from, old - number )
			city:SetPopu( to,   new + number )
			--Debug_Log( "Conv " .. item.from .. ":" .. old .. "-" .. number .. " --> " .. item.to .. ":" .. new .. "+" .. number )
		end
	end
	return totalNum
end

function City_Instruct( city, baseType )
	if baseType then
		city:SetStatus( baseType, true )
		Debug_Log( "instruct city=" .. city.name, " -->" .. MathUtil_FindName( CityStatus, baseType ) )
	else
		city:SetStatus( CityStatus.ADVANCED_BASE, nil )
		city:SetStatus( CityStatus.PRODUCTION_BASE, nil )
		city:SetStatus( CityStatus.MILITARY_BASE, nil )
	end
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
		--city:DumpGrowthAttrs()
		--city:DumpProperty()

		--1st event turn
		if day % 15 == 0 then
			City_Event( city )
		end

		--2nd population
		if day == 1 then
			City_PopuConv( city )
			City_PopuGrow( city )
		end

		--3rd income /consume
		if day == 1 then
			if month == 9 then
				City_Harvest( city )
			end
			
			City_Produce( city )

			City_CollectTax( city )

			City_PaySalary( city )
		end

		if day % 10 == 0 then
			City_Mental( city )
		end		

		--if day % 15 == 1 then City_DevelopmentVary( city ) end

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
		
		if day == DAY_IN_MONTH then
			City_CheckFlag( city )
		end

		city:Update()

	end )	
	if month == 1 and day == 1 then
		--InputUtil_Pause( g_Time:ToString() )
	end
end