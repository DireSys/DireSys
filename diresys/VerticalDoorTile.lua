--[[
	A Vertical Door Tile
]]
config = require "config"
assets = require "diresys/assets"
f = require "diresys/func"
Tile = require "diresys/Tile"
anim = require "diresys/anim"

local VerticalDoorTile = {}

function VerticalDoorTile:new(parent, physics_world, options)
	local obj = Tile:new(parent, physics_world, options)
	obj.type = "doortile"
	-- force it to look like empty space
	obj.bounds_type = "empty"

	-- Methods
	obj.update = VerticalDoorTile.update
	obj.action_use = VerticalDoorTile.action_use
	obj.openDoor = VerticalDoorTile.openDoor
	obj.closeDoor = VerticalDoorTile.closeDoor
	obj.toggleDoor = VerticalDoorTile.toggleDoor
	obj.handleClosed = VerticalDoorTile.handleClosed
	obj.handleOpened = VerticalDoorTile.handleOpened

	-- Graphics
	obj.graphics:setBackground({key="vdoor_upper0"})
	obj.graphics:setForeground({key="vdoor_lower0", offset={0, 2}})
	
	-- Additional Floor tiles
	obj.graphics:set("tile00", {key="floor0", offset={0,0}})
	obj.graphics:set("tile01", {key="floor0", offset={0,1}})
	obj.graphics:set("tile02", {key="floor0", offset={0,2}})

	-- Physics
	obj.physics:setCollidable(true)
	obj.physics:setUseable(true)
	obj.physics:init()

	-- Animations
	obj.animationUpper = anim.AnimationBatch:new(obj)
	obj.animationLower = anim.AnimationBatch:new(obj)
	
	obj.animationUpper:newAnim(
		"closed", {"vdoor_upper0"}, {loop=false})
	obj.animationLower:newAnim(
		"closed", {"vdoor_lower0"}, {loop=false})

	obj.animationUpper:newAnim(
		"open", {"vdoor_upper3"}, {loop=true})
	obj.animationLower:newAnim(
		"open", {"vdoor_lower3"}, {loop=true})

	obj.animationUpper:newAnim(
		"opening", 
		{"vdoor_upper0", "vdoor_upper1", "vdoor_upper2", "vdoor_upper3"},
		{loop=true, callback=obj.handleOpened})
	obj.animationLower:newAnim(
		"opening", 
		{"vdoor_lower0", "vdoor_lower1", "vdoor_lower2", "vdoor_lower3"},
		{loop=true})

	obj.animationUpper:newAnim(
		"closing", 
		{"vdoor_upper3", "vdoor_upper2", "vdoor_upper1", "vdoor_upper0"},
		{loop=true, callback=obj.handleClosed})
	obj.animationLower:newAnim(
		"closing", 
		{"vdoor_lower3", "vdoor_lower2", "vdoor_lower1", "vdoor_lower0"},
		{loop=true})

	-- Init Animation
	obj.animationUpper:setAnim("closed")
	obj.animationLower:setAnim("closed")

	return obj
end

function VerticalDoorTile:update(dt)
	self.animationUpper:update(dt)
	self.animationLower:update(dt)

	self.graphics:setBackground({key=self.animationUpper:getFrame()})
	self.graphics:setForeground({key=self.animationLower:getFrame()})
end

function VerticalDoorTile:action_use()
	self:toggleDoor()
end

function VerticalDoorTile:handleOpened()
	self.physics:setCollidable(false)
	self.animationUpper:setAnim("open")
	self.animationLower:setAnim("open")
end

function VerticalDoorTile:handleClosed()
	self.physics:setCollidable(true)
	self.animationUpper:setAnim("closed")
	self.animationLower:setAnim("closed")
end

function VerticalDoorTile:openDoor()
	local state = self.animationUpper.current
	if state == "closed" then
		self.animationUpper:setAnim("opening")
		self.animationLower:setAnim("opening")

        local sfx = assets.get_sound("door_open")
        if sfx then
            sfx:play()
        end
	end
end

function VerticalDoorTile:closeDoor()
	local state = self.animationUpper.current
	if state == "open" then
		self.animationUpper:setAnim("closing")
		self.animationLower:setAnim("closing")

		local sfx = assets.get_sound("door_open")
        if sfx then
            sfx:play()
        end
	end
end

function VerticalDoorTile:toggleDoor()
	local state = self.animationUpper.current
	if state == "open" then
		self:closeDoor()
	elseif state == "closed" then
		self:openDoor()
	end
end

return VerticalDoorTile
