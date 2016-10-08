--[[
	For controlling light intensities
]]
assets = require "diresys/assets"
f = require "diresys/func"

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
	obj.intensity = 8
	
	return obj
end

function LightComponent:init()
	local tile = self.parent
	local dims = tile:getTileDimensions()
	for i=0, dims.w-1 do
		for j=0, dims.h-1 do
			local tagName = "light_" .. i .. j
			tile.graphics:set(tagName, {key=self:getIntensitySprite(), layer=3, offset={i, j}})
		end
	end
	tile:redraw()
end

function LightComponent:getIntensity()
	return self.intensity
end

function LightComponent:getIntensitySprite()
	local spriteName = "light_intensity_" .. self.intensity
	return spriteName
end

function LightComponent:setIntensity(val)
	assert(val >= 0 and val <= 15)
	local tile = self.parent
	self.intensity = val
	for _, lightGraphic in pairs(tile.graphics:getLayer(3)) do
		lightGraphic.key = self:getIntensitySprite()
	end
	tile:redraw()
end

return lights
