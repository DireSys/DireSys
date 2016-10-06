--[[
	
	Physics Library to provide a component to tiles and actors to
	manage physics resources effectively.

]]
require "diresys/utils"
config = require "config"
pp = require "diresys/pp"
f = require "diresys/func"
assets = require "diresys/assets"

local phys = {}

local TilePhysics = {}

function TilePhysics:new(parent, physicsWorld)
	--[[

		Keyword Arguments:

		parent -- a Tile instance

		physicsWorld -- a love.World instance

	]]
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	obj.parent = parent
	obj.physicsWorld = physicsWorld
	
	obj.body = nil
	obj.bounds = nil
	obj.shape = nil
	obj.fixture = nil

	obj.bodytype = "static"
	obj.enabled = true
	obj.collidable = true
	obj.useable = false

	return obj
end
phys.TilePhysics = TilePhysics

function TilePhysics:init()
	local position = self.parent:getPosition()
	if not self.body and self.enabled then
		self.body = love.physics.newBody(
			self.physicsWorld, position.x, position.y, self.bodytype)
		
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

function TilePhysics:setEnabled(bool)
	self.enabled = bool == nil and true or bool
	self:init()
	if self.body then
		self.body:setActive(self.enabled)
	end
end

function TilePhysics:setCollidable(bool)
	self.collidable = bool == nil and true or bool
	if self.fixture then
		self.fixture:setSensor(not self.collidable)
	end
end

function TilePhysics:setMainBounds(ox, oy, w, h)
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

function TilePhysics:setUseable(bool)
	self.useable = bool == nil and true or bool
	if self.body and self.fixture then
		self.fixture:setUserData(self.useable and self.parent or nil)
	end
end

function TilePhysics:destroy()
	if self.body then
		self.body:destroy()
		self.body = nil
		self.fixture = nil
		self.shape = nil
	end
end

return phys
