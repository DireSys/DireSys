--[[
	Door Tile
]]
config = require "config"
f = require "diresys/func"
Tile = require "diresys/Tile"

local DoorTile = {}

function DoorTile:new(parent, physics_world, options)
	local obj = Tile:new(parent, physics_world, options)
	obj:set_graphic("hdoor_upper0", 2, {0, 0})
	obj:set_graphic("hdoor_lower0", 1, {0, 1})
	obj.type = "doortile"
	obj.init_physics = DoorTile.init_physics
	obj.update = DoorTile.update
	obj.action_use = DoorTile.action_use

	-- Door Animation Functions
	obj.openDoor = DoorTile.openDoor
	obj.closeDoor = DoorTile.closeDoor
	obj.toggleDoor = DoorTile.toggleDoor
	obj.updateDoor = DoorTile.updateDoor

	obj.animation = {
		cycle_interval = 0.4,
		current_interval = 0.0,
		-- "closed", "closing", "opening", "open"
		door_state = "closed",
		door_opening = {
			{"hdoor_upper0", "hdoor_upper1",
			 "hdoor_upper2", "hdoor_upper3", "hdoor_upper4"},
			{"hdoor_lower0", "hdoor_lower1",
			 "hdoor_lower2", "hdoor_lower3", "hdoor_lower4"},
		},
		door_closing = {
			{"hdoor_upper4", "hdoor_upper3", "hdoor_upper2",
			 "hdoor_upper1", "hdoor_upper0"},
			{"hdoor_lower4", "hdoor_lower3", "hdoor_lower2",
			 "hdoor_lower1", "hdoor_lower0"}
		},
		door_close = {"hdoor_upper0", "hdoor_lower0"},
		door_open = {"hdoor_upper4", "hdoor_lower4"},
	}

	obj:init_physics()
	return obj
end

function DoorTile:init_physics()
	self.physics.body = love.physics.newBody(self.physics_world, 0, 0, "static")
	local width, height = self:get_dimensions()
	local width, height = 12, 8

	local rectwidth = width
	local rectheight = height/2
	local offsetx = rectwidth/2
	local offsety = height/2 + rectheight/2

	self.physics.shape = love.physics.newRectangleShape(
		offsetx, offsety,
		rectwidth, rectheight)
	self.physics.fixture = love.physics.newFixture(
		self.physics.body, self.physics.shape)
	self.physics.fixture:setUserData(self)
end

function DoorTile:update(dt)
	self:updateDoor(dt)
end

function DoorTile:updateDoor(dt)
	local state = self.animation.door_state
	local current_interval = self.animation.current_interval
	local cycle_interval = self.animation.cycle_interval
	
	if state == "open" or state == "closed" then
		return
	end

	if current_interval > cycle_interval and state == "opening" then
		self.animation.door_state = "open"
		self.physics.fixture:setSensor(true)
		self:set_graphic(self.animation.door_open[1], 2, {0, 0})
		self:set_graphic(self.animation.door_open[2], 1, {0, 1})
		return
	elseif current_interval > cycle_interval and state == "closing" then
		self.animation.door_state = "closed"
		self.physics.fixture:setSensor(false)
		self:set_graphic(self.animation.door_close[1], 2, {0, 0})
		self:set_graphic(self.animation.door_close[2], 1, {0, 1})
		return
	end
	
	local animation_name = state == "opening" and "door_opening" or "door_closing"
	local animation_loop1 = self.animation[animation_name][1]
	local animation_loop2 = self.animation[animation_name][2]
	
	local anim1_step = cycle_interval / #animation_loop1
	local anim2_step = cycle_interval / #animation_loop2

	local anim1_frame = math.floor(current_interval/anim1_step) + 1
	local anim2_frame = math.floor(current_interval/anim2_step) + 1

	self:set_graphic(animation_loop1[anim1_frame], 2, {0, 0})
	self:set_graphic(animation_loop2[anim1_frame], 1, {0, 1})

	self.animation.current_interval = current_interval + dt
end

function DoorTile:openDoor()
	if self.animation.door_state == "closed" then
		self.animation.door_state = "opening"
		self.animation.current_interval = 0.0
	end
end

function DoorTile:closeDoor()
	if self.animation.door_state == "open" then
		self.animation.door_state = "closing"
		self.animation.current_interval = 0.0
	end
end

function DoorTile:toggleDoor()
	if self.animation.door_state == "closed" then
		self:openDoor()
	elseif self.animation.door_state == "open" then
		self:closeDoor()
	end
end

function DoorTile:action_use()
	self:toggleDoor()
end

return DoorTile
