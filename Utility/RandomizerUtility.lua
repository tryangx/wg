Randomizer = class()

function Randomizer:__init( seed )
	self.seed = seed or 0
	--print( "seed=", seed )
end

function Randomizer:GetSeed( seed )
	return self.seed
end

function Randomizer:SetSeed( seed )
	self.seed = seed
end

function Randomizer:GetInt( min, max )
	self.seed = ( self.seed * 32765 + 12345 ) % 2147483647
	if min < max then
		return self.seed % ( max - min ) + min
	elseif min > max then
		return self.seed % ( min - max ) + max
	end
	return min
end

-------------------------------------------

local _randomizer = Randomizer()
local _unsyncRandomizer = Randomizer()

function Random_SetSeed_Sync( seed )
	_randomizer:SetSeed( seed )
end
function Random_SetSeed_Unsync( seed )
	_unsyncRandomizer:SetSeed( seed )
end
function Random_SetSeed( seed )
	Random_SetSeed_Sync( seed )
end
function Random_GetInt_Sync( min, max )
	return _randomizer:GetInt( min, max )
end
function Random_GetInt_Unsync( min, max )
	return _unsyncRandomizer:GetInt( min, max )
end
function Random_GetInt( min, max )
	return Random_GetInt_Sync( min, max )
end

-------------------------------------------------

--[[
	@usage
	local list = 
	{
		{ prob = 10, ret = 1 },
		{ prob = 20, ret = 1 },
	}
	print( Random_GetIndex_Sync( list, "prob" ) )
--]]
function Random_GetIndex_Sync( list, probName )
	local totalProb = Cache_Get( list )
	if not totalProb then
		totalProb = MathUtil_SumIf( list, probName, nil, probName )
		Cache_Set( list, totalProb )
	end
	local prob = Random_GetInt_Sync( 1, totalProb )
	for index, data in pairs( list ) do
		if prob <= data[probName] then
			return index
		else
			prob = prob - data[probName]
		end
	end
	return nil
end

--[[
	@usage
	local list = 
	{
		{ prob = 10, ret = 1 },
		{ prob = 20, ret = 1 },
	}
	print( Random_GetTable_Sync( list, "prob" ) )
--]]
function Random_GetTable_Sync( list, probName )
	local totalProb = Cache_Get( list )
	if not totalProb then
		totalProb = MathUtil_SumIf( list, probName, nil, probName )
		Cache_Set( list, totalProb )
	end
	local prob = Random_GetInt_Sync( 1, totalProb )
	for index, data in pairs( list ) do
		if prob <= data[probName] then
			return list[index], index
		else
			prob = prob - data[probName]
		end
	end
	return nil
end

function Random_GetListData( entity, id )
	local number = Asset_GetListSize( entity, id )
	if number == 0 then return nil end
	return Asset_GetListItem( entity, id, Random_GetInt_Sync( 1, number ) )
end

function Random_GetListItem( list )
	local number = #list
	if number == 0 then return nil end
	return list[Random_GetInt_Sync( 1, number )]
end