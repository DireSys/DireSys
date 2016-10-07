--[[
	Closet Tile
]]
config = require "config"
f = require "diresys/func"
Tile = require "diresys/Tile"
anim = require "diresys/anim"

local ClosetTile = {}

function ClosetTile:new(parent, physicsWorld, options)
	local obj = Tile:new(parent, physicsWorld, options)
	obj.type = "closettile"
	obj.hiddenPlayer = nil

	-- Methods
	obj.update = ClosetTile.update
	obj.action_use = ClosetTile.action_use
	obj.toggleHiding = ClosetTile.toggleHiding
	obj.goIntoHiding = ClosetTile.goIntoHiding
	obj.getOutOfHiding = ClosetTile.getOutOfHiding
	obj.handleOpened = ClosetTile.handleOpened
	obj.handleClosed = ClosetTile.handleClosed

	-- Graphics
	obj.graphics:setForeground({key="closet_upper0", offset={0, -2}})
	obj.graphics:setBackground({key="closet_lower0", offset={0, 0}})

	-- Set several floor tiles under the closet
	obj.graphics:set("tile00", {key="floor0", offset={0,0}})
	obj.graphics:set("tile01", {key="floor0", offset={0,1}})

	-- Physics
	obj.physics:setCollidable(true)
	obj.physics:setUseable(true)
	obj.physics:setMainBounds(4, 2, 8, 4)
	obj.physics:init()

	-- Animations
	obj.animationUpper = anim.AnimationBatch:new(obj)
	obj.animationLower = anim.AnimationBatch:new(obj)
	
	obj.animationUpper:newAnim("closed", {"closet_upper0"})
	obj.animationLower:newAnim("closed", {"closet_lower0"})

	obj.animationUpper:newAnim(
		"opening", 
		{"closet_upper0", "closet_upper1", "closet_upper2"},
		{callback=obj.handleOpened})
	obj.animationLower:newAnim(
		"opening",
		{"closet_lower0", "closet_lower1", "closet_lower2"})

	obj.animationUpper:newAnim(
		"closing",
		{"closet_upper2", "closet_upper1", "closet_upper0"},
		{callback=obj.handleClosed})
	obj.animationLower:newAnim(
		"closing",
		{"closet_lower2", "closet_lower1", "closet_lower0"})

	obj.animationUpper:newAnim(
		"hidden",
		{"closet_upper_hiding0", "closet_upper_hiding0", "closet_upper_hiding1",
		 "closet_upper_hiding2", "closet_upper_hiding3", "closet_upper_hiding3",
		 "closet_upper_hiding2", "closet_upper_hiding1"},
		{cycleInterval=5.0})
	obj.animationLower:newAnim(
		"hidden",
		{"closet_lower_hiding0", "closet_lower_hiding0", "closet_lower_hiding1",
		 "closet_lower_hiding2", "closet_lower_hiding3", "closet_lower_hiding3",
		 "closet_lower_hiding2", "closet_lower_hiding1"},
		{cycleInterval=5.0})

	obj.animationUpper:setAnim("closed")
	obj.animationLower:setAnim("closed")

	return obj
end

function ClosetTile:update(dt)
	self.animationUpper:update(dt)
	self.animationLower:update(dt)

	local frameUpper = self.animationUpper:getFrame()
	local frameLower = self.animationLower:getFrame()

	self.graphics:setForeground({key=frameUpper})
	self.graphics:setBackground({key=frameLower})
end

function ClosetTile:action_use(player)
	self.hiddenPlayer = player
	player.physics:setMoveable(false)
	self:toggleHiding()
end

function ClosetTile:toggleHiding()
	local current = self.animationUpper.current
	if current == "closed" then
		self:goIntoHiding()
	elseif current == "hidden" then
		self:getOutOfHiding()
	end
end

function ClosetTile:goIntoHiding()
	local current = self.animationUpper.current
	if current == "closed" then
		self.animationUpper:setAnim("opening")
		self.animationLower:setAnim("opening")
	end
end

function ClosetTile:getOutOfHiding()
	local current = self.animationUpper.current
	if current == "hidden" then
		self.animationUpper:setAnim("opening")
		self.animationLower:setAnim("opening")
	end
end

function ClosetTile:handleOpened()
	if self.hiddenPlayer and self.hiddenPlayer:isHidden() then
		self.hiddenPlayer:setHidden(false)
		self.animationUpper:setAnim("closing")
		self.animationLower:setAnim("closing")
	elseif self.hiddenPlayer and not self.hiddenPlayer:isHidden() then
		self.hiddenPlayer:setHidden(true)
		self.animationUpper:setAnim("closing")
		self.animationLower:setAnim("closing")
	end
end

function ClosetTile:handleClosed()
	if self.hiddenPlayer and self.hiddenPlayer:isHidden() then
		self.animationUpper:setAnim("hidden")
		self.animationLower:setAnim("hidden")
	elseif self.hiddenPlayer and not self.hiddenPlayer:isHidden() then
		self.animationUpper:setAnim("closed")
		self.animationLower:setAnim("closed")
		self.hiddenPlayer = nil
	end
end

return ClosetTile
