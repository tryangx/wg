function Report_Feedback( content )
	print( content )
end

-----------------------------------------

ReportSystem = class()

function ReportSystem:__init()
	System_Setup( self, SystemType.GROUP_SYS )
end

function ReportSystem:Start()
end

function ReportSystem:Update()
end