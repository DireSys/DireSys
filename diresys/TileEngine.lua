--[[
	The tiling engine
]]
require "diresys/utils"
class = require "diresys/class"
config = require "config"
assets = require "diresys/assets"
f = require "diresys/func"
pp = require "diresys/pp"
shaders = require "diresys/shaders"
perf = require "diresys/perf"

local TileEngine = class.create()

function TileEngine:new(options)
	local obj = self:classInit()

	obj.type = "tileengine"
	obj.tilemap = {}
	obj.resetDirtyFlag = {false, false, false}
	obj.tilesetBatch = {
		love.graphics.newSpriteBatch(assets.sprite_image, 5000),
		love.graphics.newSpriteBatch(assets.sprite_image, 5000),
		love.graphics.newSpriteBatch(assets.sprite_image, 5000),
	}

	return obj
end

function TileEngine:update(dt)
	for _, tile in pairs(self.tilemap) do
		tile:update(dt)
	end
end

function TileEngine:add_tile(tile, x, y)
	tile.parent = self
	self.tilemap[_I(x,y)] = tile
end

function TileEngine:has_tile(x, y)
	return self.tilemap[_I(x,y)] ~= nil
end

function TileEngine:get_tile(x, y)
	if x < 0 or y < 0 then return nil end

	local tile = self.tilemap[_I(x,y)]
	if tile and tile:checkTilePoint(x, y) then
		return tile
	elseif tile then
		return nil
	end
	
	-- if there are tiles above us and to the left of us, we need to
	-- check if either one is the tile we want.
	return self:get_tile(x-1, y) or self:get_tile(x, y-1)
end

function TileEngine:reset()
	self.resetDirtyFlag[1] = true
	self.resetDirtyFlag[2] = true
	self.resetDirtyFlag[3] = true
end

function TileEngine:redrawSprite(tile)
	for _, tileGraphic in ipairs(tile.graphics:getAll()) do
		local tilesetBatch = self.tilesetBatch[tileGraphic.layer]
		local spriteQuad = assets.get_sprite(tileGraphic.key)
		if spriteQuad then
			local spritePosition = tile.graphics:getPosition(tileGraphic.tag)
			local id = tileGraphic.id
			if id ~= nil then
				tilesetBatch:set(
					id, spriteQuad, spritePosition.x, spritePosition.y)
			else
				tileGraphic.id = tilesetBatch:add(
					spriteQuad, spritePosition.x, spritePosition.y)
			end
		end
	end
end

function TileEngine:redraw(layer)
	local layer = layer or 1
	self.tilesetBatch[layer]:clear()
	for _, tile in pairs(self.tilemap) do
		for _, tileGraphic in ipairs(tile.graphics:getLayer(layer)) do
			local spriteQuad = assets.get_sprite(tileGraphic.key)
			if spriteQuad then
				local spritePosition = tile.graphics:getPosition(tileGraphic.tag)
				local id = self.tilesetBatch[layer]:add(
					spriteQuad, spritePosition.x, spritePosition.y)
				tileGraphic.id = id
			end
			
		end
	end
	self.tilesetBatch[layer]:flush()	
end

function TileEngine:draw_tiles(viewx, viewy, layer)
	local layer = layer or 1

	if self.resetDirtyFlag[layer] then
		self:redraw(layer)
		self.resetDirtyFlag[layer] = false
	end
	--love.graphics.setColor(0, 0, 0)
	love.graphics.setBlendMode("alpha", "alphamultiply")
	love.graphics.draw(self.tilesetBatch[layer], viewx, viewy, 0,
					   config.WINDOW_SCALE, config.WINDOW_SCALE)
end

function TileEngine:draw_shadows(lights, sendLights, viewx, viewy, layer)
	local shadowLayer = layer or 3

	if self.resetDirtyFlag[shadowLayer] then
		self:redraw(shadowLayer)
		self.resetDirtyFlag[shadowLayer] = false
	end

	--love.graphics.setColor(0, 0, 0)
	love.graphics.setBlendMode("darken", "premultiplied")

    local shader = shaders.render_lights

    love.graphics.setShader(shader)

    shader:send("scale", 4)
    shader:send("viewport_offset", {-viewx, -viewy})

    if sendLights then

        -- for each light...
        local light_positions = {}
        local light_falloffs = {}
        local light_limits = {}
        local obstructions = {}

        for _, light in ipairs(lights) do

            local light_position = light:getPosition()

            local light_falloff = 0
            local light_limit = 0

            if light.getFalloffDistance and light.getMaxDistance then
                light_falloff = WORLD_UNIT(light:getFalloffDistance())
                light_limit = WORLD_UNIT(light:getMaxDistance())
            end

            --local obstructing_bounds = light:getObstructingBounds()

            light_positions[#light_positions+1] = { WORLD_UNIT(light_position.x),
                                                    WORLD_UNIT(light_position.y)  }

            light_falloffs[#light_falloffs+1] = light_falloff
            light_limits[#light_limits+1] = light_limit

            --[[
            for _, obstruction in ipairs(obstructing_bounds) do
                obstructions[#obstructions+1] = { 
                    WORLD_UNIT(obstruction.x),
                    WORLD_UNIT(obstruction.y),
                    WORLD_UNIT(obstruction.w),
                    WORLD_UNIT(obstruction.h)
                }
            end
            ]]
        end

		perf.step("GFX Transfer")
        shader:send("light_positions", unpack(light_positions))
        shader:send("light_falloffs", unpack(light_falloffs))
        shader:send("light_limits", unpack(light_limits))
        shader:sendInt("light_count", #light_positions)
		perf.step("GFX Transfer", {once=true})

        --[[
        if #obstructions > 0 then
            shader:send("obstruction_bounds", unpack(obstructions))
        end

        shader:sendInt("obstruction_count", #obstructions)
        ]]
    end

    love.graphics.draw(self.tilesetBatch[shadowLayer], viewx, viewy, 0,
                       config.WINDOW_SCALE, config.WINDOW_SCALE)

    love.graphics.setShader()
end


return TileEngine
