local _caches = {}

function Cache_Set( key, value )
	if key then
		_caches[key] = value
	end
end

function Cache_Get( key )
	return _caches[key]
end

function Cache_Clear()
	_caches = {}
end

--use cache to improve the efficiency
function Cache_GetAssetID( entity, id )
	local name = entity.type .. "_" .. entity.id .. "_" .. id
	local value = _caches[name]
	if not value then
		value = Asset_Get( entity, id )
		_caches[name] = value
	end
	return value
end