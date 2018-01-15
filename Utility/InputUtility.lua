function InputUtil_ReceiveInput()
	return io.read()
end


function InputUtil_Pause( ... )
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