--------------------------------------------------------------
--
-- 
--
--
--
--------------------------------------------------------------

function Dipl_IsAtWar( red, blue )
	if 1 then return true end
	local relation = System_Get( SystemType.DIPLOMACY_SYS ):GetRelation( red, blue )
	return relation and relation:GetPact( RelationPact.AT_WAR )
end

--------------------------------------------------------------

-- data structure: [group] = relation
local _groupRelations = {}

DiplomacySystem = class()

function DiplomacySystem:__init()
	System_Setup( self, SystemType.DIPLOMACY_SYS )
end

function DiplomacySystem:Start()
	Entity_Foreach( EntityType.GROUP, function ( red )
		Entity_Foreach( EntityType.GROUP, function ( blue )
			self:GetRelation( red, blue )
		end)
	end)
end

function DiplomacySystem:Update()	
	local day = g_calendar:GetDay()
	Entity_Foreach( EntityType.RELATION, function ( relation )
		relation:Update()
		if day % 30 == 1 then
			--InputUtil_Pause( Asset_Get( relation, RelationAssetID.RED_GROUP ).name, Asset_Get( relation, RelationAssetID.BLUE_GROUP ).name, Asset_Get( relation, RelationAssetID.ATTITUDE ) )
		end
	end)	
end

function DiplomacySystem:GetRelation( red, blue )
	if red == blue then return nil end

	local relation = _groupRelations[red]
	if relation then return relation end
	
	relation = Entity_New( EntityType.RELATION )
	Asset_Set( relation, RelationAssetID.RED_GROUP, red )
	Asset_Set( relation, RelationAssetID.BLUE_GROUP, blue )
	Asset_SetListItem( relation, RelationAssetID.OPINION_LIST, RelationOpinion.TRUST, Scenario_GetData( "RELATION_OPINION" )[RelationOpinion.TRUST].def )
	_groupRelations[red] = relation
	_groupRelations[blue] = relation

	--InputUtil_Pause( "create reation between", red.name, blue.name )

	return relation	
end

