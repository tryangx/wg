SkillAssetType = 
{
	BASE_ATTRIB      = 1,
}

SkillAssetID = 
{
	NAME  = 101,
	LEVEL = 102,

	EFFECTS = 201,	
}

SkillAssetAttrib = 
{
	name       = AssetAttrib_SetString( { id = SkillAssetID.NAME,        type = SkillAssetType.BASE_ATTRIB } ),
	level      = AssetAttrib_SetNumber( { id = SkillAssetID.LEVEL,       type = SkillAssetType.BASE_ATTRIB } ),

	effects    = AssetAttrib_SetList  ( { id = SkillAssetID.EFFECTS,     type = SkillAssetType.BASE_ATTRIB } ),
}


-------------------------------------------


Skill = class()

function Skill:__init( ... )
	Entity_Init( self, EntityType.SKILL, SkillAssetAttrib )
end

function Skill:Load( data )
	self.id = data.id
end