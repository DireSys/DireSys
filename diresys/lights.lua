--[[
	For controlling light intensities
]]
assets = require "diresys/assets"
f = require "diresys/func"
utils = require "diresys/utils"

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
	obj.lightDistance = options.lightDistance or 12
	obj.lightFallOff = options.lightFallOff or 2

    obj.setPosition = LightSource.setPosition

    obj.staticDirtyFlag = true

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

    obj.rays = OmniLightSource.generateRays(WORLD_UNIT(obj.lightDistance))

    --obj.lightType = "dynamic"
    
	return obj
end

function OmniLightSource:update(dt)

    if self.lightType == "static" and self.staticDirtyFlag == false then
        return
    end

    local visited = {}

    for _, ray in pairs(self.rays) do
        for _, p in pairs(ray) do

            -- map to tile 
            local tile_x = TILE_UNIT(self.position.x + p.x)
            local tile_y = TILE_UNIT(self.position.y + p.y)
            local tileIndex = _I(tile_x, tile_y)

            -- apply lighting to tile if not visited
            if not visited[tileIndex] then
                visited[tileIndex] = true -- it's now visited

                -- get tile
                local tile = self.tileEngine:get_tile(tile_x, tile_y)

                if tile and tile.light then
                    -- calculate light intensity on tile from this source
                    local thisIntensity = self:calculateIntensity(p.x, p.y)

                    -- add calculated light to tile
                    if self.lightType == "static" then
                        tile.light:addStaticIntensity(thisIntensity)
                        self.staticDirtyFlag = false 
                    else -- "dynamic"
                        tile.light:addDynamicIntensity(thisIntensity)
                    end

                    if tile.light:getObstructsView() then
                        break -- do not continue with this ray
                    end

                end
            end
        end
    end

end

function OmniLightSource.generateRays(radius)
    local rays = {}

    local dRadius = 1.0 
    local dAngle = 1.0 / radius 
    local rayCount = 2.0 * 3.14159 / dAngle

    -- Generate a bunch of rays around a point, angles between 0 and 2*pi
    -- Generate each ray as a set of points from r=dRadius to r=maxRadius
    for i = 0, rayCount-1 do
        local a = i * dAngle
        rays[a] = {}

        for r = dRadius, radius, dRadius do
            rays[a][r] = {
                x = r * math.cos(a),
                y = r * math.sin(a) 
            }
        end
    end

    return rays
end

function OmniLightSource:calculateIntensity(xrel, yrel)

    local maxIntensity = 15 -- TODO constant?
    local zero2 = WORLD_UNIT(self.lightDistance) * WORLD_UNIT(self.lightDistance)
    local falloff2 = WORLD_UNIT(self.lightFallOff) * WORLD_UNIT(self.lightFallOff)
    local dist2 = xrel * xrel + yrel * yrel

    if dist2 > falloff2 and dist2 < zero2 then
        return math.floor(maxIntensity * (1.0 - (dist2 - falloff2) / (zero2 - falloff2)))
    elseif dist2 > zero2 then
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
