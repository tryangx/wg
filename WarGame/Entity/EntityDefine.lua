EntityType = 
{
	NONE   = 0,
	----------------------
	GROUP  = 1,
	CITY   = 2,
	CHARA  = 3,	
	CORPS  = 4,
	TROOP  = 5,

	SKILL  = 20,
	TECH   = 21,
	WEAPON = 22,

	EVENT  = 30,

	COMBAT = 100,

	MAP    = 200,
	PLOT   = 201,
	ROUTE  = 202,

	---------------------

	PROPOSAL = 300,
	TASK     = 301,
	MEETING  = 302,
}

function Entity_SetGroup( entity, id, value )
	return Entity_Get( EntityType.GROUP, value ) or value
end

function Entity_SetCity( entity, id, value )
	return Entity_Get( EntityType.CITY, value ) or value
end

function Entity_SetChara( entity, id, value )
	return Entity_Get( EntityType.CHARA, value ) or value
end

function Entity_SetCorps( entity, id, value )
	return Entity_Get( EntityType.CORPS, value ) or value
end

function Entity_SetTroop( entity, id, value )
	return Entity_Get( EntityType.TROOP, value ) or value
end

function Entity_SetSkill( entity, id, value )
	return Entity_Get( EntityType.SKILL, value ) or value
end

function Entity_SetTech( entity, id, value )
	return Entity_Get( EntityType.TECH, value ) or value
end

function Entity_SetPlot( entity, id, value )
	return Entity_Get( EntityType.PLOT, value ) or value
end

function Entity_SetWeapon( entity, id, value )
	return Entity_Get( EntityType.WEAPON, value ) or value
end

function Entity_SetConstruction( entity, id, value )
end


-------------------------------------------

require "Entity/Group"
require "Entity/City"
require "Entity/Chara"
require "Entity/Corps"
require "Entity/Troop"
require "Entity/Weapon"
require "Entity/Skill"
require "Entity/Tech"

require "Entity/Plot"
require "Entity/Map"

require "Entity/Combat"
require "Entity/Route"

require "Entity/Proposal"
require "Entity/Task"
require "Entity/Event"
require "Entity/Meeting"
