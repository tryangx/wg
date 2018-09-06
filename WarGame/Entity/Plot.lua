PlotAssetType = 
{
	BASE_ATTRIB     = 1,
	PROPERTY_ATTRIB = 2,
	GROWTH_ATTRIB   = 3,
}

PlotAssetID = 
{
	X               = 101,
	Y               = 102,
	TEMPLATE        = 103,

	CITY            = 201,
	RESOURCE        = 202,
	DISTRICT        = 203,
	POPULATION      = 204,
	ROAD            = 205,	

	AGRICULTURE     = 302,
	COMMERCE        = 303,
	PRODUCTION      = 304,
	MAX_AGRICULTURE = 311,
	MAX_COMMERCE    = 312,	
	MAX_PRODUCTION  = 313,
}

function SetPlotTemplate( plot, id, value )
	return PlotTable_Get( value )
end

function SetPlotCity( plot, id, value )
	return Entity_Get( EntityType.CITY, value )
end

function SetPlotResource( plot, id, value )
	return ResourceTable_Get( value )
end

function SetPlotDistrict( plot, id, value )
	return DistrictTable_Get( value )
end

PlotAssetAttrib =
{
	x = AssetAttrib_SetNumber ( { id = PlotAssetID.X,           type = PlotAssetType.BASE_ATTRIB, min = 1, max = 4000 } ),
	y = AssetAttrib_SetNumber ( { id = PlotAssetID.Y,           type = PlotAssetType.BASE_ATTRIB, min = 1, max = 4000 } ),
	template = AssetAttrib_SetPointer( { id = PlotAssetID.TEMPLATE,    type = PlotAssetType.BASE_ATTRIB, setter = SetPlotTemplate } ),

	city       = AssetAttrib_SetPointer( { id = PlotAssetID.CITY,        type = PlotAssetType.PROPERTY_ATTRIB, setter = SetPlotCity } ),
	resource   = AssetAttrib_SetPointer( { id = PlotAssetID.RESOURCE,    type = PlotAssetType.PROPERTY_ATTRIB, setter = SetPlotResource } ),
	district   = AssetAttrib_SetPointer( { id = PlotAssetID.DISTRICT,    type = PlotAssetType.PROPERTY_ATTRIB, setter = SetPlotDistrict } ),
	population = AssetAttrib_SetNumber ( { id = PlotAssetID.POPULATION,  type = PlotAssetType.PROPERTY_ATTRIB } ),
	road       = AssetAttrib_SetNumber ( { id = PlotAssetID.ROAD,        type = PlotAssetType.PROPERTY_ATTRIB } ),

	agriculture    = AssetAttrib_SetNumber ( { id = PlotAssetID.AGRICULTURE,     type = PlotAssetType.GROWTH_ATTRIB, min = 0 } ),
	commerce       = AssetAttrib_SetNumber ( { id = PlotAssetID.COMMERCE,        type = PlotAssetType.GROWTH_ATTRIB, min = 0 } ),
	production     = AssetAttrib_SetNumber ( { id = PlotAssetID.PRODUCTION,      type = PlotAssetType.GROWTH_ATTRIB, min = 0 } ),
	maxAgriculture = AssetAttrib_SetNumber ( { id = PlotAssetID.MAX_AGRICULTURE, type = PlotAssetType.GROWTH_ATTRIB, min = 0 } ),
	maxCommerce    = AssetAttrib_SetNumber ( { id = PlotAssetID.MAX_COMMERCE,    type = PlotAssetType.GROWTH_ATTRIB, min = 0 } ),
	maxProduction  = AssetAttrib_SetNumber ( { id = PlotAssetID.MAX_PRODUCTION,  type = PlotAssetType.GROWTH_ATTRIB, min = 0 } ),
}


-------------------------------------------

Plot = class()

function Plot:__init( ... )
	Entity_Init( self, EntityType.PLOT, PlotAssetAttrib )
end

function Plot:ToString()
	return self.id .. "(" .. Asset_Get( self, PlotAssetID.X ) .. "," .. Asset_Get( self, PlotAssetID.Y ) .. ")"
end

function Plot:InitName()
	self.name = MathUtil_FindName( PlotType, self:GetPlotType() ) .. "_" .. MathUtil_FindName( PlotTerrainType, self:GetTerrain() ) .. "_" .. MathUtil_FindName( PlotFeatureType, self:GetFeature() )
end

function Plot:GetPlotType()
	local template = Asset_Get( self, PlotAssetID.TEMPLATE )
	return template and template.type or 0
end

function Plot:GetTerrain()
	local template = Asset_Get( self, PlotAssetID.TEMPLATE )
	return template and template.terrain or 0
end

function Plot:GetFeature()
	local template = Asset_Get( self, PlotAssetID.TEMPLATE )
	return template and template.feature or 0
end

function Plot:InitGrowth( params )	
	--1st, calculate all development indexs depends on plots and resources
	local template = Asset_Get( self, PlotAssetID.TEMPLATE )
	if template then
		--template:Dump()
		for type, value in pairs( template.bonuses ) do
			--print( MathUtil_FindName( BonusType, type ), value )
			if type == BonusType.AGRICULTURE then
				Asset_Plus( self, PlotAssetID.MAX_AGRICULTURE, value )
			elseif type == BonusType.COMMERCE then
				Asset_Plus( self, PlotAssetID.MAX_COMMERCE, value )
			elseif type == BonusType.PRODUCTION then
				Asset_Plus( self, PlotAssetID.MAX_PRODUCTION, value )
			end
		end
	end

	local resource = Asset_Get( self, PlotAssetID.RESOURCE )
	if resource then
		for type, value in pairs( resource.bonuses ) do
			--print( MathUtil_FindName( BonusType, type ), value )
			if type == BonusType.AGRICULTURE then
				Asset_Plus( self, PlotAssetID.MAX_AGRICULTURE, value )
			elseif type == BonusType.COMMERCE then
				Asset_Plus( self, PlotAssetID.MAX_COMMERCE, value )
			elseif type == BonusType.PRODUCTION then
				Asset_Plus( self, PlotAssetID.MAX_PRODUCTION, value )
			end
		end
	end

	--2nd, determine the current development indexs by any method	
	local min, max = 40, 90
	Asset_Set( self, PlotAssetID.AGRICULTURE, math.ceil( Random_GetInt_Sync( min, max ) * 0.01 * Asset_Get( self, PlotAssetID.MAX_AGRICULTURE ) ) )
	Asset_Set( self, PlotAssetID.COMMERCE,    math.ceil( Random_GetInt_Sync( min, max ) * 0.01 * Asset_Get( self, PlotAssetID.MAX_COMMERCE ) ) )
	Asset_Set( self, PlotAssetID.PRODUCTION,  math.ceil( Random_GetInt_Sync( min, max ) * 0.01 * Asset_Get( self, PlotAssetID.MAX_PRODUCTION ) ) )

	--3rd, determine the population of each career in the population struction depends on the development indexs
	local city         = Asset_Get( self, PlotAssetID.CITY )
	local supplyParams = City_GetPopuParams( city ).POPU_SUPPLY
	local agr          = Asset_Get( self, PlotAssetID.AGRICULTURE )	
	local supplyPopu   = agr * supplyParams.AGRI_SUPPLY_POPU
	local popu         = math.ceil( supplyPopu * Random_GetInt_Sync( 60, 120 ) * 0.01 )
	Asset_Set( self, PlotAssetID.POPULATION, popu )
	--InputUtil_Pause( "agr=" .. agr, " supply=" .. supplyPopu, " popu=" .. popu )

	--[[
	print( "agr=" .. Asset_Get( self, PlotAssetID.AGRICULTURE ) )
	print( "prd=" .. Asset_Get( self, PlotAssetID.PRODUCTION ) )
	print( "com=" .. Asset_Get( self, PlotAssetID.COMMERCE ) )		
	InputUtil_Pause( "agr=" .. agr, "plotpopu="..popu )
	--]]
end

function Plot:Update()	
	if 1 then return end

	local city = Asset_Get( self, PlotAssetID.CITY )
	if city then return end
	local day   = g_Time:GetDay()
	if day % GlobalTime.TIME_PER_YEAR ~= 0 then return end

	local population = Asset_Get( self, PlotAssetID.POPULATION )
	
	--population grow
	local growthRate = Random_GetInt_Sync( PlotParams.POPULATION.GROWTH_MIN_RATE , PlotParams.POPULATION.GROWTH_MAX_RATE  )
	
	--increase
	local increase = popu * growthRate * 0.001	
	Asset_Set( self, PlotAssetID.POPULATION, population + increase )	
end