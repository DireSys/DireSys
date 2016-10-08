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

	obj.parent = parent
	obj.gfxEngine = gfxEngine
	obj.intensity = 0
	
	return obj
end

function LightComponent:init()
	local shadowLayer = 3
	local tile = self.parent
	tile.graphics:set({key=self:getIntensitySprite(), layer=3})
	tile:redraw(shadowLayer)
end

function LightComponent:getIntensitySprite()
	local spriteName = "light_intensity_" .. self.intensity
	return assets.get_sprite(spriteName)
end

return lights
