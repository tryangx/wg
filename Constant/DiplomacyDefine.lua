RelationOpinion = 
{
	--base
	TRUST      = 1,	
	REPUTATION = 2,
	INFLUENCE  = 3,

	--status
	WAS_AT_WAR = 10,
	AT_WAR     = 11,
	OLD_ENEMY  = 12,
	
	--pact
	NO_WAR     = 20,
	TRADE      = 21,
	PROTECT    = 22,
	ALLY       = 23,
}

RelationPact = 
{
	--
	PEACE    = 10,
	NO_WAR   = 11,
	TRADE    = 12,	
	ALLY     = 13,

	--Master-slave
	PROTECT  = 20,	
	BELONG   = 21,		
}

DiplomacyMethod = 
{
	IMPROVE_RELATION = 1,
	DECLARE_WAR      = 2,
	SIGN_PACT        = 3,
}
