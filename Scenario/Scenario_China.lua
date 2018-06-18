local OriginCityData = 
{	
	{"云南",62,220,1},
	{"建宁",71,215,1},
	{"桂阳",142,212,2},
	{"零陵",134,207,2},
	{"武陵",134,176,2},
	{"长沙",148,171,2},
	{"江州",93,170,2},
	{"柴桑",168,169,2},
	{"会稽",205,165,2},
	{"襄阳",138,165,3},
	{"江陵 ",138,162,2},
	{"成都",73,158,3},
	{"江夏",150,154,2},
	{"永安",117,154,1},
	{"庐江",179,152,2},
	{"吴",205,151,1},
	{"梓潼",82,147,1},
	{"建业",191,143,3},
	{"上庸",122,142,1},
	{"新野",139,138,1},
	{"寿春",175,137,2},
	{"宛 ",141,132,2},
	{"汉中",105,132,2},
	{"汝南",155,130,2},
	{"下邳",184,123,2},
	{"许昌 ",151,121,2},
	{"长安",112,119,4},
	{"天水",86,115,1},
	{"陈留",157,114,2},
	{"洛阳",140,114,4},
	{"小沛",176,113,2},
	{"安定",98,103,2},
	{"濮阳",160,103,2},
	{"邺",157,96,3},
	{"北海",193,93,1},
	{"平原",172,87,2},
	{"晋阳",141,79,2},
	{"武威",61,78,1},
	{"南皮",174,77,2},
	{"蓟",180,55,2},
	{"北平",195,42,2},
	{"襄平",226,41,1},
}

China_MapData = 
{
	width  = 275,
	height = 240,
	plots  = nil,

	plotTypes = 
	{
		{ id = 1000, desc = "landPlain",     prob = 3000 },	
		{ id = 1100, desc = "landGrass",     prob = 3000 },
		{ id = 1200, desc = "landDesert",    prob = 800 },
		{ id = 1300, desc = "landTundra",    prob = 400 },		
		{ id = 2000, desc = "hillPlain",     prob = 3500 },
		{ id = 2100, desc = "hillGrass",     prob = 3500 },
		{ id = 2200, desc = "hillDesert",    prob = 600 },
		{ id = 2300, desc = "hillTundra",    prob = 300 },		
		{ id = 3000, desc = "mountainPlain", prob = 1000 },
		{ id = 4000, desc = "lake",          prob = 500 },
	},

	strategicResources =
	{
		{ id=100, percent=8, },--copper
		{ id=101, percent=5, },--iron
		{ id=120, percent=5, },--horse
	},

	bonusResources =
	{
		{ id=200, percent=10, },--rice
		{ id=201, percent=8, },--wheat
		{ id=205, percent=3, },--salt
		{ id=206, percent=8, },--fertile
		{ id=207, percent=3, },--infertile
	},

	luxuryResources = 
	{
		{ id=300, percent=5, },--silver
		{ id=301, percent=2, },--gold
	},

	artificialResources = 
	{
		{ id=500, percent=20, }--settlement
	}
}


China_CityData = 
{
	--[[
	[101] = 
	{
		name = "Xian Yang",
		coordinate = { x = 42, y = 6 },
		level = 16,
		charas = {},
		adjacents = { 100, 200 },
		defenses = { 15000, 10000, 15000 },
	},
	]]
}


--Init
for id, data in ipairs( OriginCityData ) do
	--name,x,y,level
	local city = {}
	city.name         = data[1]
	city.coordinate   = {}
	city.coordinate.x = data[2]
	city.coordinate.y = data[3]
	city.level        = data[4]
	China_CityData[id] = city
	MathUtil_Dump( city )
end