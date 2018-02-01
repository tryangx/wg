PlotTable = class()

function PlotTable:Load( data )
	self.id   = data.id
	self.type = PlotType[data.type]
	self.terrain = PlotTerrainType[data.terrain]
	self.feature = PlotFeatureType[data.feature]

	self.bonuses = {}
	Table_CalculateBonuses( self.bonuses, Scenario_GetData( "PLOT_BONUS_DATA" )[self.type] )
	Table_CalculateBonuses( self.bonuses, Scenario_GetData( "PLOT_TERRAIN_DATA" )[self.terrain] )
	Table_CalculateBonuses( self.bonuses, Scenario_GetData( "PLOT_FEATURE_DATA" )[self.feature] )
end

function PlotTable:Dump()
	print( MathUtil_FindName( PlotType, self.type ) )
	print( MathUtil_FindName( PlotTerrainType, self.terrain ) )
	print( MathUtil_FindName( PlotFeatureType, self.feature ) )
end

----------------------------

local _plotTableMng = Manager( 0, "PlotTable", PlotTable )

function PlotTable_Load( datas )
	_plotTableMng:Clear()
	_plotTableMng:LoadFromData( datas )
end

function PlotTable_Get( id )
	return _plotTableMng:GetData( id )
end