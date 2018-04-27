--------------------------------------------------------------
--
-- 
--
--
--
--------------------------------------------------------------

function Dipl_IsAtWar( red, blue )
	if red == blue then return false end
	--if 1 then return true end

	if blue then
		local relation = System_Get( SystemType.DIPLOMACY_SYS ):GetRelation( red, blue )
		return relation and relation:GetPact( RelationPact.AT_WAR )
	end

	return System_Get( SystemType.DIPLOMACY_SYS ):HasOpinion( red, RelationOpinion.AT_WAR )
end

function Dipl_CanDeclareWar( relation )
	print( relation:ToString( "ALL"  ) )
	if relation:HasPact( RelationPact.NO_WAR ) == true then return false end
	if relation:HasPact( RelationPact.ALLY ) == true then return false end
	if relation:HasPact( RelationPact.PROTECT ) == true then return false end
	return true
end

function Dipl_GetPossiblePact( relation )

end

function Dipl_GetRelations( group )
	return System_Get( SystemType.DIPLOMACY_SYS ):GetRelations( group )
end

function Dipl_ImproveRelation( group, oppGroup, attitude )
	local relation = System_Get( SystemType.DIPLOMACY_SYS ):GetRelation( group, oppGroup )
	relation:ImproveRelation( attitude )
end

function Dipl_DeclareWar( group, oppGroup )
	local relation = System_Get( SystemType.DIPLOMACY_SYS ):GetRelation( group, oppGroup )
	relation:DeclareWar()
end

function Dipl_SignPact( group, oppGroup, pact, time )
	local relation = System_Get( SystemType.DIPLOMACY_SYS ):GetRelation( group, oppGroup )
	relation:SignPact( pact, time )
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
	local day = g_Time:GetDay()
	Entity_Foreach( EntityType.RELATION, function ( relation )
		relation:Update()
		if day % 30 == 1 then
			--InputUtil_Pause( Asset_Get( relation, RelationAssetID.RED_GROUP ).name, Asset_Get( relation, RelationAssetID.BLUE_GROUP ).name, Asset_Get( relation, RelationAssetID.ATTITUDE ) )
		end
	end )
end

--remove given group relative relations, maybe group was vanished
function DiplomacySystem:RemoveRelation( group )
	local list = _groupRelations[group]
	for _, relation in pairs( list ) do
		local opp = relation:GetOppGroup()
		local oppList = _groupRelations[opp]
		oppList[group] = nil
	end
	_groupRelations[group] = nil
end

function DiplomacySystem:GetRelation( red, blue )
	if red == blue then return nil end

	local list = _groupRelations[red]	
	if list then
		local relation = list[blue]
		if relation then return relation end
	end
	
	relation = Entity_New( EntityType.RELATION )
	Asset_Set( relation, RelationAssetID.RED_GROUP, red )
	Asset_Set( relation, RelationAssetID.BLUE_GROUP, blue )
	Asset_SetListItem( relation, RelationAssetID.OPINION_LIST, RelationOpinion.TRUST, Scenario_GetData( "RELATION_OPINION" )[RelationOpinion.TRUST].def )

	if not _groupRelations[red] then _groupRelations[red] = {} end
	if not _groupRelations[blue] then _groupRelations[blue] = {} end
	_groupRelations[red][blue] = relation
	_groupRelations[blue][red] = relation

	--InputUtil_Pause( "create reation between", red.name, blue.name )

	return relation	
end

function DiplomacySystem:HasOpinion( group, opinion )
	local list = _groupRelations[group]
	if not list then return false end

	for _, relation in pairs( list ) do
		if relation:HasOpinion( opinion ) == true then
			return true
		end
	end
	return false
end

function DiplomacySystem:GetRelations( group )
	return _groupRelations[group]
end