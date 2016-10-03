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
	obj.tilesetBatch = love.graphics.newSpriteBatch(assets.sprite_image)

	return obj
end

function TileEngine:add_tile(x, y, tile)
	tile:set_position(x, y)
	table.insert(self.tilemap, tile)
	self:reset_tilesetBatch()
end

function TileEngine:remove_tile(tile)
	self.tilemap = f.filter(self.tilemap, function(i) return i == tile end)
	self:reset_tilesetBatch()
end

function TileEngine:reset_tilesetBatch()
	self.tilesetBatch:clear()
	for _, tile in ipairs(self.tilemap) do
		local quad = tile:get_graphic()
		pp.print("Quad: ")
		pp.print(quad)
		local position = tile:get_position()
		self.tilesetBatch:add(quad, position.x, position.y)
	end
	self.tilesetBatch:flush()
end

function TileEngine:draw_tiles(viewx, viewy)
	love.graphics.draw(self.tilesetBatch, viewx, viewy, 0,
					   config.WINDOW_SCALE, config.WINDOW_SCALE)
end

function TileEngine:draw_shadows()

end

return TileEngine
