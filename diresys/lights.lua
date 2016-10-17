--[[
	For controlling light intensities
]]
assets = require "diresys/assets"
f = require "diresys/func"
utils = require "diresys/utils"
pp = require "diresys/pp"

local lights = {}

local LightSource = {}
local OmniLightSource = {}
local DirectionalLightSource = {}
lights.LightSource = LightSource
lights.OmniLightSource = OmniLightSource
lights.DirectionalLightSource = DirectionalLightSource
local LightComponent = {}
lights.LightComponent = LightComponent

function LightSource:new(gfxEngine, options)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self
    obj.options = options or {}
    obj.position = obj.options.position or {x=0.0, y=0.0}

    obj.setPosition = LightSource.setPosition
    obj.getPosition = LightSource.getPosition

    obj.tileEngine = gfxEngine
    obj.dirtyFlag = true

    obj.hasChanged = LightSource.hasChanged

    return obj
end


function LightSource:getPosition()
    return self.position
end

function LightSource:setPosition(position)
    self.position = position
    self.dirtyFlag = true
end

function LightSource:update(dt)
    obj.dirtyFlag = false
end

function LightSource:hasChanged()
    return self.dirtyFlag
end

--
-- Light Sources
--

function OmniLightSource:new(gfxEngine, options)
    local obj = LightSource:new(gfxEngine, options)
    obj.update = OmniLightSource.update
    obj.calculateIntensity = OmniLightSource.calculateIntensity
    obj.getAffectedTiles = OmniLightSource.getAffectedTiles
    obj.getObstructingBounds = OmniLightSource.getObstructingBounds

    obj.lightDistance = options.lightDistance or 32 -- world units? tile units?
    obj.lightFalloff = options.lightFalloff or 8   -- world units? tile units?

    obj.setMaxDistance = OmniLightSource.setMaxDistance
    obj.getMaxDistance = OmniLightSource.getMaxDistance

    obj.setFalloffDistance = OmniLightSource.setFalloffDistance
    obj.getFalloffDistance = OmniLightSource.getFalloffDistance

    obj.obstructing_bounds = nil
    obj.computeObstructingBounds = OmniLightSource.computeObstructingBounds
    obj.getObstructingBounds = OmniLightSource.getObstructingBounds


    return obj
end

function OmniLightSource:update(dt)

end

function OmniLightSource:getObstructingBounds()

    if not self.obstructing_bounds then
        self.obstructing_bounds = self:computeObstructingBounds()
    end

    return self.obstructing_bounds

end

function OmniLightSource:computeObstructingBounds()

    local origin = self:getPosition()
    local radius = self:getMaxDistance()

    local all_obstructions = {}
    local result = {}

    local radius2 = radius * radius

    -- 1. Find all obstruction tiles in range
    for x = -radius, radius do
        for y = -radius, radius do

            if x * x + y * y <= radius2 then

                local tile = self.tileEngine:get_tile(x, y)

                if tile and tile.light and tile.light:getObstructsView() then

                    local tileDimensions = tile:getDimensions()

                    all_obstructions[#all_obstructions+1] = {
                        x = x + tileDimensions.x,
                        y = x + tileDimensions.y, 
                        h = tileDimensions.w,
                        w = tileDimensions.h
                    }

                end

            end 

        end
    end

    -- 2. Find obstruction closest to source for each tile in range
    for x = -radius, radius do
        for y = -radius, radius do

            if x * x + y * y <= radius2 then

                local min_obstruction = nil 
                local min_obstruction_dist2 = nil 

                -- Test each obstruction
                for _, obstruction in ipairs(all_obstructions) do

                    local target = {
                        x = x,
                        y = y
                    }
                    local source = self:getPosition() 
                    local box = obstruction

                    if LINE_SEGMENT_INTERSECTS_BOX( source, target, box ) then

                        local dist2 = ( box.x - source.x ) * ( box.x - source.x )
                                      + ( box.y - source.y ) * ( box.y - source.y )

                        if min_obstruction and min_obstruction_dist2 then
                            if dist2 < min_obstruction_dist2 then
                                min_obstruction = obstruction
                                min_obstruction_dist2 = dist2
                            end
                        else
                            min_obstruction = obstruction
                            min_obstruction_dist2 = dist2
                        end

                    end
                end

                -- Remember closest
                if min_obstruction then
                    result[#result+1] = min_obstruction
                end

            end

        end
    end

    pp.print(#result)

    return result
end

function OmniLightSource:setFalloffDistance(dist)
    self.lightFalloff = dist
end

function OmniLightSource:setMaxDistance(dist)
    self.lightDistance = dist
end

function OmniLightSource:getFalloffDistance()
    return self.lightFalloff
end

function OmniLightSource:getMaxDistance()
    return self.lightDistance
end

function DirectionalLightSource:new(gfxEngine, options)
	local obj = LightSource:new(gfxEngine, options)
	obj.Update = DirectionalLightSource.update

	return obj
end

function DirectionalLightSource:update(dt)
	
end

--
-- Tile Component
--

function LightComponent:new(parent, gfxEngine, options)
    local obj = {}
    setmetatable(obj, self)
    self.__index = self

    obj.parent = parent
    obj.gfxEngine = gfxEngine

    obj.obstructs_view = false 

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

function LightComponent:getIntensitySprite()
    return "light_intensity_15" -- performing shading in shaders now
end

function LightComponent:setObstructsView(obstructs)
    self.obstructs_view = obstructs
end

function LightComponent:getObstructsView()
    return self.obstructs_view
end

return lights
