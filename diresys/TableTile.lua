--[[
	Table Tile
]]
config = require "config"
class = require "diresys/class"
f = require "diresys/func"
Tile = require "diresys/Tile"

local TableTile = class.create(Tile)

function TableTile:new(parent, physicsWorld, options)
	local obj = Tile.new(self, parent, physicsWorld, options)
	obj.type = "tabletile"

	-- Graphics
	obj.graphics:setForeground({key="table_upper0", offset={0, -1}})
	obj.graphics:setBackground({key="table_lower0", offset={0, 0}})

	-- Set several floor tiles under the table
	obj.graphics:set("tile00", {key="floor0", offset={0,0}})
	obj.graphics:set("tile01", {key="floor0", offset={0,1}})
	obj.graphics:set("tile10", {key="floor0", offset={1,0}})
	obj.graphics:set("tile11", {key="floor0", offset={1,1}})
	obj.graphics:set("tile20", {key="floor0", offset={2,0}})
	obj.graphics:set("tile21", {key="floor0", offset={2,1}})

	-- Physics
	obj.physics:setCollidable(true)
	--obj.physics:setUseable(true)
	obj.physics:setMainBounds(6, 4, 12, 8)

	return obj
end

function TableTile:update(dt)

end

function TableTile:action_use()
	
end

return TableTile
