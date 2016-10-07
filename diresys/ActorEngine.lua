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
	obj.physics_world = physics_world
	obj.actorList = {}
	obj.actorBatch = love.graphics.newSpriteBatch(assets.sprite_image)

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

function ActorEngine:reset()
	self.actorBatch:clear()
	for _, actor in ipairs(self.actorList) do
		local quad = actor:get_graphic()
		if quad and not actor.hidden then
			local position = actor:get_position()
			self.actorBatch:add(quad, position.x, position.y)
		end
	end
	self.actorBatch:flush()
end

function ActorEngine:draw_actors(viewx, viewy)
	-- need to refresh all actors every frame, since they are dynamic
	self:reset()
	love.graphics.draw(self.actorBatch, viewx, viewy, 0,
					   config.WINDOW_SCALE, config.WINDOW_SCALE)
end

return ActorEngine
