--[[

	Graphics Library to provide a component to tiles and actors to
	manage graphics resources effectively.

]]
config = require "config"
pp = require "diresys/pp"
f = require "diresys/func"
assets = require "diresys/assets"

local gfx = {}

local TileGraphics = {}

function TileGraphics:new(parent, tileEngine)
	--[[

		Keyword Arguments:

		parent -- a TileEngine instance

	]]
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	obj.parent = parent
	obj.tileEngine = tileEngine
	obj.graphics = {
		{tag="foreground", key=nil, layer=2, offset={0, 0}, index=2},
		{tag="background", key=nil, layer=1, offset={0, 0}, index=2},
	}

	return obj
end
gfx.TileGraphics = TileGraphics

function TileGraphics:get(tag)
	local graphic = f.find(self.graphics, function(g) return g.tag == tag end)
	return graphic
end

function TileGraphics:getBackground()
	return self:get("background")
end

function TileGraphics:getForeground()
	return self:get("foreground")
end

function TileGraphics:set(tag, options)
	--[[

		Options:

		key -- the graphics key

		layer --  the layer (either 1 or 2)

		offset -- the offset of the graphic

		index --  the index for graphics on the same layer

	]]
	local options = options or {}
	local graphic = self:get(tag)
	local resetLayer = options.layer or 1
	if graphic then
		graphic.key = options.key == nil and graphic.key or options.key
		graphic.layer = options.layer == nil and graphic.layer or options.layer
		graphic.offset = options.offset == nil and graphic.offset or options.offset
		graphic.index = options.index == nil and graphic.index or options.index
		resetLayer = graphic.layer
	else
		local newGraphic = {
			tag=tag,
			key=options.key or nil,
			layer=options.layer or 1,
			offset=options.offset or {0, 0},
			index=index or 1}
		table.insert(self.graphics, newGraphic)
	end

	self.tileEngine:reset(resetLayer)
end

function TileGraphics:setBackground(options)
	--Same as :set(), except tag = "background"
	self:set("background", options)
end

function TileGraphics:setForeground(options)
	--Same as :set(), except tag = "foreground"
	self:set("foreground", options)
end

function TileGraphics:setKey(tag, key)
	local graphic = self:get(tag)
	assert(graphic)
	graphic.key = key
end

function TileGraphics:setLayer(tag, layer)
	assert(layer == 1 or layer == 2)
	local graphic = self:get(tag)
	assert(graphic)
	graphic.layer = layer
end

function TileGraphics:setOffset(tag, offset)
	assert(#offset == 2)
	local graphic = self:get(tag)
	assert(graphic)
	graphic.offset = offset
end

function TileGraphics:setIndex(tag, index)
	assert(index >= 1)
	local graphic = self:get(tag)
	graphic.index = index
end

function TileGraphics:getAll(layer)
	local layer = layer or 1

	-- sort by index
	table.sort(
		self.graphics,
		function(i, j)
			if i.index < j.index then 
				return true 
			else 
				return false 
			end 
	end)
	local layerGraphics = f.filter(
		self.graphics,
		function(g) 
			return g.layer == layer and g.key ~= nil
	end)
	return layerGraphics
end

function TileGraphics:getDimensions(tag)
	local graphic = self:get(tag)
	if graphic then
		local quad = assets.get_sprite(graphic.key)
		local x, y, w, h = quad:getViewport()
		return w, h
	else
		return nil
	end
end

function TileGraphics:getPosition(tag)
	local graphic = self:get(tag)
	local tilePosition = self.parent:getPosition()
	local position = {
		x = config.TILE_SIZE * graphic.offset[1] + tilePosition.x,
		y = config.TILE_SIZE * graphic.offset[2] + tilePosition.y,
	}
	return position
end

return gfx
