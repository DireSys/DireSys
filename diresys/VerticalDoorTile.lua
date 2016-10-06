--[[
	A Vertical Door Tile
]]
config = require "config"
f = require "diresys/func"
Tile = require "diresys/Tile"

local VerticalDoorTile = {}

function VerticalDoorTile:new(parent, physics_world, options)
	local obj = Tile:new(parent, physics_world, options)
	obj.type = "doortile"

	-- Graphics
	obj.graphics:setForeground({key="vdoor_upper0"})
	obj.graphics:setBackground({key="vdoor_lower0", offset={0, 2}})

	-- Physics
	obj.physics:setCollidable(true)
	obj.physics:setUseable(true)
	obj.physics:init()

	obj.update = VerticalDoorTile.update
	obj.action_use = VerticalDoorTile.action_use

	return obj
end

function VerticalDoorTile:update(dt)
	-- nothing here yet
end

function VerticalDoorTile:action_use()
	-- nothing here yet
end

return VerticalDoorTile
