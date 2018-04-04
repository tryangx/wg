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

	TECH_LIST      = 301,
	GOAL_LIST      = 302,
	TAG_LIST       = 303,
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

	techs     = AssetAttrib_SetPointerList   ( { id = GroupAssetID.TECH_LIST,     type = GroupAssetType.GROWTH_ATTRIB, Entity_SetTech } ),
	goals     = AssetAttrib_SetList          ( { id = GroupAssetID.GOAL_LIST,     type = GroupAssetType.GROWTH_ATTRIB } ),
	tags      = AssetAttrib_SetPointerList   ( { id = GroupAssetID.TAG_LIST,      type = GroupAssetType.GROWTH_ATTRIB } ),
}

-------------------------------------------

Group = class()

function Group:__init()
	Entity_Init( self, EntityType.GROUP, GroupAssetAttrib )
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
	Asset_CopyList( self, GroupAssetID.GOAL_LIST, data.goals )
end

function Group:VerifyData()
	local group = self

	local capital = Asset_Get( city, GroupAssetID.CAPITAL )
	if capital then
		Asset_Set( capital, CityAssetID.STATUSES, CityStatus.CAPITAL, true )
	end

	--city belong the group
	Asset_ForeachList( self, GroupAssetID.CITY_LIST, function( city )
		if not city or type( city ) == "number" then return end
		Asset_Set( city, CityAssetID.GROUP, group )	
	end )
	
	--chara belongs to the group
	Asset_ForeachList( self, GroupAssetID.CHARA_LIST, function( chara )
		if not chara or type( chara ) == "number" then return end
		Asset_Set( chara, CharaAssetID.GROUP, group )
	end )

	--corps belongs to the group
	Asset_ForeachList( self, GroupAssetID.CORPS_LIST, function( corps )
		if not corps or type( corps ) == "number" then return end
		Asset_Set( corps, CorpsAssetID.GROUP, group )
	end )

	--verify chara
	Asset_ForeachList( self, GroupAssetID.CHARA_LIST, function( chara )
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
		Asset_ForeachList( self, GroupAssetID.CITY_LIST, function ( tarCity )
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
	Asset_ForeachList( city, CityAssetID.CHARA_LIST, function( chara )		
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
	local reserve = Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.SOLDIER )
	Asset_ForeachList( city, CityAssetID.CORPS_LIST, function( corps )
		if corps:IsAtHome() then
			--dismiss corps
			local soldier = corps:GetSoldier()
			--put soldier into reserve
			reserve = reserve + soldier
		else
			--retreat to nearby city
			toCity:CorpsJoin( corps )
		end
	end )
	Asset_ClearList( city, CityAssetID.CORPS_LIST )
	Asset_SetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.SOLDIER, reserve )
end

function Group:OccupyCity( city )
	local oldGroup = Asset_Get( city, CityAssetID.GROUP )
	if oldGroup == self then return end

	--rescue prisoner
	local rescueList = {}
	Asset_ForeachList( city, CityAssetID.PRISONER_LIST, function( chara )
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
	Asset_ForeachList( city, CityAssetID.CONSTR_LIST, function ( constr )
		--to do
	end )

	--other things to do in the future

	--append to group
	Asset_AppendList( self, GroupAssetID.CITY_LIST, city )
end

function Group:LoseChara( chara )
	Asset_RemoveListItem( self, GroupAssetID.CHARA_LIST, chara )
end

---------------------------------------

function Group_FormulaInit()
	GroupGovernmentData = MathUtil_ConvertKey2ID( GroupGovernmentData, GroupGovernment )
end

---------------------------------------

function Group_GetCharaLimit( group )
	if not group then return 0 end
	local numofcities = Asset_GetListSize( group, GroupAssetID.CITY_LIST )
	local government = Asset_Get( group, GroupAssetID.GOVERNMENT )
--	print( "gov=" .. MathUtil_FindName( GroupGovernment, government ) )
	return GroupGovernmentData[government].CAPITAL_CHARA_LIMIT
end

---------------------------------------
