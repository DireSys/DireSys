--[[
	Horizontal Door Tile
]]
config = require "config"
f = require "diresys/func"
Tile = require "diresys/Tile"

local DoorTile = {}

function DoorTile:new(parent, physics_world, options)
	local obj = Tile:new(parent, physics_world, options)
	obj.bounds_type = "wall"
	obj.graphics:setForeground({key="hdoor_upper0"})
	obj.graphics:setBackground({key="hdoor_lower0", offset={0, 1}})

    obj.light:setObstructsView(true)

	-- set several floor tiles under the door
	obj.graphics:set("tile00", {key="floor0", offset={0,0}})
	obj.graphics:set("tile01", {key="floor0", offset={0,1}})
	obj.graphics:set("tile10", {key="floor0", offset={1,0}})
	obj.graphics:set("tile11", {key="floor0", offset={1,1}})
	obj.graphics:set("tile20", {key="floor0", offset={2,0}})
	obj.graphics:set("tile21", {key="floor0", offset={2,1}})

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

	return obj
end

function DoorTile:init_physics()
	local dims = self:getDimensions()
	local width, height = dims.w, dims.h

	local rectwidth = width
	local rectheight = height/2
	local offsetx = rectwidth/2
	local offsety = height/2 + rectheight/2
	
	self.physics:setUseable(true)
	self.physics:setCollidable(true)
	self.physics:setMainBounds(offsetx, offsety, rectwidth, rectheight)
	self.physics:init()
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
		self.graphics:setForeground({key=self.animation.door_open[1]})
		self.graphics:setBackground({key=self.animation.door_open[2]})
		return
	elseif current_interval > cycle_interval and state == "closing" then
		self.animation.door_state = "closed"
		self.physics.fixture:setSensor(false)
		self.graphics:setForeground({key=self.animation.door_close[1]})
		self.graphics:setBackground({key=self.animation.door_close[2]})
		return
	end
	
	local animation_name = state == "opening" and "door_opening" or "door_closing"
	local animation_loop1 = self.animation[animation_name][1]
	local animation_loop2 = self.animation[animation_name][2]
	
	local anim1_step = cycle_interval / #animation_loop1
	local anim2_step = cycle_interval / #animation_loop2

	local anim1_frame = math.floor(current_interval/anim1_step) + 1
	local anim2_frame = math.floor(current_interval/anim2_step) + 1

	self.graphics:setForeground({key=animation_loop1[anim1_frame]})
	self.graphics:setBackground({key=animation_loop2[anim2_frame]})

	self.animation.current_interval = current_interval + dt
end

function DoorTile:openDoor()
	if self.animation.door_state == "closed" then
		self.animation.door_state = "opening"
		self.animation.current_interval = 0.0

        local sfx = assets.get_sound("door_open")
        if sfx then
            sfx:play()
        end

        self.light:setObstructsView(false)
	end
end

function DoorTile:closeDoor()
	if self.animation.door_state == "open" then
		self.animation.door_state = "closing"
		self.animation.current_interval = 0.0

        local sfx = assets.get_sound("door_open")
        if sfx then
            sfx:play()
        end

        self.light:setObstructsView(true)
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
