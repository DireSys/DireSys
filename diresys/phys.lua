--[[
	
	Physics Library to provide a component to tiles and actors to
	manage physics resources effectively.

]]
require "diresys/utils"
config = require "config"
class = require "diresys/class"
pp = require "diresys/pp"
f = require "diresys/func"
assets = require "diresys/assets"

local phys = {}

local PhysicsComponent = class.create()
local TilePhysicsComponent = class.create(PhysicsComponent)
local ActorPhysicsComponent = class.create(PhysicsComponent)

phys.TilePhysicsComponent = TilePhysicsComponent
phys.ActorPhysicsComponent = ActorPhysicsComponent

function PhysicsComponent:new(parent, physicsWorld)
	--[[

		Keyword Arguments:

		parent -- a Tile instance

		physicsWorld -- a love.World instance

	]]
	local obj = self:classInit()
	obj.parent = parent
	obj.physicsWorld = physicsWorld
	
	obj.body = nil
	obj.bounds = nil
	obj.shape = nil
	obj.fixture = nil

	obj.damping = 0.1
	obj.mass = 1
	obj.bodytype = "static"
	obj.enabled = true
	obj.collidable = true
	obj.useable = false
	obj.moveable = false

	return obj
end

function PhysicsComponent:init()
	local position = self.parent:getPosition()
	if not self.body and self.enabled then
		self.body = love.physics.newBody(
			self.physicsWorld, position.x, position.y, self.bodytype)
		self.body:setFixedRotation(true)
		self.body:setMass(self.mass)
		self.body:setLinearDamping(self.damping)

		local dims = self.parent:getDimensions()
		self.bounds = self.bounds or {ox = dims.w/2,
									  oy = dims.h/2,
									  w = dims.w,
									  h = dims.h}

		self.shape = love.physics.newRectangleShape(
			self.bounds.ox, self.bounds.oy,
			self.bounds.w, self.bounds.h)

		self.fixture = love.physics.newFixture(
			self.body, self.shape)
		self.fixture:setSensor(not self.collidable)
		self.fixture:setUserData(self.useable and self.parent or nil)
	end
end

function PhysicsComponent:setEnabled(bool)
	self.enabled = bool == nil and true or bool
	self:init()
	if self.body then
		self.body:setActive(self.enabled)
	end
end

function PhysicsComponent:setMoveable(bool)
	self.moveable = bool == nil and true or bool
	if not self.moveable and self.body then
		self:setVelocity(0, 0)
	end
end

function PhysicsComponent:setCollidable(bool)
	self.collidable = bool == nil and true or bool
	if self.fixture then
		self.fixture:setSensor(not self.collidable)
	end
end

function PhysicsComponent:setMainBounds(ox, oy, w, h)
	self.bounds = {ox=ox, oy=oy, w=w, h=h}
	if self.body and self.fixture then
		self.fixture:destroy()
		
		self.shape = love.physics.newRectangleShape(
			self.bounds.ox, self.bounds.oy,
			self.bounds.w, self.bounds.h)

		self.fixture = love.physics.newFixture(
			self.body, self.shape)
	end
end

function PhysicsComponent:setUseable(bool)
	self.useable = bool == nil and true or bool
	if self.body and self.fixture then
		self.fixture:setUserData(self.useable and self.parent or nil)
	end
end

function PhysicsComponent:setVelocity(vx, vy)
	if self.body then
		if self.moveable then
			self.body:setLinearVelocity(vx, vy)
		else
			self.body:setLinearVelocity(0, 0)
		end
	end
end

function PhysicsComponent:setDamping(val)
	self.damping = val
	if self.body then
		self.body:setLinearDamping(self.damping)
	end
end

function PhysicsComponent:setMass(val)
	self.mass = val
	if self.body then
		self.body:setLinearDamping(self.mass)
	end
end

function PhysicsComponent:destroy()
	if self.body then
		self.body:destroy()
		self.body = nil
		self.fixture = nil
		self.shape = nil
	end
end

function TilePhysicsComponent:new(parent, physicsWorld)
	local obj = PhysicsComponent.new(self, parent, physicsWorld)
	return obj
end

function ActorPhysicsComponent:new(parent, physicsWorld)
	local obj = PhysicsComponent.new(self, parent, physicsWorld)
	obj.bodytype = "dynamic"
	obj.enabled = true
	obj.collidable = true
	obj.useable = true
	obj.moveable = true
	return obj
end

return phys
