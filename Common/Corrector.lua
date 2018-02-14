CorrectLevel = 
{
	NORMAL    = 0,
	IMPORTANT = 1,
}

local _logs = {}

function CRR_Tolerate( content, lv )
	if not lv then lv = CorrectLevel.NORMAL end
	if lv ~= CorrectLevel.NORMAL then 
		InputUtil_Pause( "[TOLERATE]" .. content )
	else
		print( "[TOLERATE]" .. content )
	end
	table.insert( _logs, content )	
end