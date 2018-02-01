-------------------------------
-- Hire chara relative

function Chara_Serve( chara, group, city )
	if not chara then return end

	if group then
		Asset_AppendList( group, GroupAssetID.CHARA_LIST, chara )
		DBG_Trace( "chara_serve", chara.name .. " serve " .. group.name )

		Asset_Set( chara, CharaAssetID.GROUP, group )
	end

	if city then
		Asset_AppendList( city, CityAssetID.CHARA_LIST, chara )
		DBG_Trace( "chara_serve", chara.name .. " serve " .. city.name )

		--set home & location
		Asset_Set( chara, CharaAssetID.HOME, city )
		Asset_Set( chara, CharaAssetID.LOCATION, city )

		--set job
		Asset_Set( chara, CharaAssetID.JOB, CharaJob.OFFICER )

		--to set relation
		local executive = Asset_GetListItem( Asset_Get( chara, CharaAssetID.LOCATION ), CityAssetID.OFFICER_LIST, CityOfficer.EXECUTIVE )
		if executive then
			Asset_Set( chara, CharaAssetID.SUPERIOR, executive )
			DBG_Trace( "chara_serve", executive.name .. " manage " .. chara.name )
			
			Asset_AppendList( executive, CharaAssetID.SUBORDINATES, chara )
			DBG_Trace( "chara_serve", chara.name .. " serve " .. executive.name )
		end		
	end
end

-------------------------------
-- Promote relative

function Chara_Promote( chara, job )
	Asset_Set( chara, CharaAssetID.JOB, job )
	DBG_Warning( "chara_promote", chara.name .. " promote " .. MathUtil_FindName( CharaJob, job ), job )
end

function Chara_FindPromoteJob( chara )
	--print( chara.name, "job=" .. MathUtil_FindName( CharaJob, Asset_Get( chara, CharaAssetID.JOB ) ) )
	local datas = Scenario_GetData( "CHARA_PROMOTE_DATA" )
	local method = Scenario_GetData( "CHARA_PROMOTE_METHOD" )[Asset_Get( chara, CharaAssetID.JOB )]
	if not method then
		DBG_Error( "no chara promote method" )
		return
	end
	
	local jobs = {}
	for _, id in pairs( method ) do
		local data = datas[id]
		local valid = true
		if valid == true and data.contribution and data.contribution > Asset_Get( chara, CharaAssetID.CONTRIBUTION ) then valid = false end
		if valid == true and data.service and data.service > Asset_Get( chara, CharaAssetID.SERVICE_DAY ) then valid = false end
		if valid == true and data.has_skill then
			for _, bundle in pairs( data.has_skill ) do
				local has = true
				for _, id in pairs( bundle ) do
					if Asset_HasItem( chara, CharaAssetID.SKILLS, id, "id" ) == false then
						has = false
						break
					end
				end
				valid = has
				if has == true then
					break
				end
			end
		end
		if valid == true then
			table.insert( jobs, id )
		end
	end
	local num = #jobs
	if num == 0 then return nil end
	return jobs[Random_GetInt_Sync( 1, num )]
end

-----------------------------------------------------

local function Chara_SubmitProposal( chara )
	--is at home?
	if chara:IsAtHome() ~= true then
		DBG_Watch( "chara_proposal", chara.name .. " isn't at home" )
		return
	end

	--has task?
	if Asset_GetListSize( chara, CharaAssetID.TASKS ) > 0 then
		print( "has task")
		return
	end

	--is executive at home?
	local executive = Asset_GetListItem( Asset_Get( chara, CharaAssetID.LOCATION ), CityAssetID.OFFICER_LIST, CityOfficer.EXECUTIVE )
	if not executive or executive:IsAtHome() ~= true then
		DBG_Watch( "chara_proposal", "executive=" .. ( executive and executive.name or "none" ) .. " isn't at home" )
	end

	CharaAI_SubmitProposal( chara )
end


local function Chara_ExecuteTask( chara )
	local loc = Asset_Get( chara, CharaAssetID.LOCATION )

	local list = {}
	Asset_ForeachList( chara, CharaAssetID.TASKS, function( task )
		if Asset_Get( task, TaskAssetID.DESTINATION ) == loc then
			table.insert( list, task )
		end
	end )

	if #list == 0 then return end

	local task = list[Random_GetInt_Sync(1, #list)]
	Task_Do( task, chara )
end

-----------------------------------------------------

CharaSystem = class()

function CharaSystem:__init()
	System_Setup( self, SystemType.CHARA_SYS )
end

function CharaSystem:Start()
	DBG_SetWatcher( "chara_proposal", DBGLevel.NORMAL )
end

function CharaSystem:Update( elapsed )
	local day   = g_calendar:GetDay()
	Entity_Foreach( EntityType.CHARA, function ( chara )
		chara:Update( elapsed )

		Chara_ExecuteTask( chara )
		
		--move to meeting system
		--if day == 1 then Chara_SubmitProposal( chara ) end
	end )
end