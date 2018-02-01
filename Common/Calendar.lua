--------------------------
-- Calendar
--------------------------

local DAY_IN_MONTH   = 30
local MONTH_IN_YEAR  = 12
local HOUR_IN_DAY    = 24

Simple_DayPerMonth = 
{
	[1]  = 30,
	[2]  = 30,
	[3]  = 30,
	[4]  = 30,
	[5]  = 30,
	[6]  = 30,
	[7]  = 30,
	[8]  = 30,
	[9]  = 30,
	[10] = 30,
	[11] = 30,
	[12] = 30,
}

Normal_DayPerMonth =
{
	[1]  = 31,
	[2]  = 28,
	[3]  = 31,
	[4]  = 30,
	[5]  = 31,
	[6]  = 30,
	[7]  = 31,
	[8]  = 31,
	[9]  = 30,
	[10] = 31,
	[11] = 30,
	[12] = 31,
}

Calendar = class()

function Calendar:__init()
	self.year  = 2000
	--month from 1 ~ 12
	self.month = 1
	--day from 1~31
	self.day   = 1
	--hour form 0 ~ 23
	self.hour  = 0
	--true or false
	self.beforeChrist = false
	--manual compute without datas?
	self.leapYear = 0		
	--days in month
	self.daysInMonth = Simple_DayPerMonth
	
	--flag
	self.passMonth = false
	self.passYear  = false
end

function Calendar:Init( daysInMonth )
	self.daysInMonth = daysInMonth
end

-- calendar:SetDate( 2000, 1, 1, false )
function Calendar:SetDate( year, month, day, hour, beforeChrist )
	self.month = month or self.month	
	self.day   = day or self.day	
	self.year  = math.abs( year or self.year )	
	self.hour  = hour or self.hour
	if year < 0 then		
		self.beforeChrist = true
	else
		self.beforeChrist = beforeChrist ~= nil and beforeChrist or false
	end
end

function Calendar:GetDayInMonth()
	if self.daysInMonth and self.daysInMonth[self.month] then
		return self.daysInMonth[self.month]
	end
	return DAY_IN_MONTH
end

function Calendar:GetYear()
	return self.year
end

--month from 1 ~ 12
function Calendar:GetMonth()
	return self.month
end

--day from 1~31
function Calendar:GetDay()
	return self.day
end

--Important getter
function Calendar:GetDateValue()
	return self:ConvertDateValue( self.year, self.month, self.day, self.beforeChrist )
end

function Calendar:ConvertDateValue( year, month, day, beforeChrist )
	local ret = year * 100000 + month * 1000 + day * 10 + ( beforeChrist == true and 1 or 0 )
	return ret
end

function Calendar:ConvertFromDateValue( dateValue )
	local year  = math.floor( dateValue / 100000 )
	local month = math.floor( ( dateValue % 100000 ) / 1000 )
	local day   = math.floor( ( dateValue % 1000 ) / 10 )
	local beforeChrist = dateValue % 10
	--print( "Convert From DateValue=", year, month, day, beforeChrist == 1 )
	return year, month, day, beforeChrist == 1
end

--default by year
function Calendar:CreateDesc( byDay, byMonth )
	return self:CreateDateDesc( self.year, self.month, self.day, self.beforeChrist, byDay, byMonth )
end

function Calendar:CreateDateDesc( year, month, day, beforeChrist, byDay, byMonth )
	local content = ( beforeChrist == false and "BC " or "AD " )
	if byDay then
		content = content .. year .. "Y" .. month .. "M" .. day .. "D"
	elseif byMonth then
		content = content .. year .. "Y" .. month .. "M"
	else
		content = content .. year .. "Y" 
	end
	return content
end

function Calendar:CreateDateDescByValue( dateValue, byDay, byMonth )
	if not dateValue then return "" end
	if not byMonth then byMonth = true end
	if not byDay then byDay = true end
	local year, month, day, beforeChrist = self:ConvertFromDateValue( dateValue )
	return self:CreateDateDesc( year, month, day, beforeChrist, byDay, byMonth )
end

function Calendar:CreateCurrentDateDesc( byDay, byMonth )
	if not byMonth then byMonth = true end
	if not byDay then byDay = true end
	return self:CreateDateDesc( self.year, self.month, self.day, self.beforeChrist, byDay, byMonth )
end

-----------------------------
-- Operation method

function Calendar:ElapseDay( elapsedDay )
	self.passMonth = false
	self.passYear  = false

	self.day = self.day + elapsedDay
	while self.day > self:GetDayInMonth() do
		self:ElapseAMonth()
	end
end

function Calendar:ElapseAMonth()
	self.passYear  = false
	self.passMonth = true
	self.day   = self.day - self:GetDayInMonth()
	self.month = self.month + 1
	if self.month > MONTH_IN_YEAR then
		self.month = self.month - MONTH_IN_YEAR
		if self.beforeChrist then
			self.year  = self.year - 1
			if self.year == 0 then
				self.beforeChrist = true
				self.year = 1
			end
		else
			self.year = self.year + 1
		end
		self.passYear  = true
	end
end

function Calendar:ElapseADay()	
	self.hour = self.hour - HOUR_IN_DAY + 1
	self.day  = self.day + 1
	if self.day > self:GetDayInMonth() then	self:ElapseAMonth() end
end

function Calendar:ElapseAHour()
	self.hour = self.hour + 1
	if self.hour > HOUR_IN_DAY - 1 then self:ElapseADay() end
end

--------------------------------------
-- Calculate difference between two date

function Calendar:CalcNewYear( passYear )
	local year = self.beforeChrist and -self.year or self.year
	return year + passYear
end

function Calendar:CalcDiffYear( year, beforeChrist )
	year = math.abs( year )
	if beforeChrist ~= self.beforeChrist then
		return year + self.year
	end
	return math.abs( year - self.year )
end

function Calendar:CalcDiffYearByDate( dateValue )
	if not dateValue then return 0 end
	local year, month, day, beforeChrist = self:ConvertFromDateValue( dateValue )
	return self:CalcDiffYear( year, month, day, beforeChrist )
end

function Calendar:CalcDiffMonthByDate( dateValue )	
	if not dateValue then return 0 end
	local year, month, day, beforeChrist = self:ConvertFromDateValue( dateValue )
	
	if beforeChrist ~= self.beforeChrist then
		if beforeChrist then
			local totalMonth1 = ( year - 1 ) * MONTH_IN_YEAR + ( MONTH_IN_YEAR - month )
			local totalMonth2 = ( self.year - 1 ) * MONTH_IN_YEAR + self.month
			return totalMonth1 + totalMonth2
		elseif self.beforeChrist then
			local totalMonth1 = ( year - 1 ) * MONTH_IN_YEAR + month
			local totalMonth2 = ( self.year - 1 ) * MONTH_IN_YEAR + ( MONTH_IN_YEAR - self.month )
			return totalMonth1 + totalMonth2
		end		
	end
	local totalMonth1 = ( year - 1 ) * MONTH_IN_YEAR + month
	local totalMonth2 = ( self.year - 1 ) * MONTH_IN_YEAR + self.month
	return math.abs( totalMonth2 - totalMonth1 )
end

local function CalcDayDiffByDate( y1, m1, d1, b1, y2, m2, d2, b2 )
	local diffDays = 0

	if b2 ~= b1 then
		if beforeChrist then
			local totalDays1 = ( y2 - 1 ) * MONTH_IN_YEAR * DAY_IN_MONTH + ( MONTH_IN_YEAR - m2 ) * DAY_IN_MONTH + ( DAY_IN_MONTH - d2 )
			local totalDays2 = ( y1 - 1 ) * MONTH_IN_YEAR * DAY_IN_MONTH + ( m1 - 1 ) * DAY_IN_MONTH + d1
			return totalDays1 + totalDays2
		else
			local totalDays1 = ( y2 - 1 ) * MONTH_IN_YEAR * DAY_IN_MONTH + ( m2 - 1 ) * DAY_IN_MONTH + d2
			local totalDays2 = ( y1 - 1 ) * MONTH_IN_YEAR * DAY_IN_MONTH + ( MONTH_IN_YEAR - m1 ) * DAY_IN_MONTH + ( DAY_IN_MONTH - d1 )
			return totalDays1 + totalDays2
		end		
	end
	
	local totalDays1 = ( y2 - 1 ) * MONTH_IN_YEAR * DAY_IN_MONTH + ( m2 - 1 ) * DAY_IN_MONTH + d2
	local totalDays2 = ( y1 - 1 ) * MONTH_IN_YEAR * DAY_IN_MONTH + ( m1 - 1 ) * DAY_IN_MONTH + d1
	return math.abs( totalDays2 - totalDays1 )
end

function Calendar:CalcDiffDayByDate( dateValue )
	if not dateValue then return 0 end
	local year, month, day, beforeChrist = self:ConvertFromDateValue( dateValue )
	return CalcDayDiffByDate( self.year, self.month, self.day, self.beforeChrist, year, month, day, beforeChrist )
end

function Calendar:CalcDiffDayByDates( dateValue1, dateValue2 )
	local year1, month1, day1, beforeChrist1 = self:ConvertFromDateValue( dateValue1 )
	local year2, month2, day2, beforeChrist2 = self:ConvertFromDateValue( dateValue2 )
	return CalcDayDiffByDate( year1, month1, day1, beforeChrist1, year2, month2, day2, beforeChrist2 )
end