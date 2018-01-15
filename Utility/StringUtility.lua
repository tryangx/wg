function String_ToStr( data, item )
	if not data then
		return "--"
	end
	return data[item] or "--"
end