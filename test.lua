

--[[
--test inherit

A = class()
function A:__init()
	print( "inita")
	self.hello = 1
end
function A:test()
	print( "a" .. self.hello )
end

B = class(A)
function B:__init()
	print( "initb")
	--self[A]:__init(s)
	self.hello = 2
end
function B:test() 	
	self[A]:test()
	print( "b" .. self.hello )
end

b = B()
b:test()

--]]

--[[

A = class()
function A:__init(s) self.s = s end
function A:ps() print(self.s) end

B = class(A)
function B:__init(s, s1)
	self[A]:__init(s)
	self.s1 = s1
end
function B:ps1() print(self.s1) end

C = class(B)
function C:__init(s, s1, s2)
	self[B]:__init(s, s1)
	self.s2 = s2
end
--]]

--[[

A = class()
function A:__init( s )
	self.hello = s
end
function A:test()
	print( "a" .. self.hello )
end

function A:get()
	return self.hello
end

B = class(A)
function B:__init()
	self[A]:__init( "type_b" )
end
function B:test()
	self[A]:test()
	print( "b" .. self:get() )
end

b = B()
b:test()

]]