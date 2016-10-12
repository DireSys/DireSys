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

    local bounds = {
        xmin = math.min(a.x, b.x),
        xmax = math.max(a.x, b.x),
        ymin = math.min(a.y, b.y),
        ymax = math.max(a.y, b.y),
    }

    local box = {
        x0 = c.x,
        x1 = c.x + w,
        y0 = c.y,
        y1 = c.y + h,
    }

    -- Trivial cases
    if a.x == b.x then
        -- trivial case: vertical line
        -- check x bounds on box
        return (box.x0 < a.x and box.x1 > a.x) and                 -- a.x is between x0 and x1 and
               ((box.y0 > bounds.ymin and box.y0 < bounds.ymax) or -- y0 or y1 is in bounds
                (box.y1 > bounds.ymin and box.y1 < bounds.ymax))
    elseif a.y == b.y then
        -- trivial case: horizontal line
        -- check y bounds on box
        return (box.y0 < a.y and box.y1 > a.y) and                 -- a.y is between y0 and y1 and
               ((box.x0 > bounds.xmin and box.x0 < bounds.xmax) or -- x0 or x1 is in bounds
                (box.x1 > bounds.xmin and box.x1 < bounds.xmax))
    end

    -- Make sure box is partially overlapping line segment bounds
    if ((box.x0 > bounds.xmin and box.x0 < bounds.xmax) or (box.x1 > bounds.xmin and box.x1 < bounds.xmax)) and -- one vertical edge is in bounds and
       ((box.y0 > bounds.ymin and box.y0 < bounds.ymax) or (box.y1 > bounds.ymin and box.y1 < bounds.ymax))     -- one horizontal edge is in bounds
    then
        -- pass: in bounds
    else
        return false -- box not in bounds of line segment
    end

    -- non-trivial case: sloped line
    -- check that all corners are on the same side of line
    -- make all points relative to "a" because that makes b = 0 in y = mx + b

    local m = (b.y - a.y) / (b.x - a.x)

    -- y values of line at x values of box
    local y0 = m * (box.x0 - a.x) 
    local y1 = m * (box.x1 - a.x)

    local sideOfFirstPoint = ((c.y - a.y) > y0)

    if (box.y0 - a.y) > y1 ~= sideOfFirstPoint or
       (box.y1 - a.y) > y0 ~= sideOfFirstPoint or
       (box.y1 - a.y) > y1 ~= sideOfFirstPoint
    then
        return true -- one point is not on the same side of the line as the others 
    end

    return false -- all points in box are on the same side of the line

end
