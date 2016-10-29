--[[

	Graphics Library to provide a component to tiles and actors to
	manage graphics resources effectively.

]]
require "diresys/utils"
config = require "config"
class = require "diresys/class"
pp = require "diresys/pp"
f = require "diresys/func"
assets = require "diresys/assets"

local gfx = {}

local GraphicsComponent = class.create()
local TileGraphicsComponent = class.create(GraphicsComponent)
local ActorGraphicsComponent = class.create(GraphicsComponent)

gfx.TileGraphicsComponent = TileGraphicsComponent
gfx.ActorGraphicsComponent = ActorGraphicsComponent

function GraphicsComponent:new(parent, gfxEngine)
	--[[

		Graphics components contain objects within self.graphics,
		which represent drawn assets on the screen.

		Keyword Arguments:

		parent -- a Tile instance

		gfxEngine -- a GfxEngine instance (TileEngine, ActorEngine)

		Notes:

		- The graphics component comes with two pre-defined graphics
          called 'foreground' and 'background'

	]]
	local obj = self:classInit()

	obj.hidden = false
	obj.parent = parent
	obj.gfxEngine = gfxEngine
	obj.graphics = {
		{tag="foreground", key=nil, layer=2, offset={0, 0}, index=2, id=nil},
		{tag="background", key=nil, layer=1, offset={0, 0}, index=2, id=nil},
	}

	return obj
end


function GraphicsComponent:get(tag)
	--[[

		Gets a graphic with the given tag name

	]]
	local graphic = f.find(self.graphics, function(g) return g.tag == tag end)
	return graphic
end

function GraphicsComponent:getBackground()
	--[[

		Get the pre-defined 'background' graphic

	]]
	return self:get("background")
end

function GraphicsComponent:getForeground()
	--[[
		
		Get the pre-defined 'foreground' graphic
		
	]]
	return self:get("foreground")
end

function GraphicsComponent:set(tag, options)
	--[[

		Keyword Arguments:

		tag -- The tag name of the graphic that you want to modify. If
		the given graphic with the provided tagname does not exist, it
		will be created.

		Options:

		key -- the graphics key. The key is the name of the sprite in
		assets.lua.

		layer -- the layer (either 1 or 2). Layer 1 is drawn first
		(background) and Layer 2 is drawn last (foreground)

		offset -- the offset of the graphic expressed in tile
		coordinates.

		index -- the index for graphics on the same layer. A higher
		index is drawn last.

		Notes:

		- this function can be quirky in situations where you want to
          set values to nil. Please use GraphicsComponent:setKey to
          remove a key from a graphic.

		- graphics also contain an 'id' which is an identifier for
          it's quad representation inside of a sprite batch.

	]]
	assert(type(tag) == "string")
	local options = options or {}
	local graphic = self:get(tag)
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

	self:redraw()
end

function GraphicsComponent:redraw()
	--[[

		Redraws the current graphics component within the tile engine.

	]]
	self.gfxEngine:redrawSprite(self.parent)
end

function GraphicsComponent:setBackground(options)
	--Same as :set(), except tag = "background"
	self:set("background", options)
end

function GraphicsComponent:setForeground(options)
	--Same as :set(), except tag = "foreground"
	self:set("foreground", options)
end

function GraphicsComponent:setKey(tag, key)
	--[[

		Sets the 'key' property for the provided graphic's tag

		Keyword Argument:

		tag -- The tag for the graphic you wish to modify

		key -- The new key you would like to assign.
		
	]]
	local graphic = self:get(tag)
	assert(graphic)
	graphic.key = key
end

function GraphicsComponent:setLayer(tag, layer)
	assert(layer >= 1 or layer <= 3)
	local graphic = self:get(tag)
	assert(graphic)
	graphic.layer = layer
end

function GraphicsComponent:setOffset(tag, offset)
	assert(#offset == 2)
	local graphic = self:get(tag)
	assert(graphic)
	graphic.offset = offset
end

function GraphicsComponent:setIndex(tag, index)
	assert(index >= 1)
	local graphic = self:get(tag)
	graphic.index = index
end

function GraphicsComponent:getLayer(layer)
	--[[

		Gets all of the graphics for the specified layer

		Keyword Arguments:

		layer -- The layer of graphics you want [default: 1]

		Notes:

		- Sorts the graphics with respect to the provided index.

		- This will also avoid returning graphics where the key is
          nil.

	]]
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

function GraphicsComponent:getAll()
	-- Retrieves all graphics, except for graphics where key is nil
	return f.filter(self.graphics, function(g) return g.key ~= nil end)
end

function GraphicsComponent:getDimensions(tag)
	--[[

		Retrieves the graphics dimensions

		Keyword Arguments:

		tag -- If no tag is provided or "*all" is provided, will
		return the rectangular dimension bounds for the accumulation
		of graphics that currently make up this graphics
		component. Otherwise, it will only return the dimensions of
		the given tagged graphic.

	]]
	if tag and tag ~= "*all" then
		return self:getTagDimensions(tag)
	end

	local startx = nil
	local endx = nil
	local starty = nil
	local endy = nil
	local tags = f.pluck(self:getAll(), "tag")
	for _, tag in ipairs(tags) do
		local dim = self:getTagDimensions(tag)
		if dim ~= nil then
			if startx == nil or dim.x < startx then
				startx = dim.x
			end

			if starty == nil or dim.y < starty then
				starty = dim.y
			end

			if endx == nil or (dim.x + dim.w) > endx then
				endx = (dim.x + dim.w)
			end

			if endy == nil or (dim.y + dim.h) > endy then
				endy = (dim.y + dim.h)
			end
		end
	end

	return {
		x = startx,
		y = starty,
		w = endx - startx,
		h = endy - starty,
	}
end

function GraphicsComponent:getTagDimensions(tag)
	--[[

		Retrieves the dimensions of the graphic with the given tag

		Notes:

		- GraphicsComponent:getDimensions(tag) will call this, if you
          provide a tag.

	]]
	local graphic = self:get(tag)
	if not graphic then
		print("Failed to find tag " .. tostring(tag))
		return nil
	end

	local graphicPosition = self:getPosition(tag)
		
	local quad = assets.get_sprite(graphic.key)
	if not quad then
		return nil
	end
	
	local x, y, w, h = quad:getViewport()
	return {
		-- width / height
		w = w,
		h = h,
		-- x position / y position in world coordinates
		x = graphicPosition.x,
		y = graphicPosition.y,
		-- offset in world units wrt parent tile
		ox = WORLD_UNIT(graphic.offset[1]),
		oy = WORLD_UNIT(graphic.offset[2]),
	}
end

function GraphicsComponent:getTileDimensions(tag)
	--[[

		The same as GraphicsComponent:getDimensions, but returns the
		result in Tile coordinates.

	]]
	local graphic = self:get(tag)
	local dims = self:getDimensions(tag)
	if graphic then
		return {
			-- tile width / tile height
			w = TILE_UNIT(dims.w),
			h = TILE_UNIT(dims.h),
			-- tile x position / tile y position in world tile coordinates
			x = TILE_UNIT(dims.x),
			y = TILE_UNIT(dims.y),
			-- tile offset wrt parent tile
			ox = graphic.offset[1],
			oy = graphic.offset[2],
		}
	else
		return nil
	end
end

function GraphicsComponent:getPosition(tag)
	--[[
		
		Gets the position of a graphic in world coordinates

	]]
	local graphic = self:get(tag)
	local tilePosition = self.parent:getPosition()
	if graphic then
		local position = {
			x = WORLD_UNIT(graphic.offset[1]) + tilePosition.x,
			y = WORLD_UNIT(graphic.offset[2]) + tilePosition.y,
		}
		return position
	else
		return nil
	end
end

function GraphicsComponent:setHidden(bool)
	--[[

		If true, will not draw the graphics within this component.
		
	]]
	self.hidden = bool == nil and false or bool
	self:redraw()
end

function GraphicsComponent:isHidden()
	--[[

		Returns true if the graphics component is currently hidden.

	]]
	return self.hidden
end

function TileGraphicsComponent:new(parent, gfxEngine)
	local obj = GraphicsComponent.new(self, parent, gfxEngine)
	return obj
end

function ActorGraphicsComponent:new(parent, gfxEngine)
	local obj = GraphicsComponent.new(self, parent, gfxEngine)
	return obj
end

return gfx
