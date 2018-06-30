RankingType = 
{
	TERRIORITY     = 1,

	MILITARY_POWER = 2,
}

function Ranking_GetGroupRanking( type, group )
	return System_Get( SystemType.RANKING_SYS ):GetRanking( type, group )
end

-----------------------------------------

local _rankings = {}

RankingSystem = class()

function RankingSystem:__init()
	System_Setup( self, SystemType.RANKING_SYS )
end

function RankingSystem:Start()
end

function RankingSystem:ClearRanking( type )
	if _rankings[type] then 
		_rankings[type] = { total = 0, list = {} }
	end
end

function RankingSystem:GetRankingData( type )
	if not _rankings[type] then
		_rankings[type] = { total = 0, list = {} }
	end
	local rankingData = _rankings[type]
	return rankingData
end

function RankingSystem:AddRanking( type, obj, value )
	local rankingData = self:GetRankingData( type )
	table.insert( rankingData.list, { obj = obj, value = value } )
	rankingData.total = rankingData.total + value
	--print( obj.name, value )
end

--return ranking, value
function RankingSystem:GetRanking( type, obj )
	local rankingData = self:GetRankingData( type )
	for ranking, item in ipairs( rankingData.list ) do
		if item.obj == obj then
			return ranking, value, math.floor( item.value * 100 / rankingData.total )
		end
	end
	return 0, 0, 0
end

function RankingSystem:Update()
	local day = g_Time:GetDay()
	if day == DAY_IN_MONTH then
		
		self:ClearRanking( RankingType.TERRIORITY )
		self:ClearRanking( RankingType.MILITARY_POWER )

		Entity_Foreach( EntityType.GROUP, function ( group )
			self:AddRanking( RankingType.TERRIORITY, group, group:GetTerriority() )
			self:AddRanking( RankingType.MILITARY_POWER, group, group:GetMilitaryPower() )
		end)

		table.sort( self:GetRankingData( RankingType.TERRIORITY ).list, function( l, r ) return l.value > r.value end )
		table.sort( self:GetRankingData( RankingType.MILITARY_POWER ).list, function( l, r ) return l.value > r.value end )
	end
end
