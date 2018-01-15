local _caches = {}

function Cache_Set( key, value )
	if key then
		_caches[key] = value
	end
end

function Cache_Get( key )
	return _caches[key]
end