--[[
	
	Actor engine keeps track of moveable actors on the screen,
	including the player.

	Resembles the tile engine in many aspects.

]]
config = require "config"
assets = require "diresys/assets"

local ActorEngine = {}

function ActorEngine:new(physics_world, options)
	local obj = {}
	setmetatable(obj, self)
	self.__index = self

	obj.type = "actorengine"
	obj.resetDirtyFlag = {false, false}
	obj.physics_world = physics_world
	obj.actorList = {}
	obj.actorBatch = {
		love.graphics.newSpriteBatch(assets.sprite_image)
	}
	
	return obj
end

function ActorEngine:update(dt)
	for _, actor in ipairs(self.actorList) do
		actor:update(dt)
	end
end

function ActorEngine:add_actor(actor)
	actor.parent = self
	table.insert(self.actorList, actor)
end

function ActorEngine:remove_actor(actor)
	self.actorList = f.filter(self.actorList, function(i) return i == actor end)
end

function ActorEngine:reset(layer)
	local layer = layer or 1
	self.resetDirtyFlag[layer] = true
end

function ActorEngine:redrawSprite(actor)
	if actor.graphics:isHidden() then
		self:reset(1)
		self:reset(2)
	end

	for _, actorGraphic in ipairs(actor.graphics:getAll()) do
		local actorBatch = self.actorBatch[actorGraphic.layer]
		local spriteQuad = assets.get_sprite(actorGraphic.key)
		if spriteQuad and not actor.graphics:isHidden() then
			local spritePosition = actor.graphics:getPosition(actorGraphic.tag)
			local id = actorGraphic.id
			if id ~= nil then
				actorBatch:set(
					id, spriteQuad, spritePosition.x, spritePosition.y)
			else
				actorGraphic.id = actorBatch:add(
					spriteQuad, spritePosition.x, spritePosition.y)
			end
		-- This ensures that a new graphic is supplied after the reset
		elseif spriteQuad and actor.graphics:isHidden() then
			actorGraphic.id = nil
		end
	end
end

function ActorEngine:redraw(layer)
	local layer = layer or 1
	self.actorBatch[layer]:clear()
	for _, actor in ipairs(self.actorList) do
		for _, actorGraphic in ipairs(actor.graphics:getLayer(layer)) do
			local spriteQuad = assets.get_sprite(actorGraphic.key)
			if spriteQuad and not actor:isHidden() then
				local spritePosition = actor.graphics:getPosition(
					actorGraphic.tag)
				local id = self.actorBatch[layer]:add(
					spriteQuad, spritePosition.x, spritePosition.y)
				actorGraphic.id = id
			elseif spriteQuad and actor:isHidden() then
				actorGraphic.id = nil
			end	
		end
	end
	self.actorBatch[layer]:flush()
end

function ActorEngine:draw_actors(viewx, viewy, layer)
	local layer = layer or 1
	-- need to refresh all actors every frame, since they are dynamic
	if self.resetDirtyFlag[layer] then
		self:redraw(layer)
		self.resetDirtyFlag[layer] = false
	end
	--love.graphics.setColor(0, 0, 0, 0)
	love.graphics.draw(self.actorBatch[layer], viewx, viewy, 0,
					   config.WINDOW_SCALE, config.WINDOW_SCALE)
end

return ActorEngine
