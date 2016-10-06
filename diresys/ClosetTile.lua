--[[
	Closet Tile
]]
config = require "config"
f = require "diresys/func"
Tile = require "diresys/Tile"

local ClosetTile = {}

function ClosetTile:new(parent, physicsWorld, options)
	local obj = Tile:new(parent, physicsWorld, options)
	obj.type = "closettile"

	-- Methods
	obj.update = ClosetTile.update
	obj.action_use = ClosetTile.action_use

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

	return obj
end

function ClosetTile:update(dt)

end

function ClosetTile:action_use()
	
end

return ClosetTile
