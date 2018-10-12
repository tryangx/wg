EntityType = 
{
	NONE   = 0,
	----------------------
	GROUP  = 1,
	CITY   = 2,
	CHARA  = 3,	
	CORPS  = 4,
	TROOP  = 5,

	WEAPON = 22,
	CONSTRUCTION = 23,

	EVENT    = 30,
	RELATION = 31,

	COMBAT = 100,

	MAP    = 200,
	PLOT   = 201,
	ROUTE  = 202,

	---------------------

	MESSAGE  = 300,
	PROPOSAL = 301,
	TASK     = 302,
	MEETING  = 303,
	MOVE     = 304,
	INTEL    = 305,
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

function Entity_SetPlot( entity, id, value )
	return Entity_Get( EntityType.PLOT, value ) or value
end

function Entity_SetWeapon( entity, id, value )
	return Entity_Get( EntityType.WEAPON, value ) or value
end

function Entity_SetSkill( entity, id, value )
	return SkillTable_Get( value )
end

function Entity_SetConstruction( entity, id, value )
	return ConstructionTable_Get( value )
end

-------------------------------------------

function Entity_ToString( type )
	print( "=========Travel " .. MathUtil_FindName( EntityType, type ) )
	Entity_Foreach( type, function ( data )
		print( data:ToString() )
	end)
	print( "===============================")
end

-------------------------------------------

require "Entity/Group"
require "Entity/City"
require "Entity/Chara"
require "Entity/Corps"
require "Entity/Troop"
require "Entity/Weapon"

require "Entity/Plot"
require "Entity/Map"

require "Entity/Combat"
require "Entity/Route"

require "Entity/Relation"
require "Entity/Intel"
require "Entity/Message"
require "Entity/Proposal"
require "Entity/Task"
require "Entity/Event"
require "Entity/Meeting"
require "Entity/Move"