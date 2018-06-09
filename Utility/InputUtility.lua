function InputUtil_ReceiveInput()
	return io.read()
end

local _disablePause = false
function InputUtil_EnablePause( disable )
	_disablePause = disable
end

function InputUtil_Pause( ... )
	if _disablePause == true then return end
	if ... then
		print( ... )
	else
		print( "Press any key to continue" )
	end
	InputUtil_ReceiveInput()

end

function InputUtil_Wait( content, key )
	local input = nil
	if not key then
		key = content
	else
		print( content )
	end
	print( "@please input key=" .. key )
	while input ~= key do
		input = InputUtil_ReceiveInput()
	end	
end