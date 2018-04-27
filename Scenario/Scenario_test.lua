RouteTest_CityData =
{
	--test
	--  1   2
	--3   4   5
	--  6   7
	[1] = 
	{
		name = "Left-Top",
		coordinate = { x = 1, y = 1 },
		adjacents = { 3 },
	},
	[2] = 
	{
		name = "Right-Top",
		coordinate = { x = 5, y = 1 },
		adjacents = { 5 },
	},
	[3] = 
	{
		name = "Left",
		coordinate = { x = 1, y = 3 },
		adjacents = { 1, 4, 6 },
	},
	[4] = 
	{
		name = "Center",
		coordinate = { x = 3, y = 3 },
		adjacents = { 3, 5 },
	},
	[5] = 
	{
		name = "Right",
		coordinate = { x = 5, y = 3 },
		adjacents = { 2, 7 },
	},
	[6] = 
	{
		name = "Left-Bottom",
		coordinate = { x = 1, y = 5 },
		adjacents = { 3 },
	},
	[7] = 
	{
		name = "Right-Bottom",
		coordinate = { x = 5, y = 5 },
		adjacents = { 5 },
	},
	--]]
}

Test_CityData = 
{
	[1000] = 
	{
		name = "Test City",
		coordinate = { x = 66, y = 6 },
		level = 10,
		money    = 10000,
		material = 10000,
		--adjacents = { 101 },
		defenses = { 15000, 10000, 15000 },
		charas = { 100, 101, 102, 103 },
	},
}