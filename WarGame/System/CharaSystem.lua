local function Chara_SubmitProposal( chara )
	--is at home?
	if chara:IsAtHome() ~= true then
		DBG_Watch( "chara_proposal", chara.name .. " isn't at home" )
		return
	end

	--is executive at home?
	local executive = Asset_GetListItem( Asset_Get( chara, CharaAssetID.LOCATION ), CityAssetID.OFFICER_LIST, CityOfficer.EXECUTIVE )
	if not executive or executive:IsAtHome() ~= true then
		DBG_Watch( "chara_proposal", "executive=" .. ( executive and executive.name or "none" ) .. " isn't at home" )
	end

	CharaAI_SubmitProposal( chara )
end

-----------------------------------------------------

CharaSystem = class()

function CharaSystem:__init()
	System_Setup( self, SystemType.CHARA_SYS )
end

function CharaSystem:Start()
	DBG_SetWatcher( "chara_proposal", DBGLevel.NORMAL )
end

function CharaSystem:Update()
	local day   = g_calendar:GetDay()
	Entity_Foreach( EntityType.CHARA, function ( chara )
		chara:Update()

		--move to meeting system
		if day % 15 == 0 then
			--Chara_SubmitProposal( chara )
		end
	end )
end