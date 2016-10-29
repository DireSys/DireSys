--[[
	Class implementation within lua
]]
f = require "diresys/func"

local class = {}

local search = function(method, parentClasses)
	--[[
		look up for 'method' in list of 'parentClasses'
	]]
	for _, parent in ipairs(parentClasses) do
		local vmethod = parent[method]
		if vmethod then
			return vmethod
		end
	end
end

function class.create(...)
	local cls = {}
	local parentClasses = {...} 

	setmetatable(cls, {
					 __index=function(methodList, vmethod)
						 return search(vmethod, parentClasses)
	end})
	cls.__index = cls

	function cls:classInit(obj)
		obj = obj or {}
		setmetatable(obj, cls)
		return obj
	end

	return cls
end

return class
