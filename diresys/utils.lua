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

function LINE_SEGMENT_INTERSECTS_BOX( source, target, box )

    local ray_bounds = {
        x = math.min(target.x, source.x),
        y = math.min(target.y, source.y),
        w = math.max(target.x, source.x) - math.min(target.x, source.x),
        h = math.max(target.y, source.y) - math.min(target.y, source.y)
    }

    if not BOUNDS_OVERLAP(ray_bounds, box) then
        return false
    end

    local m = (target.y - source.y) / (target.x - source.x)

    local y0 = m * (box.x - source.x)
    local y1 = m * (box.x + box.w - source.x)

    local s = ((box.y - source.y) >= y0)

    return ((box.y - source.y) >= y1) ~= s or
           ((box.y + box.h - source.y) >= y0) ~= s or
           ((box.y + box.h - source.y) >= y1) ~= s
end

function BOUNDS_OVERLAP ( a, b )
    return a.x       < b.x + b.w and
           a.x + a.w > b.x       and
           a.y       < b.y + b.h and
           a.y + a.h > b.y
end

