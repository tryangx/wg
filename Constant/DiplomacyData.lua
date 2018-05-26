
--------------------------------------------------------
-- Relation

DefaultRelationOpinion =
{
	TRUST      = { increment = -1,  def = 500,   min = -500,   max = 1000, time = -1 },

	WAS_AT_WAR = { increment = 1,   def = -400,  min = -1000,  max = 0,    time = 1800 },
	AT_WAR     = { increment = 1,   def = -300,  min = -1000,  max = 0,    time = -1 },
	OLD_ENEMY  = { increment = 1,   def = -500,  min = -500,   max = 0,    time = 3600 },

	NO_WAR     = { increment = -1,  def = 0,     min = 0,      max = 500,  time = 1 },
	TRADE      = { increment = -1,  def = 0,     min = 200,    max = 500,  time = 1 },	
	PROTECT    = { increment = -1,  def = 0,     min = 300,    max = 500,  time = 1 },	
	ALLY       = { increment = -1,  def = 0,     min = 600,    max = 1000, time = 1 },	
}


--pact, time
--prob, has_opinion, no_opinion, duration_above, has_pact, attitude_above
DefaultPactCond = 
{
	--[[
	{
		pact  = "PEACE",
		time  = 180,
		has_opinion    = "AT_WAR",
		duration_above = 180,
		prob           = 35,
	},
	{
		pact  = "PEACE",
		time  = 180,
		has_opinion    = "AT_WAR",
		duration_above = 360,
		prob           = 70,
	},
	{
		pact  = "PEACE",
		time  = 180,
		has_opinion    = "AT_WAR",
		duration_above = 1080,
		prob           = 95,
	},
	]]

	{
		pact  = "NO_WAR",
		time  = 360,
		attitude_above = 300,
		no_opinion = "AT_WAR",
		no_pact = "NO_WAR",
		prob = 80,
	},
	
	{
		pact  = "TRADE",
		time  = 360,
		attitude_above = 300,
		no_opinion = "AT_WAR",
		no_pact = "TRADE",
		prob = 80,
	},

	{
		pact  = "PROTECT",
		time  = 36000,
		attitude_above = 500,
		no_opinion = "AT_WAR",
		no_pact = "PROTECT",
		prob = 80,
	},

	{
		pact  = "ALLY",
		time  = 1080,
		attitude_above = 600,
		no_opinion = "AT_WAR",
		no_pact = "ALLY",
		prob = 80,
	},
}
