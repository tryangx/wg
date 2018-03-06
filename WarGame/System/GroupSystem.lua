function Group_IsAtWar( group1, group2 )
	if group1 == group2 then return false end
	--simply all is enemy
	return true
end

function Group_SeizeCity( group, city )
	local oldGroup = Asset_Get( city, CityAssetID.GROUP )
	if oldGroup == group then
		error( "city="..city.name," already is under control by group=" .. gropu.name )
	end

	--oldgroup lose city
	Asset_RemoveListItem( oldGroup, GroupAssetID.CITY_LIST, city )
	local capital = Asset_Get( oldGroup, GroupAssetID.CAPITAL )
	if capital == city then capital = nil end
	local nearbyCity = capital

	--for all chara list
	Asset_ForeachList( city, CityAssetID.CHARA_LIST, function( chara )		
		if chara:IsAtHome() or not nearbyCity then
			--captured
			Asset_AppendList( city, CityAssetID.PRISONER_LIST, chara )
		else
			--set home to nearby city
			Asset_Set( chara, CharaAssetID.HOME, nearbyCity )
		end
	end )
	--clear list
	Asset_ClearList( city, CityAssetID.CHARA_LIST )
	Asset_ClearList( city, CityAssetID.OFFICER_LIST )	

	--rescue prisoner
	Asset_ForeachList( city, CityAssetID.PRISONER_LIST, function( chara )
		if Asset_Get( chara, CharaAssetID.GROUP ) == group then
			Asset_AppendList( city, CityAssetID.CHARA_LIST, chara )
		end
	end )

	--dismiss all corps	
	local reserve = Asset_GetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.SOLDIER )
	Asset_ForeachList( city, CityAssetID.CORPS_LIST, function( corps )
		if corps:IsAtHome() then
			--dismiss corps
			local soldier = corps:GetSoldier()
			--put soldier into reserve
			reserve = reserve + soldier
		else
			--retreat to nearby city
			Asset_Set( corps, CorpsAssetID.ENCAMPMENT, nearbyCity )
		end
	end )
	Asset_SetListItem( city, CityAssetID.POPU_STRUCTURE, CityPopu.SOLDIER, reserve )
	
	--broken some constructions?
	Asset_ForeachList( city, CityAssetID.CONSTR_LIST, function ( constr )
		--to do
	end )

	--other things to do in the future

	--add city into current group
	Asset_AppendList( group, GroupAssetID.CITY_LIST, city )
end

-----------------------------------------

GroupSystem = class()

function GroupSystem:__init()
	System_Setup( self, SystemType.GROUP_SYS )
end

function GroupSystem:Start()
end

function GroupSystem:Update()
	Entity_Foreach( EntityType.GROUP, function ( group )
		--print( "it time to ", group.name )
	end )
end