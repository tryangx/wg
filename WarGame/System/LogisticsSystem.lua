--------------------------------------------------------------
-- Logistics
--   Transport food / money / etc from City to City
--
--

LogisticsSystem = class()

function LogisticsSystem:__init()
	System_Setup( self, SystemType.LOGISTICS_SYS )
end

function LogisticsSystem:Start()
	self._tasks = {}
end

function LogisticsSystem:Update()

end