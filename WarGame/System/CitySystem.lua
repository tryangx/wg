CityDevelopMethod = 
{
	{
		security_more_than = 80,
		prob = 100,
		method = 
		{
			{ prob = 50, agr = 5, comm = -1, prod = -1, },
			{ prob = 50, agr = -1, comm = 5, prod = -1, },
			{ prob = 50, agr = -1, comm = -1, prod = 5, },

			{ prob = 50, agr  = 3 },
			{ prob = 50, comm = 3 },
			{ prob = 50, prod = 3, },

			{ prob = 50, agr = 1, comm = 1, prod = 1, },
			{ prob = 50, agr = 1, comm = 1, prod = 1, },
			{ prob = 50, agr = 1, comm = 1, prod = 1, },
		},		
	},
	{
		security_more_than = 60,
		prob = 100,
		method = 
		{
			{ prob = 50, agr = 2, comm = 1, prod = 0, },
			{ prob = 50, agr = 2, comm = 0, prod = 1, },
			{ prob = 50, agr = 1, comm = 2, prod = 0, },
			{ prob = 50, agr = 0, comm = 2, prod = 1, },
			{ prob = 50, agr = 1, comm = 0, prod = 2, },
			{ prob = 50, agr = 0, comm = 1, prod = 2, },

			{ prob = 50, agr = 0, comm = 0, prod = 2, },
		},
	},
	{	
		security_more_than = 40,
		prob = 100,
		method = 
		{
			-- -3 ~ 1
			{ prob = 50, agr = 3, comm = -1, prod = -1, },
			{ prob = 50, agr = -1, comm = 3, prod = -1, },
			{ prob = 50, agr = -1, comm = -1, prod = 3, },
			{ prob = 50, agr  = -2, },
			{ prob = 50, comm = -2, },
			{ prob = 50, prod = -2, },
			{ prob = 50, agr = -1, comm = -1, prod = -1, },
		},		
	},
	{	
		security_more_than = 0,
		prob = 100,
		method = 
		{
			-- -6 ~ -5
			{ prob = 20, agr = -2, comm = -2, prod = -2, },
			{ prob = 40, agr = -3, comm = -1, prod = -1, },
			{ prob = 40, agr = -1, comm = -3, prod = -1, },
			{ prob = 40, agr = -1, comm = -1, prod = -3, },
		},
	},
	{
		insiege = true,
		prob = 100,
		method = 
		{
			{ prob = 50, agr = -2, comm = -2, prod = -2, },
		},
	},
}

-------------------------------------------------------

local function City_GetPopuParams( city )
	return GetScenarioData( "CITY_POPUSTRUCTURE_PARAMS" )[1]
end

-------------------------------------------------------

--collet material
local function City_Produce( city )
	local income = 0
	local popustparams = City_GetPopuParams( city )
	for k, v in pairs( CityPopu ) do
		if popustparams.POPU_PRODUCE[k] then
			income = income + popustparams.POPU_PRODUCE[k] * v
		end
	end
	Asset_Plus( city, CityAssetID.MATERIAL, income )
	--InputUtil_Pause( "City=" .. city.name .. " collect mat=" .. income .. " Material=" .. Asset_Get( city, CityAssetID.MATERIAL ) )	
end

--collect money
local function City_Tax( city )
	local income = 0
	local popustparams = City_GetPopuParams( city )
	for k, v in pairs( CityPopu ) do
		if popustparams.POPU_TAX[k] then
			income = income + popustparams.POPU_TAX[k] * v
		end
	end
	Asset_Plus( city, CityAssetID.MONEY, income )
	--InputUtil_Pause( "City=" .. city.name .. " collect tax=" .. income .. " Money=" .. Asset_Get( city, CityAssetID.MONEY ) )	
	return income
end

--collect food
local function City_Harvest( city )
	local income = 0
	local popustparams = City_GetPopuParams( city )
	for k, v in pairs( CityPopu ) do
		if popustparams.POPU_HARVEST[k] then
			income = income + popustparams.POPU_HARVEST[k] * v
		end
	end	
	Asset_Plus( city, CityAssetID.FOOD, income )
	--InputUtil_Pause( "City=" .. city.name .. " collect food=" .. income .. " Food=" .. Asset_Get( city, CityAssetID.FOOD ) )
	return income
end

local function City_Develop( city )
	local security = Asset_Get( city, CityAssetID.SECURITY )
	local isSiege = Asset_GetListItem( city, CityAssetID.STATUSES, CityStatus.SIEGE )
	local findMethod = nil
	for _, item in pairs( CityDevelopMethod ) do
		--init datas
		if not item.total_prob then
			item.total_prob = 0
			for _, method in ipairs( item.method ) do
				item.total_prob = item.total_prob + method.prob
			end
		end
		if not item.prob or Random_GetInt_Sync( 1, 100 ) < item.prob then
		if ( not item.insiege or item.insiege == isSiege ) and
		 ( not item.security_more_than or security > item.security_more_than ) then
			local dice = Random_GetInt_Sync( 1, item.total_prob )
			for _, method in ipairs( item.method ) do
				if dice <= method.prob then
					findMethod = method
					break
				else
					dice = dice - method.prob
				end
			end
		end
		end
		if findMethod then break end
	end
	if not findMethod then
		--InputUtil_Pause( "no develop method" )
		return
	end
	if findMethod.agr and findMethod.agr > 0 then
		local cur = Asset_Get( city, CityAssetID.AGRICULTURE )
		local max = Asset_Get( city, CityAssetID.MAX_AGRICULTURE )
		Asset_Set( city, CityAssetID.AGRICULTURE, math.min( max, cur + findMethod.agr ) )
		Stat_Add( "Agr Times", city.id, StatType.TIMES )
		Stat_Add( "Agr Inc", findMethod.agr, StatType.ACCUMULATION )
	end
	if findMethod.comm and findMethod.comm > 0 then
		local cur = Asset_Get( city, CityAssetID.COMMERCE )
		local max = Asset_Get( city, CityAssetID.MAX_COMMERCE )
		Asset_Set( city, CityAssetID.COMMERCE, math.min( max, cur + findMethod.comm ) )
		Stat_Add( "Comm Times", city.id, StatType.TIMES )
		Stat_Add( "Comm Inc", findMethod.comm, StatType.ACCUMULATION )
	end
	if findMethod.prod and findMethod.prod > 0 then
		local cur = Asset_Get( city, CityAssetID.PRODUCTION )
		local max = Asset_Get( city, CityAssetID.MAX_PRODUCTION )
		Asset_Set( city, CityAssetID.PRODUCTION, math.min( max, cur + findMethod.prod ) )
		Stat_Add( "Prod Times", city.id, StatType.TIMES )
		Stat_Add( "Prod Inc", findMethod.prod, StatType.ACCUMULATION )
	end
end

--------------------------------------
-- City Population Structure

function City_NeedPopu( city, poputype )
	local cityparams = City_GetPopuParams( city )
	local needparam = cityparams.POPU_NEED_RATIO
	local unitparam  = cityparams.POPU_PER_UNIT

	if needparam[poputype] then
		local popu   = Asset_Get( city, CityAssetID.POPULATION )
		return math.floor( needparam[poputype] * popu )
	end		
	if poputype == "FARMER" then
		return Asset_Get( city, CityAssetID.AGRICULTURE ) * unitparam[poputype]
	elseif poputype == "WORKER" then
		return Asset_Get( city, CityAssetID.PRODUCTION ) * unitparam[poputype]
	elseif poputype == "MERCHANT" then
		return Asset_Get( city, CityAssetID.COMMERCE ) * unitparam[poputype]
	end
	return 0
end

function City_InitPopuStructure( city )
	local popu   = Asset_Get( city, CityAssetID.POPULATION )
	local popustparams = City_GetPopuParams( city )
	local needparam  = popustparams.POPU_NEED_RATIO
	local plebparam  = popustparams.IS_PLEB
	local initparam  = popustparams.POPU_INIT
	
	local nums = {}	
	local notpleb = 0
	for k, v  in pairs( CityPopu ) do
		if not plebparam[k] then
			local num = math.floor( popu * needparam[k] * Random_GetInt_Sync( initparam[k].min, initparam[k].max ) * 0.01 )
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

	city:DumpPopu()
end

local function City_PopuConv( city )
	local security = Asset_Get( city, CityAssetID.SECURITY )
	local satisfaction = Asset_Get( city, CityAssetID.SATISFACTION )

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
			if valid == true and flow.sat_more_than and satisfaction < flow.sat_more_than then valid = false end
			if valid == true and flow.sec_less_than and satisfaction > flow.sec_less_than then valid = false end
			if valid == true and flow.sat_less_than and satisfaction > flow.sat_less_than then valid = false end
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

local function City_Mental( city )	
	local list     = Asset_GetList( city, CityAssetID.POPU_STRUCTURE )
	local popu     = Asset_Get( city, CityAssetID.POPULATION )
	local soldier  = list[CityPopu.SOLDIER] or 0
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
	
	local satisfaction = Asset_Get( city, CityAssetID.SATISFACTION )
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

	
	if satisfaction > security then
		satisfaction = satisfaction - math.floor( ( satisfaction - security ) * 0.1 + 1 )
	elseif security > 50 then
		if satisfaction < satisfaction_std and security > satisfaction then
			satisfaction = satisfaction + math.floor( ( satisfaction_std - satisfaction ) * 0.1 + 1 )
		end
	end	

	Asset_Set( city, CityAssetID.SECURITY, security )
	Asset_Set( city, CityAssetID.SATISFACTION, satisfaction )

	Track_Data( "security", security )
	Track_Data( "satisfaction", satisfaction )
	--Track_Dump()

	--if security < satisfaction then InputUtil_Pause() end
end

local function City_PopuGrow( city )
	local rate  = 1 / GlobalTime.MONTH_PER_YEAR
	local population = Asset_Get( city, CityAssetID.POPULATION )
	local growthRate = Random_GetInt_Sync( PopulationParams.GROWTH_MIN_RATE , PopulationParams.GROWTH_MAX_RATE )
	local sec = Asset_Get( city, CityAssetID.SECURITY )
	local sat = Asset_Get( city, CityAssetID.SATISFACTION )

	--increase children
	local increase = math.ceil( population * growthRate * rate * ( 100 + ( sec + sat ) ) * 0.000005 )
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

local function City_CheckFlag( city )	
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
	local power = City_GetMilitaryPower( city )
	Asset_ForeachList( city, CityAssetID.ADJACENTS, function( adjaCity )
		local adjaGroup = Asset_Get( adjaCity, CityAssetID.GROUP )
		if adjaGroup ~= group then
			local adjaPower = City_GetMilitaryPowerWithIntel( adjaCity, group )
			if adjaPower > ( power + power + power ) then score = score + 1 end
			if adjaPower > ( power + power ) then score = score + 1 end
			if adjaPower > power * 1.5 then score = score + 1 end
			if adjaPower > power * 1.2 then score = score + 1 end
		end
	end )
	Asset_SetListItem( city, CityAssetID.STATUSES, CityStatus.MILITARY_WEAK,   score > 3 )
	Asset_SetListItem( city, CityAssetID.STATUSES, CityStatus.MILITARY_DANGER, score > 6 )
end

--------------------------------------

local function City_Event( city )	
	--System_Get( SystemType.EVENT_SYS ):Trigger( city )
end

--------------------------------------

CitySystem = class()

function CitySystem:__init()
	System_Setup( self, SystemType.CITY_SYS, "GrowthSystem" )
end

function CitySystem:Start()
end

function CitySystem:Update()
	local month = g_calendar:GetMonth()
	local day   = g_calendar:GetDay()

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

		if day % 30 == 0 then
			City_Produce( city )
		end
		
		if day % 30 == 0 then
			City_Tax( city )
		end

		if month % 9 == 0 then
			City_Harvest( city )
		end

		if day % 10 == 0 then
			City_Mental( city )
		end		

		if day % 10 == 0 then
			City_Develop( city )
		end

		if day % 30 == 0 then
			City_PopuConv( city )
		end

		if day % 30 == 0 then
			City_PopuGrow( city )
		end

		if day % 10 == 0 then
			City_CheckFlag( city )
		end
	end )
end