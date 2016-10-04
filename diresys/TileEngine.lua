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

	obj.tilemap = {}
	obj.tilesetBatch = {
		love.graphics.newSpriteBatch(assets.sprite_image, 10000),
		love.graphics.newSpriteBatch(assets.sprite_image, 10000),
	}

	return obj
end

function TileEngine:update(dt)
	for _, tile in ipairs(self.tilemap) do
		tile:update(dt)
	end
end

function TileEngine:add_tile(tile)
	tile.parent = self
	table.insert(self.tilemap, tile)
	self:reset()
end

function TileEngine:remove_tile(tile)
	self.tilemap = f.filter(self.tilemap, function(i) return i == tile end)
	self:reset()
end

function TileEngine:reset(layer)
	local layer = layer or 1
	self.tilesetBatch[layer]:clear()
	for _, tile in ipairs(self.tilemap) do
		local quad = tile:get_graphic(layer)
		local position = tile:get_position()
		local tileOffset = tile.graphics[layer].offset
		local offsetx = config.TILE_SIZE * tileOffset[1]
		local offsety = config.TILE_SIZE * tileOffset[2]
		
		if quad then
			self.tilesetBatch[layer]:add(quad,
										 position.x + offsetx,
										 position.y + offsety)
		end
	end
	self.tilesetBatch[layer]:flush()
end

function TileEngine:draw_tiles(viewx, viewy, layer)
	local layer = layer or 1
	love.graphics.draw(self.tilesetBatch[layer], viewx, viewy, 0,
					   config.WINDOW_SCALE, config.WINDOW_SCALE)
end

function TileEngine:draw_shadows()

end

return TileEngine
