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

	CHARA_LIST     = 201,
	CITY_LIST      = 202,
	CORPS_LIST     = 203,
	
	MONEY          = 210,
	MATERIAL       = 211,
	
	REPUTATION     = 220,
	INFLUENCE      = 221,

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

	charas    = AssetAttrib_SetPointerList   ( { id = GroupAssetID.CHARA_LIST,    type = GroupAssetType.PROPERTY_ATTRIB, setter = Entity_SetChara } ),
	cities    = AssetAttrib_SetPointerList   ( { id = GroupAssetID.CITY_LIST,     type = GroupAssetType.PROPERTY_ATTRIB, setter = Entity_SetCity } ),
	corpses   = AssetAttrib_SetPointerList   ( { id = GroupAssetID.CORPS_LIST,    type = GroupAssetType.PROPERTY_ATTRIB, setter = Entity_SetCorps } ),

	money     = AssetAttrib_SetNumber( { id = GroupAssetID.MONEY,    type = GroupAssetType.PROPERTY_ATTRIB } ),
	material  = AssetAttrib_SetNumber( { id = GroupAssetID.MONEY,    type = GroupAssetType.PROPERTY_ATTRIB } ),

	reputation= AssetAttrib_SetNumber( { id = GroupAssetID.REPUTATION,   type = GroupAssetType.PROPERTY_ATTRIB } ),
	influence = AssetAttrib_SetNumber( { id = GroupAssetID.INFLUENCE,    type = GroupAssetType.PROPERTY_ATTRIB } ),

	techs     = AssetAttrib_SetList          ( { id = GroupAssetID.TECH_LIST,     type = GroupAssetType.GROWTH_ATTRIB } ),
	goals     = AssetAttrib_SetDict          ( { id = GroupAssetID.GOAL_LIST,     type = GroupAssetType.GROWTH_ATTRIB } ),
	tags      = AssetAttrib_SetPointerList   ( { id = GroupAssetID.TAG_LIST,      type = GroupAssetType.GROWTH_ATTRIB } ),
	spys      = AssetAttrib_SetList          ( { id = GroupAssetID.SPY_LIST,      type = GroupAssetType.GROWTH_ATTRIB } ),
}

-------------------------------------------

Group = class()

function Group:__init()
	Entity_Init( self, EntityType.GROUP, GroupAssetAttrib )
end

function Group:ToString( type )
	local content = "[" .. self.name .. "]"
	if type == "SIMPLE" then
		content = content .. " city=" .. Asset_GetListSize( self, GroupAssetID.CITY_LIST )
		content = content .. " chara=" .. Asset_GetListSize( self, GroupAssetID.CHARA_LIST )
		content = content .. " corps=" .. Asset_GetListSize( self, GroupAssetID.CORPS_LIST )
	elseif type == "MILITARY" then
		content = content .. " pow=" .. self:GetSoldier()
	elseif type == "ALL" then
		content = content .. " pow=" .. self:GetSoldier()
	elseif type == "GOAL" then
		Asset_Foreach( self, GroupAssetID.GOAL_LIST, function ( goalData, goalType )
			content = content .. " " .. MathUtil_FindName( GroupGoalType, goalType )
		end)
	end
	if type == "POWER" then
		content = content ..  " sldr=" .. self:GetPopu( CityPopu.SOLDIER )
		content = content ..  " food=" .. self:GetProperty( CityAssetID.FOOD )
		content = content ..  " money=" .. self:GetProperty( CityAssetID.MONEY )		
		content = content ..  " mat=" .. self:GetProperty( CityAssetID.MATERIAL )
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
	Asset_Foreach( self, GroupAssetID.CHARA_LIST, function( chara )
		--check job
		local job = Asset_Get( chara, CharaAssetID.JOB )
		if job == CharaJob.NONE then
			job = CharaJob.OFFICER
			if chara == Asset_Get( self, GroupAssetID.LEADER ) then
				error( "Leader's job is invalid" )
			else
				Asset_Set( chara, job )
				CRR_Tolerate( chara.name .. " job correct to " .. MathUtil_FindName( CharaJob, job ) )
			end
		end

		--check location and home
		local home = Asset_Get( chara, CharaAssetID.HOME )		
		if not home then
			Asset_Set( chara, CharaAssetID.HOME, Asset_Get( self, GroupAssetID.CAPITAL ) )
			CRR_Tolerate( chara.name .. " home correct to " .. Asset_Get( chara, CharaAssetID.HOME ) )
		end
		local loc = Asset_Get( chara, CharaAssetID.LOCATION )
		if not loc then
			Asset_Set( chara, CharaAssetID.HOME, Asset_Get( chara, CharaAssetID.HOME ) )
			CRR_Tolerate( chara.name .. " loc correct to " .. Asset_Get( chara, CharaAssetID.HOME ) )
		end

		--check group
		if Asset_Get( chara, CharaAssetID.GROUP ) ~= self then
			Asset_Set( chara, CharaAssetID.GROUP, self )
		end
	end)

	--generate the superior and subordinates	
end

function Group:Update( ... )
end

function Group:UpdateSpy()
	--clear current list
	Asset_ClearList( self, GroupAssetID.SPY_LIST )

	Asset_Foreach( self, GroupAssetID.CITY_LIST, function ( city )
		Asset_Foreach( city, CityAssetID.SPY_LIST, function( spy )
			local existSpy = self:GetSpy( spy.city )
			if not existSpy or existSpy.grade < spy.grade then
				Asset_SetListItem( self, GroupAssetID.SPY_LIST, city, spy )
			end
		end )
	end)
	--InputUtil_Pause( "group spy=" .. Asset_GetListSize( self, GroupAssetID.CITY_LIST ))
end

----------------------------------------------------------

function Group:GetPopu( popuType )
	local num = 0
	Asset_Foreach( self, GroupAssetID.CITY_LIST, function ( city )
		num = num + city:GetPopu( popuType )
	end)
	return num
end

function Group:GetProperty( cityAssetid )
	local num = 0
	Asset_Foreach( self, GroupAssetID.CITY_LIST, function ( city )
		num = num + Asset_Get( city, cityAssetid )
	end)
	return num
end

function Group:GetSpy( city )
	return Asset_FindListItem( self, GroupAssetID.SPY_LIST, function( s )
		return s.city == city
	end )
end

function Group:GetSoldier()
	--corps in city
	local soldier = 0
	Asset_Foreach( self, GroupAssetID.CITY_LIST, function ( city )
		soldier = soldier + city:GetSoldier()
	end )
	return soldier
end


function Group:GetVacancyCityList()
	local list = {}
	Asset_Foreach( self, GroupAssetID.CITY_LIST, function ( city )
		if Asset_GetListSize( city, CityAssetID.CHARA_LIST ) < Chara_GetReqNumOfOfficer( city ) then
			table.insert( list, city )
		end
	end)
	return list
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
		if newCapital then
			Asset_Set( self, GroupAssetID.CAPITAL, newCapital )
		end
		toCity = Random_GetListItem( city:FindNearbyFriendCities() )
	end

	--for all chara list
	Asset_Foreach( city, CityAssetID.CHARA_LIST, function( chara )		
		if chara:IsAtHome() or not toCity then
			--captured
			Asset_AppendList( city, CityAssetID.PRISONER_LIST, chara )
		else
			--set home to nearby city
			toCity:CharaJoin( chara )
		end
	end )
	--clear list
	Asset_ClearList( city, CityAssetID.CHARA_LIST )
	Asset_ClearList( city, CityAssetID.OFFICER_LIST )

	--corps retreat
	local reserves = Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.RESERVES )
	Asset_Foreach( city, CityAssetID.CORPS_LIST, function( corps )
		if corps:IsAtHome() then
			--dismiss corps
			local soldier = corps:GetSoldier()
			--put soldier into reserve
			reserves = reserves + soldier
		elseif toCity then
			--retreat to nearby city
			--print( Move_Track( corps ) )
			--InputUtil_Pause( corps:ToString( "POSITION" ), "retreat to", toCity:ToString() )
			toCity:AddCorps( corps )
		end
	end )
	Asset_ClearList( city, CityAssetID.CORPS_LIST )
	city:SetPopu( CityPopu.RESERVES, reserves )
end

function Group:OccupyCity( city )
	local oldGroup = Asset_Get( city, CityAssetID.GROUP )
	if oldGroup == self then return end

	--rescue prisoner
	local rescueList = {}
	Asset_Foreach( city, CityAssetID.PRISONER_LIST, function( chara )
		if Asset_Get( chara, CharaAssetID.GROUP ) == group then
			Asset_AppendList( city, CityAssetID.CHARA_LIST, chara )
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

function Group:LoseChara( chara )
	Asset_RemoveListItem( self, GroupAssetID.CHARA_LIST, chara )
end

function Group:AddCorps( corps )	
end

function Group:RemoveCorps( corps )
end

function Group:ElectLeader()
	local leader = Asset_Get( self, GroupAssetID.LEADER )
	if leader then return end

	local charaList = Asset_GetList( self, GroupAssetID.CHARA_LIST )
	local leader = Chara_FindLeader( charaList )
	Asset_Set( self, GroupAssetID.LEADER, leader )

	if leader then
		InputUtil_Pause( "no king", leader.name )
	else
		Group_Vanish( self )
	end
end

---------------------------------------

function Group:HasTech( id )
	return Asset_HasItem( self, GroupAssetID.TECH_LIST, id, "id" )
end

function Group:GetGoal( goalType )
	return Asset_GetDictItem( self, GroupAssetID.GOAL_LIST, goalType )
end

---------------------------------------

function Group:AddGoal( goalType, goalData )
	--MathUtil_Dump( goalData )
	--InputUtil_Pause( "add goal", MathUtil_FindName( GroupGoalType, goalType ), goalType, goalData )
	Asset_SetListItem( self, GroupAssetID.GOAL_LIST, goalType, goalData )

	Stat_Add( "SetGoal@" .. self.name, 1, StatType.TIMES )
end

function Group:MasterTech( tech )
	Asset_AppendList( self, GroupAssetID.TECH_LIST, tech )
	--InputUtil_Pause( "master tech" .. tech.id )
end