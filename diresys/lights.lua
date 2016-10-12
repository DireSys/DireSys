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

    obj.lightType = "static" -- "dynamic" or "static"
    obj.lightDistance = options.lightDistance or 32 -- world units?
    obj.lightFallOff = options.lightFallOff or 2 -- tiles

    obj.setPosition = LightSource.setPosition

    obj.dirtyFlag = true

    obj.tileEngine = gfxEngine

    return obj
end

function LightSource:setFallOffDistance(dist)
    self.lightFallOff = dist
end

function LightSource:setMaxDistance(dist)
    self.lightDistance = dist
end

function LightSource:setDynamic(isDynamic)
    if isDynamic then
        self.lightType = "dynamic"
    else
        self.lightType = "static"
    end
end

function LightSource:setPosition(position)
    self.position = position
end

function LightSource:update(dt)
	
end

--
-- Light Sources
--

function OmniLightSource:new(gfxEngine, options)
    local obj = LightSource:new(gfxEngine, options)
    obj.update = OmniLightSource.update
    obj.calculateIntensity = OmniLightSource.calculateIntensity
    obj.getAffectedIndices = OmniLightSource.getAffectedIndices
    obj.getObstructingIndices = OmniLightSource.getObstructingIndices

    -- cache affected indices
    obj.affected_tiles = nil
    obj.obstructing_tiles = nil 

    return obj
end

function OmniLightSource:update(dt)

    if self.dirtyFlag == false then
        return
    end

    -- Compute affected and obstructing tiles, if required
    if not self.affected_tiles then
        self.affected_tiles = self:getAffectedIndices()
    end

    if not self.obstructing_tiles then
        self.obstructing_tiles = self:getObstructingIndices()
    end

    -- Compute light on each affected tile
    local visited = {}

    for tileIndex, tilePosition in pairs(self.affected_tiles) do

        if not visited[tileIndex] then

          local tile = self.tileEngine:get_tile(TILE_UNIT(tilePosition.x), TILE_UNIT(tilePosition.y))

          if tile and tile.light then

            -- Is the path to the light obstructed?
            local isObstructed = false

            --[[ TODO does not work
            for obstructionIndex, obstructionPosition in pairs(self.obstructing_tiles) do

              -- Does the ray cross through obstruction?
              isObstructed = LINE_SEGMENT_INTERSECTS_BOX(self.position, tilePosition, obstructionPosition, WORLD_UNIT(1.0), WORLD_UNIT(1.0))

              if isObstructed then break end
            end
            ]]

            -- Add light if not obstructed
            if not isObstructed then
              local lightIntensity = self:calculateIntensity(tilePosition)

              if self.lightType == "static" then
                tile.light:addStaticIntensity(lightIntensity)
              else -- "dynamic"
                tile.light:addDynamicIntensity(lightIntensity)
              end
            end

            visited[tileIndex] = true
          end
        end 
    end

    -- Do not render static light until dirtyFlag is true
    if self.lightType == "static" then
        self.dirtyFlag = false
    end
end

function OmniLightSource:getAffectedIndices()
  
    local origin = self.position
    local radius = self.lightDistance

    local tiles = {}

    local radius2 = radius * radius

    for x = -radius, radius do
        for y = -radius, radius do
            if x * x + y * y <= radius2 then
                local tile_x = TILE_UNIT(origin.x + x)
                local tile_y = TILE_UNIT(origin.y + y)
                local tile_index = _I(tile_x, tile_y)

                if not tiles[tile_index] then
                    tiles[tile_index] = {
                        x = WORLD_UNIT(tile_x),
                        y = WORLD_UNIT(tile_y)
                    }
                end
            end
        end
    end

    return tiles
end

function OmniLightSource:getObstructingIndices()
    if not self.affected_tiles then
        return {}
    end

    local obstructions = {}

    for tileIndex, tilePosition in pairs(self.affected_tiles) do

        local tileCoords = {
            x = TILE_UNIT(tilePosition.x),
            y = TILE_UNIT(tilePosition.y)
        }

        local tile = self.tileEngine:get_tile(tileCoords.x, tileCoords.y)
        
        if tile and tile.light and tile.light:getObstructsView() then
            obstructions[tileIndex] = tilePosition 
        end
    end

    return obstructions
end

function OmniLightSource:calculateIntensity(position)

    local xrel = position.x - self.position.x
    local yrel = position.y - self.position.y

    local maxIntensity = 15 -- TODO constant?
    local zero2 = WORLD_UNIT(self.lightDistance) * WORLD_UNIT(self.lightDistance)
    local falloff2 = WORLD_UNIT(self.lightFallOff) * WORLD_UNIT(self.lightFallOff)
    local dist2 = xrel * xrel + yrel * yrel

    if dist2 > falloff2 and dist2 < zero2 then
        return math.floor(maxIntensity * (1.0 - (dist2 - falloff2) / (zero2 - falloff2)))
    elseif dist2 >= zero2 then
        return 0
    else
        return math.floor(maxIntensity)
    end

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
    obj.intensity_static = 0
    obj.intensity_dynamic = 0

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

function LightComponent:getIntensity()
    local intensity = self.intensity_static + self.intensity_dynamic

    return math.max(0, math.min(15, intensity))
end

function LightComponent:getIntensitySprite()
	local spriteName = "light_intensity_" .. self:getIntensity() 
	return spriteName
end

function LightComponent:addDynamicIntensity(val)

    self.intensity_dynamic = math.max(0, math.min(15, self.intensity_dynamic + val))

	local tile = self.parent
	for _, lightGraphic in pairs(tile.graphics:getLayer(3)) do
		lightGraphic.key = self:getIntensitySprite()
	end
	tile:redraw()
end

function LightComponent:addStaticIntensity(val)

    self.intensity_static = math.max(0, math.min(15, self.intensity_static + val))

    local tile = self.parent
	for _, lightGraphic in pairs(tile.graphics:getLayer(3)) do
		lightGraphic.key = self:getIntensitySprite()
	end
	tile:redraw()
end

function LightComponent:resetStaticLight()
    self.intensity_static = 0
end

function LightComponent:resetDynamicLight()
    self.intensity_dynamic = 0
end

function LightComponent:setObstructsView(obstructs)
    self.obstructs_view = obstructs
end

function LightComponent:getObstructsView()
    return self.obstructs_view
end


return lights
