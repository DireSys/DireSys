--[[
	The tiling engine
]]
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
	obj.resetDirtyFlag = {false, false}
	obj.tilesetBatch = {
		love.graphics.newSpriteBatch(assets.sprite_image, 10000),
		love.graphics.newSpriteBatch(assets.sprite_image, 10000),
	}

	return obj
end

function TileEngine:update(dt)
	for _, tile in pairs(self.tilemap) do
		tile:update(dt)
	end
end

function TileEngine:add_tile(tile, x, y)
	local index = x .. "," .. y
	tile.parent = self
	self.tilemap[index] = tile
end

function TileEngine:get_tile(x, y)
	local index = x .. "," .. y
	return self.tilemap[index]
end

function TileEngine:reset(layer)
	local layer = layer or 1
	self.resetDirtyFlag[layer] = true
end

function TileEngine:redraw(layer)
	local layer = layer or 1
	self.tilesetBatch[layer]:clear()
	for _, tile in pairs(self.tilemap) do
		for _, tileGraphic in ipairs(tile.graphics:getLayer(layer)) do
			local spriteQuad = assets.get_sprite(tileGraphic.key)
			if spriteQuad then
				local spritePosition = tile.graphics:getPosition(tileGraphic.tag)
				self.tilesetBatch[layer]:add(spriteQuad, spritePosition.x, spritePosition.y)
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

	love.graphics.draw(self.tilesetBatch[layer], viewx, viewy, 0,
					   config.WINDOW_SCALE, config.WINDOW_SCALE)
end

function TileEngine:draw_shadows()

end

return TileEngine
