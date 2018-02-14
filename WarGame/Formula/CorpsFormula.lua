--return the food need carried to move to destination
function Corps_CalcNeedFood( corps, destination )
	local from = Asset_Get( corps, CorpsAssetID.LOCATION )
	local days = Move_CalcCorpsMoveDuration( corps, from, destination )
	--need food when back
	local needfood = corps:GetConsumeFood() * days * 2
	local hasfood  = Asset_Get( corps, CorpsAssetID.FOOD )
	return needfood - hasfood
end