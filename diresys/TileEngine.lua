--[[
	The tiling engine
]]
require "diresys/utils"
config = require "config"
assets = require "diresys/assets"
f = require "diresys/func"
pp = require "diresys/pp"

local TileEngine = {}

function TileEngine:new(options)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

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

function TileEngine:draw_shadows(viewx, viewy, layer)
	local shadowLayer = layer or 3

	if self.resetDirtyFlag[shadowLayer] then
		self:redraw(shadowLayer)
		self.resetDirtyFlag[shadowLayer] = false
	end

	--love.graphics.setColor(0, 0, 0)
	love.graphics.setBlendMode("darken", "premultiplied")
	love.graphics.draw(self.tilesetBatch[shadowLayer], viewx, viewy, 0,
					   config.WINDOW_SCALE, config.WINDOW_SCALE)
end

return TileEngine
