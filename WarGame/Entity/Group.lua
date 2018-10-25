GroupAssetType = 
{
	BASE_ATTRIB      = 1,
	PROPERTY_ATTRIB  = 2,
	GROWTH_ATTRIB    = 3,
}

GroupAssetID = 
{
	LEADER         = 102,
	CAPITAL        = 103,	
	GOVERNMENT     = 104,
	GRADE          = 105,

	CHARA_LIST     = 201,
	CITY_LIST      = 202,
	CORPS_LIST     = 203,

	MONEY          = 210,
	MATERIAL       = 211,	

	STATUSES       = 220,
	INFLUENCES     = 221,
	REPUTATIONS    = 222,

	TECH_LIST      = 301,
	GOAL_LIST      = 302,
	TAG_LIST       = 303,
	SPY_LIST       = 304,
}

GroupAssetAttrib =
{
	leader    = AssetAttrib_SetPointer( { id = GroupAssetID.LEADER,        type = GroupAssetType.BASE_ATTRIB, setter = Entity_SetChara } ),
	capital   = AssetAttrib_SetPointer( { id = GroupAssetID.CAPITAL,       type = GroupAssetType.BASE_ATTRIB, setter = Entity_SetCity } ),
	government = AssetAttrib_SetNumber( { id = GroupAssetID.GOVERNMENT,    type = GroupAssetType.BASE_ATTRIB, enum = GroupGovernment, default = GroupGovernment.KINGDOM } ),	
	grade      = AssetAttrib_SetNumber( { id = GroupAssetID.GRADE,         type = GroupAssetType.BASE_ATTRIB, default = GroupGrade.LOCAL } ),

	charas    = AssetAttrib_SetPointerList   ( { id = GroupAssetID.CHARA_LIST,    type = GroupAssetType.PROPERTY_ATTRIB, setter = Entity_SetChara } ),
	cities    = AssetAttrib_SetPointerList   ( { id = GroupAssetID.CITY_LIST,     type = GroupAssetType.PROPERTY_ATTRIB, setter = Entity_SetCity } ),
	corpses   = AssetAttrib_SetPointerList   ( { id = GroupAssetID.CORPS_LIST,    type = GroupAssetType.PROPERTY_ATTRIB, setter = Entity_SetCorps } ),

	money     = AssetAttrib_SetNumber( { id = GroupAssetID.MONEY,    type = GroupAssetType.PROPERTY_ATTRIB } ),
	material  = AssetAttrib_SetNumber( { id = GroupAssetID.MONEY,    type = GroupAssetType.PROPERTY_ATTRIB } ),

	statuses   = AssetAttrib_SetDict   ( { id = GroupAssetID.STATUSES,   type = GroupAssetType.BASE_ATTRIB } ),
	influences = AssetAttrib_SetDict   ( { id = GroupAssetID.INFLUENCES,  type = GroupAssetType.BASE_ATTRIB } ),
	reputations= AssetAttrib_SetDict   ( { id = GroupAssetID.REPUTATIONS, type = GroupAssetType.BASE_ATTRIB } ),

	techs     = AssetAttrib_SetList          ( { id = GroupAssetID.TECH_LIST,     type = GroupAssetType.GROWTH_ATTRIB } ),
	goals     = AssetAttrib_SetDict          ( { id = GroupAssetID.GOAL_LIST,     type = GroupAssetType.GROWTH_ATTRIB } ),
	tags      = AssetAttrib_SetPointerList   ( { id = GroupAssetID.TAG_LIST,      type = GroupAssetType.GROWTH_ATTRIB } ),
	spys      = AssetAttrib_SetDict          ( { id = GroupAssetID.SPY_LIST,      type = GroupAssetType.GROWTH_ATTRIB } ),
}

-------------------------------------------

Group = class()

function Group:__init()
	Entity_Init( self, EntityType.GROUP, GroupAssetAttrib )
end

function Group:ToString( type )
	
	local content = "[" .. self.name .. "]"

	if type == "BRIEF" or type == "ALL" then
		content = content .. " leader=" .. String_ToStr( Asset_Get( self, GroupAssetID.LEADER ), "name" )
		content = content .. " capital=" .. String_ToStr( Asset_Get( self, GroupAssetID.CAPITAL ), "name" )
		content = content .. " popu=" .. self:GetPopu( CityPopu.ALL )
		content = content .. " grd=" .. MathUtil_FindName( GroupGrade, Asset_Get( self, GroupAssetID.GRADE ) )
	end

	if type == "SIMPLE" or type == "ALL" then
		content = content .. " city=" .. Asset_GetListSize( self, GroupAssetID.CITY_LIST )
		content = content .. " chara=" .. Asset_GetListSize( self, GroupAssetID.CHARA_LIST )		
		content = content .. " corps=" .. Asset_GetListSize( self, GroupAssetID.CORPS_LIST )
	end
	if type == "POWER" or type == "ALL" then
		content = content .. " popu=" .. self:GetPopu( CityPopu.ALL )
		content = content .. " sldr=" .. self:GetPopu( CityPopu.SOLDIER )
		content = content .. " food=" .. self:GetProperty( CityAssetID.FOOD )
		content = content .. " money=" .. self:GetProperty( CityAssetID.MONEY )		
		content = content .. " mat=" .. self:GetProperty( CityAssetID.MATERIAL )
	end	
	if type == "CHARA" then
		Asset_Foreach( self, GroupAssetID.CHARA_LIST, function ( chara)
			content = content .. " " .. chara.name
		end)
	end
	if type == "DIPLOMACY" then
		local rels = Dipl_GetRelations( self )
		for _, rel in pairs( rels ) do
			content = content .. rel:ToString( "ALL" )
		end
	end
	if type == "GOAL" or type == "ALL" then
		Asset_Foreach( self, GroupAssetID.GOAL_LIST, function ( goalData, goalType )
			content = content .. " " .. MathUtil_FindName( GroupGoalType, goalType )
		end)
	end
	if type == "SPY" or type == "ALL" then
		content = content .. " spy="
		Asset_Foreach( self, GroupAssetID.SPY_LIST, function ( spy )
			content = content .. spy.city.name .. "=" .. spy.grade .. ","
		end)
	end
	if type == "ALL" then
		content = content .. "repu=" .. self:GetReputation() .. "-->"
		Asset_Foreach( self, GroupAssetID.REPUTATIONS, function ( data, type )
			content = content .. MathUtil_FindName( GroupReputation, type ) .. "=" .. data .. ","
		end)
		content = content .. "influ=" .. self:GetInfluence() .. "-->"
		Asset_Foreach( self, GroupAssetID.INFLUENCES, function ( data, type )
			content = content .. MathUtil_FindName( GroupInfluence, type ) .. "=" .. data .. ","
		end)
	end
	return content
end

function Group:Load( data )
	self.id = data.id
	self.name = data.name

	Asset_Set( self, GroupAssetID.LEADER, data.leader )
	Asset_Set( self, GroupAssetID.CAPITAL, data.capital )
	Asset_Set( self, GroupAssetID.GOVERNMENT, data.government )

	Asset_CopyList( self, GroupAssetID.CITY_LIST, data.cities )
	Asset_CopyList( self, GroupAssetID.CHARA_LIST, data.charas )
	Asset_CopyList( self, GroupAssetID.CORPS_LIST, data.corpses )

	Asset_Set( self, GroupAssetID.MONEY, data.money )
	Asset_Set( self, GroupAssetID.MATERIAL, data.material )

	Asset_CopyList( self, GroupAssetID.TECH_LIST, data.techs )
	Asset_CopyDict( self, GroupAssetID.GOAL_LIST, data.goals )
end

function Group:ClearVariableCache()
	self._reputation = nil
	self._influence = nil
end

function Group:VerifyData()
	local group = self

	--city belong the group
	Asset_Foreach( self, GroupAssetID.CITY_LIST, function( city )
		if not city or type( city ) == "number" then return end
		Asset_Set( city, CityAssetID.GROUP, group )
	end )
	
	--chara belongs to the group
	Asset_Foreach( self, GroupAssetID.CHARA_LIST, function( chara )
		if not chara or type( chara ) == "number" then return end
		Asset_Set( chara, CharaAssetID.GROUP, group )
	end )

	--corps belongs to the group
	Asset_Foreach( self, GroupAssetID.CORPS_LIST, function( corps )
		if not corps or type( corps ) == "number" then return end
		Asset_Set( corps, CorpsAssetID.GROUP, group )
	end )

	--verify chara
	local leader = Asset_Get( self, GroupAssetID.LEADER )
	Asset_Foreach( self, GroupAssetID.CHARA_LIST, function( chara )
		--check location and home
		local home = Asset_Get( chara, CharaAssetID.HOME )		
		if not home then
			home =  Asset_Get( self, GroupAssetID.CAPITAL )
			chara:JoinCity( home )
			CRR_Tolerate( chara.name .. " home correct to " .. String_ToStr( Asset_Get( chara, CharaAssetID.HOME ), "name" ) )
		end
		local loc = Asset_Get( chara, CharaAssetID.LOCATION )
		if not loc then
			chara:EnterCity( home )
			CRR_Tolerate( chara.name .. " loc correct to " .. String_ToStr( Asset_Get( chara, CharaAssetID.HOME ), "name" ) )
		end

		--check group
		if Asset_Get( chara, CharaAssetID.GROUP ) ~= self then
			Asset_Set( chara, CharaAssetID.GROUP, self )
		end

		--check title
		--1.leader of group should has grade 5 title
		--2.royal of leader should has grade 4 title
		--3.other?
		local title = Chara_FindNewTitle( chara )
		Asset_Set( chara, CharaAssetID.TITLE, title )
	end)

	--generate the superior and subordinates
	local grade = Group_FindFitGrade( group )
	if grade then
		Debug_Log( "set group grade=" .. MathUtil_FindName( GroupGrade, grade ), self.name )
		Asset_Set( self, GroupAssetID.GRADE, grade )
	end
end

function Group:Update( ... )
	self:ClearVariableCache()
	self:ElectLeader()
end

function Group:UpdateInfluences()
	local influences = 0
	local _, _, ter_percent = Ranking_GetGroupRanking( RankingType.TERRIORITY, self )
	local _, _, pow_percent = Ranking_GetGroupRanking( RankingType.MILITARY_POWER, self )
	Asset_SetDictItem( self, GroupAssetID.INFLUENCES, GroupInfluence.POWER_RANK, pow_percent )
	Asset_SetDictItem( self, GroupAssetID.INFLUENCES, GroupInfluence.POWER_RANK, ter_percent )
	influences = influences + ter_percent + pow_percent

	local allyInf = 0
	Asset_SetDictItem( self, GroupAssetID.INFLUENCES, GroupInfluence.ALLY, allyInf )
	influences = influences + allyInf

	local leader = Asset_Get( self, GroupAssetID.LEADER )
	local titleInf = 0
	local charmInf = leader and Asset_Get( leader, CharaAssetID.LEVEL ) * 10 or 0
	Asset_SetDictItem( self, GroupAssetID.INFLUENCES, GroupInfluence.LEADER_TITLE, titleInf )
	Asset_SetDictItem( self, GroupAssetID.INFLUENCES, GroupInfluence.LEADER_CHARM, charmInf )
	influences = influences + titleInf + charmInf

	Asset_SetDictItem( self, GroupAssetID.INFLUENCES, GroupInfluence.TOTAL, influences )

	--InputUtil_Pause( self.name, "influ=" .. influences, ter_percent, pow_percent, allyInf, titleInf, charmInf )
	
	--Asset_Foreach( self, GroupAssetID.INFLUENCE, function ( inf, k )	end )
end

function Group:UpdateReputations()
	local reputations = {}

	reputations[GroupReputation.GOAL]     = Asset_GetDictItem( self, GroupAssetID.REPUTATIONS, GroupReputation.GOAL )
	reputations[GroupReputation.DECISION] = Asset_GetDictItem( self, GroupAssetID.REPUTATIONS, GroupReputation.DECISION )
	reputations[GroupReputation.MILITARY] = Asset_GetDictItem( self, GroupAssetID.REPUTATIONS, GroupReputation.MILITARY )

	local leader = Asset_Get( self, GroupAssetID.LEADER )
	reputations[GroupReputation.LEADER] = leader and leader:GetStatus( CharaStatus.REPUTATION ) or 0
	reputations[GroupReputation.CHARA] = Asset_GetListSize( self, GroupAssetID.CHARA_LIST ) * GroupParamas.REPUTATION.PARAMS[GroupReputation.CHARA].value
	reputations[GroupReputation.CITY]   = Asset_GetListSize( self, GroupAssetID.CITY_LIST ) * GroupParamas.REPUTATION.PARAMS[GroupReputation.CITY].value
	reputations[GroupReputation.TECH]   = Asset_GetListSize( self, GroupAssetID.TECH_LIST ) * GroupParamas.REPUTATION.PARAMS[GroupReputation.TECH].value
	
	reputations[GroupReputation.ALLY]   = #Dipl_GetRelations( self, RelationPact.BELONG ) * GroupParamas.REPUTATION.PARAMS[GroupReputation.ALLY].value
	reputations[GroupReputation.BELONG] = #Dipl_GetRelations( self, RelationPact.ALLY ) * GroupParamas.REPUTATION.PARAMS[GroupReputation.BELONG].value

	for _, type in pairs( GroupReputation ) do
		local repu = MathUtil_Clamp( reputations[type], 0, GroupParamas.REPUTATION.PARAMS[type].max ) 
		Asset_SetDictItem( self, GroupAssetID.REPUTATIONS, type,   repu )
		if repu and repu ~= 0 then
			--print( MathUtil_FindName( GroupReputation, type ) .. "=" .. repu )
		end
	end
	
end

function Group:UpdateSpy()
	--clear current list
	Asset_Clear( self, GroupAssetID.SPY_LIST )

	Asset_Foreach( self, GroupAssetID.CITY_LIST, function ( city )
		Asset_Foreach( city, CityAssetID.SPY_LIST, function( spy )
			local existSpy = self:GetSpy( spy.city )
			if not existSpy or existSpy.grade < spy.grade then
				Asset_SetDictItem( self, GroupAssetID.SPY_LIST, city.id, spy )
			end
		end )
	end)
	--InputUtil_Pause( "group spy=" .. Asset_GetListSize( self, GroupAssetID.CITY_LIST ))
end

----------------------------------------------------------

function Group:GetStatus( status )
	return Asset_GetDictItem( self, GroupAssetID.STATUSES, status )
end

function Group:SetStatus( status, value )
	Asset_SetDictItem( self, GroupAssetID.STATUSES, status, value )
end

function Group:GetPopu( popuType )
	local num = 0
	Asset_Foreach( self, GroupAssetID.CITY_LIST, function ( city )
		num = num + ( city:GetPopu( popuType ) or 0 )
	end)
	return num
end

function Group:GetInfluence()
	return MathUtil_Sum( Asset_GetDict( self, GroupAssetID.INFLUENCES ) )
end

function Group:GetReputation()
	return MathUtil_Sum( Asset_GetDict( self, GroupAssetID.REPUTATIONS ) )
end

function Group:GetProvince()
	local value = 0
	value = Asset_GetListSize( self, GroupAssetID.CITY_LIST )
	--Asset_Foreach( self, GroupAssetID.CITY_LIST, function ( data, type ) end)
	return value
end

function Group:GetProperty( cityAssetid )
	local num = 0
	Asset_Foreach( self, GroupAssetID.CITY_LIST, function ( city )
		num = num + Asset_Get( city, cityAssetid )
	end)
	return num
end

function Group:GetSpy( city )
	return Asset_FindDictItem( self, GroupAssetID.SPY_LIST, function( s )
		return s.city == city
	end )
end

function Group:GetStatusCityList( status )
	local list = {}
	Asset_Foreach( self, GroupAssetID.CITY_LIST, function ( city )
		if city:GetStatus( status ) then
			table.insert( list, city )
		end
	end)
	return list
end

function Group:GetVacancyCityList()
	local list = {}
	Asset_Foreach( self, GroupAssetID.CITY_LIST, function ( city )
		local limit
		local has = Asset_GetListSize( city, CityAssetID.CHARA_LIST )
		limit = Chara_GetReqNumOfOfficer( city )
		if has >= limit then
			--print( "not vac req", has .. "/" .. limit )
			return
		end
		limit = Chara_GetLimitByCity( city )
		if has >= limit then
			--print( "not vac limi", has .. "/" .. limit )
			return
		end
		table.insert( list, city )
	end)
	return list
end

function Group:GetTerriority()
	local terriority = 0
	Asset_Foreach( self, GroupAssetID.CITY_LIST, function ( city )
		terriority = terriority + Asset_GetListSize( city, CityAssetID.PLOTS )
	end)
	return terriority
end

function Group:GetMilitaryPower()
	local power = 0
	Asset_Foreach( self, GroupAssetID.CITY_LIST, function ( city )
		power = power + city:GetMilitaryPower()
	end)
	return power
end

----------------------------------------------------------

function Group:LoseCity( city, toCity )
	print( self.name, "lose city=" .. city.name )	
	--remove city from list
	Asset_RemoveListItem( self, GroupAssetID.CITY_LIST, city )

	--is capital?	
	local capital = Asset_Get( self, GroupAssetID.CAPITAL )	
	if not toCity then toCity = capital end
	if capital == city then
		--find new capital
		local newCapital
		local highLv = 0
		Asset_Foreach( self, GroupAssetID.CITY_LIST, function ( tarCity )
			local lv = Asset_Get( tarCity, CityAssetID.LEVEL )
			if lv > highLv or not newCapital then
				newCapital = tarCity
				highLv = lv
			end
		end )
		Asset_Set( self, GroupAssetID.CAPITAL, newCapital )
		toCity = Random_GetListItem( city:FindNearbyFriendCities() )
		Debug_Log( "find new capital", self.name, toCity and toCity:ToString() or "" )
	end

	--for all chara list
	Asset_Foreach( city, CityAssetID.CHARA_LIST, function( chara )
		if chara:IsAtHome() or not toCity then
			--captured
			chara:Captured()			
			Asset_AppendList( city, CityAssetID.PRISONER_LIST, chara )
		else
			--set home to nearby city
			toCity:CharaJoin( chara )
		end
	end )
	--clear list
	Asset_Clear( city, CityAssetID.CHARA_LIST )
	Asset_Clear( city, CityAssetID.OFFICER_LIST )

	--corps retreat
	local dismissList = {}
	local retreatList = {}
	Asset_Foreach( city, CityAssetID.CORPS_LIST, function( corps )
		--print( corps:ToString(), "Need retreat" )
		if corps:IsAtHome() then			
			HelperUtil_AddToRemoval( corps, dismissList )
		elseif toCity then
			HelperUtil_AddToRemoval( corps, retreatList )
		end
	end )
	Asset_Clear( city, CityAssetID.CORPS_LIST )

	local hobo = city:GetPopu( CityPopu.HOBO )
	HelperUtil_DoRemove( function( corps )
		--dismiss corps
		local soldier = corps:GetSoldier()
		--put soldier into reserve
		hobo = hobo + soldier
		Corps_Dismiss( corps, true )
	end, dismissList )
	HelperUtil_DoRemove( function( corps )
		--retreat to nearby city
		--print( Move_Track( corps ) )
		print( corps:ToString( "POSITION" ), "retreat to", toCity:ToString() )
		Corps_Join( corps, toCity )
	end, retreatList )
	
	city:SetPopu( CityPopu.HOBO, hobo )
end

function Group:OccupyCity( city )
	local oldGroup = Asset_Get( city, CityAssetID.GROUP )
	if oldGroup == self then return end

	--rescue prisoner
	local rescueList = {}
	Asset_Foreach( city, CityAssetID.PRISONER_LIST, function( chara )
		if Asset_Get( chara, CharaAssetID.GROUP ) == group then
			city:CharaJoin( chara )
			table.insert( rescueList, chara )
		end
	end )
	for _, chara in ipairs( rescueList ) do
		Asset_RemoveListItem( city, CityAssetID.PRISONER_LIST, chara )
	end

	--remove city from last owner
	if oldGroup then oldGroup:LoseCity( city ) end

	--broken some constructions?
	Asset_Foreach( city, CityAssetID.CONSTR_LIST, function ( constr )
		--to do
	end )

	--other things to do in the future
	Asset_Set( city, CityAssetID.GROUP, self )

	--append to group
	Asset_AppendList( self, GroupAssetID.CITY_LIST, city )
end

function Group:AddChara( chara )
	Asset_AppendList( self, GroupAssetID.CHARA_LIST, chara )
end

function Group:LoseChara( chara )
	Asset_Set( chara, CharaAssetID.GROUP, nil )

	Asset_RemoveListItem( self, GroupAssetID.CHARA_LIST, chara )

	if Asset_Get( self, GroupAssetID.LEADER ) == chara then
		Asset_Set( self, GroupAssetID.LEADER )
	end

	Debug_Log( chara:ToString(), "leave group=" .. self:ToString() )
end

function Group:AddCorps( corps )
	Asset_AppendList( self, GroupAssetID.CORPS_LIST, corps )
end

function Group:RemoveCorps( corps )
	Asset_RemoveListItem( self, GroupAssetID.CORPS_LIST, corps )
end

function Group:ElectLeader()
	local leader = Asset_Get( self, GroupAssetID.LEADER )
	if leader then return end

	local charaList = Asset_GetList( self, GroupAssetID.CHARA_LIST )
	local leader = Chara_FindLeader( charaList )
	Asset_Set( self, GroupAssetID.LEADER, leader )

	if leader then
		Debug_Log( self:ToString(), "elect new leader=" .. leader:ToString() )
	else
		Group_Vanish( self )
	end

	--refresh loyality
	Asset_Foreach( self, GroupAssetID.CHARA_LIST, function ( chara )
		Chara_ResetLoyality( chara )
	end )
end

function Group:MoveCapital( capital )
	local current = Asset_Get( self, GroupAssetID.CAPITAL )
	if current == capital then
		error( "same capital, why move" )
	end
	Asset_Set( self, GroupAssetID.CAPITAL, capital )
	Debug_Log( self:ToString() .. " move capital=" .. capital:ToString() )
end

---------------------------------------

function Group:HasTitle( id )
	return Asset_FindItem( self, GroupAssetID.CHARA_LIST, function ( chara )
		local title = Asset_Get( chara, CharaAssetID.TITLE )
		if title and title.id == id then
			return true
		end
	end)
end

function Group:HasTech( id )
	return Asset_HasItem( self, GroupAssetID.TECH_LIST, id, "id" )
end

function Group:HasGoal( goalType )
	return self:GetGoal( goalType )
end

function Group:GetGoal( goalType )
	return Asset_GetDictItem( self, GroupAssetID.GOAL_LIST, goalType )
end

---------------------------------------

function Group:AddGoal( goalType, goalData )
	--MathUtil_Dump( goalData )
	--InputUtil_Pause( "add goal", MathUtil_FindName( GroupGoalType, goalType ), goalType, goalData )
	Asset_SetDictItem( self, GroupAssetID.GOAL_LIST, goalType, goalData )

	Stat_Add( "SetGoal@" .. self.name, g_Time:ToString() .. " " .. MathUtil_FindName( GroupGoalType, goalType ) .. " city=" .. String_ToStr( goalData.city, "name" ), StatType.LIST )
end

function Group:AchieveGoal()
	self:ModifyReputation( GroupReputation.GOAL, Random_GetInt_Sync( GroupParamas.REPUTATION.MODIFY.ACHIEVE.min, GroupParamas.REPUTATION.MODIFY.ACHIEVE.max ) )
end

function Group:UnfinishGoal()
	self:ModifyReputation( GroupReputation.GOAL, Random_GetInt_Sync( GroupParamas.REPUTATION.MODIFY.UNFINISHED.min, GroupParamas.REPUTATION.MODIFY.UNFINISHED.max ) )
end

function Group:WinCombat( combat )
	self:ModifyReputation( GroupReputation.MILITARY, Random_GetInt_Sync( GroupParamas.REPUTATION.MODIFY.WIN_COMBAT.min, GroupParamas.REPUTATION.MODIFY.WIN_COMBAT.max ) )
end

function Group:LoseCombat( combat )
	self:ModifyReputation( GroupReputation.MILITARY, Random_GetInt_Sync( GroupParamas.REPUTATION.MODIFY.LOSE_COMBAT.min, GroupParamas.REPUTATION.MODIFY.LOSE_COMBAT.max ) )
end

function Group:Decision( modifyReputation )
	self:ModifyReputation( GroupReputation.DECISION, modifyReputation )
end

---------------------------------------

function Group:MasterTech( tech )
	Asset_AppendList( self, GroupAssetID.TECH_LIST, tech )
	--InputUtil_Pause( "master tech" .. tech.id )
end

function Group:ModifyReputation( type, value )
	local reputation = Asset_GetDictItem( self, GroupAssetID.REPUTATIONS, type ) or 0
	reputation = MathUtil_Clamp( reputation + value, 0, GroupParamas.REPUTATION.PARAMS[type].max )
	Asset_SetDictItem( self, GroupAssetID.REPUTATIONS, type, reputation )
	
	--print( self.name, "modify repu", MathUtil_FindName( GroupReputation, type ), reputation, value )
end

---------------------------------------

function Group:ImproveGrade( grade )
	Asset_Set( self, GroupAssetID.GRADE, grade )
end