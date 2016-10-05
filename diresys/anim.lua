--[[
	For Actor and Tile Animations
]]

local anim = {}

local AnimationLoop = {}

function AnimationLoop:new(frames, cycleInterval, options)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	obj.options = options or {}
	obj.frames = {}
	obj.currentInterval = 0.0
	obj.cycleInterval = cycleInterval or 0.5 -- seconds

	return obj
end
anim.AnimationLoop = AnimationLoop

function AnimationLoop:update(dt)
	--pass
end

function AnimationLoop:reset()
	self.currentInterval = 0.0
end

return anim
