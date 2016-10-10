--[[
	List of utility functions
]]
config = require("config")

function TILE_UNIT(x)
	return math.floor(x / config.TILE_SIZE)
end

function WORLD_UNIT(x)
	return math.floor(x * config.TILE_SIZE)
end

function _I(x, y)
	-- Represents a unique index between two coordinates
	return x .. "," .. y
end

function IFF(cond, t, f)

    if cond then
        return t
    else
        return f
    end

end

function LINE_SEGMENT_INTERSECTS_BOX(a, b, c, h, w)

    -- a and b make up line segment
    -- c is top-left position of box
    -- h and w are the height and width of the box
    local epsilon = 0.001

    -- Trivial cases
    if math.abs(a.x - b.x) < epsilon then
        -- trivial case: vertical line
        -- check x bounds on box
        return c.x < a.x and c.x + w > a.x and (c.y > math.min(a.y, b.y) or c.y + h < math.max(a.y, b.y))
    elseif math.abs(a.y - b.y) < epsilon then
        -- trivial case: horizontal line
        -- check y bounds on box
        return c.y < a.y and c.y + h > a.y and (c.x > math.min(a.x, b.x) or c.x + w < math.max(a.x, b.x))
    end

    -- Make sure box is partially overlapping line segment bounds
    if c.x < math.min(a.x, b.x) or
       c.x + w > math.max(a.x, b.x) or
       c.y < math.min(a.y, b.y) or
       c.y + h > math.max(a.y, b.y)
    then
        return false -- box not in bounds of line segment
    end

    -- non-trivial case: sloped line
    -- check that all corners are on the same side of line

    local m = (b.y - a.y) / (b.x - a.x)

    -- y values of line at x values of box
    local y0 = m * (c.x - a.x) 
    local y1 = m * (c.x + w - a.x)

    local sideOfFirstPoint = ((c.y - a.y) > y0)

    if (c.y - a.y) > y1 ~= sideOfFirstPoint or
       (c.y + h - a.y) > y0 ~= sideOfFirstPoint or
       (c.y + h - a.y) > y1 ~= sideOfFirstPoint
    then
        return true -- one point is not on the same side of the line as the others 
    end

    return false -- all points in box are on the same side of the line

end
