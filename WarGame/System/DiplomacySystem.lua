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
		return relation and relation:HasOpinion( RelationOpinion.AT_WAR )
	end

	return System_Get( SystemType.DIPLOMACY_SYS ):HasOpinion( red, RelationOpinion.AT_WAR )
end

function Dipl_CanDeclareWar( relation )
	if relation:HasOpinion( RelationOpinion.AT_WAR ) == true then return false end

	--InputUtil_Pause("can dec", relation:ToString("ALL") )
	if relation:HasPact( RelationPact.NO_WAR ) == true then return false end
	if relation:HasPact( RelationPact.ALLY ) == true then return false end
	if relation:HasPact( RelationPact.PROTECT ) == true then return false end
	return true
end

function Dipl_GetPossiblePact( relation, pactList )
	local datas = Scenario_GetData( "RELATION_PACT" )
	local attitude = Asset_Get( relation, RelationAssetID.ATTITUDE )	
	for _, item in ipairs( datas ) do
		local match = true
		-- prob, attitude_above, has_opinion, no_opinion, duration_above, has_pact, 
		if match == true and item.prob and Random_GetInt_Sync( 1, 100 ) > item.prob then
			match = false
		end		
		if match == true and item.attitude_above and attitude < item.attitude_above then
			match = false
		end
		local opinion
		if match == true and item.no_opinion then
			opinion = relation:GetOpinion( RelationOpinion[item.no_opinion] )
			if opinion then
				match = false
			end
		end
		if match == true and item.has_opinion then
			opinion = relation:GetOpinion( RelationOpinion[item.has_opinion] )
			if not opinion then
				match = false
			end
		end
		if match == true and item.duration_above and opinion then
			if opinion.duration < item.duration_above then
				match = false
			end
		end
		local pact
		if match == true and item.has_pact then
			pact = relation:GetPact( RelationPact[item.has_pact] )
			if not pact then
				match = false
			end
		end
		if match == true and item.no_pact then
			pact = relation:GetPact( RelationPact[item.no_pact] )
			if pact then
				match = false
			end
		end
		if match == true then
			table.insert( pactList, { pact = item.pact, time = item.time } )
		end
	end
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
	relation:AddOpinion( RelationOpinion.TRUST )

	if not _groupRelations[red] then _groupRelations[red] = {} end
	if not _groupRelations[blue] then _groupRelations[blue] = {} end
	_groupRelations[red][blue] = relation
	_groupRelations[blue][red] = relation

	--InputUtil_Pause( "re", _groupRelations[red][blue], _groupRelations[blue][red] )

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