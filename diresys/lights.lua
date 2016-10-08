--[[
	For controlling light intensities
]]
assets = require "diresys/assets"

local lights = {}

local LightSource = {}
lights.LightSource = LightSource
local LightComponent = {}
lights.LightComponent = LightComponent

function LightSource:new(gfxEngine, options)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	obj.options = options or {}
	obj.position = obj.options or {x=0.0, y=0.0}
	
	return obj
end

function LightComponent:new(parent, gfxEngine, options)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	obj.intensity = 0
	
	return obj
end

function LightComponent:getIntensitySprite()
	local spriteName = "light_intensity_" .. self.intensity
	return assets.get_sprite(spriteName)
end

return lights
