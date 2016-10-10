test = require "test/test"
utils = require "diresys/func"

local test_utils = {}

test_utils.test_LINE_SEGMENT_INTERSECTS_BOX = function()

    -- Obvious case

    local line1 = {
        a = {x = -10, y = -10},
        b = {x = 10, y = 10}
    }

    local line2 = {
        a = {x = 10, y = 10},
        b = {x = -10, y = -10}
    }

    local line3 = {
        a = {x = -10, y = 10},
        b = {x = 10, y = -10}
    }

    local line4 = {
        a = {x = 10, y = -10},
        b = {x = -10, y = 10}
    }

    local line5 = {
        a = {x = 0, y = -10},
        b = {x = 0, y = 10}
    }

    local line6 = {
        a = {x = -10, y = 0},
        b = {x = 10, y = 0}
    }

    local box1 = {
        c = {x = -1, y = -1},
        h = 2,
        w = 2
    }
    
    local box2 = {
        c = {x = -20, y = -20},
        h = 2,
        w = 2
    }

    local box3 = {
        c = {x = -1, y = -10},
        h = 2,
        w = 2
    }

    -- Intersecting box

    test.assert(LINE_SEGMENT_INTERSECTS_BOX(line1.a, line1.b, box1.c, box1.h, box1.w) == true, "Line segment should intersect box.")

    test.assert(LINE_SEGMENT_INTERSECTS_BOX(line2.a, line2.b, box1.c, box1.h, box1.w) == true, "Line segment should intersect box.")

    test.assert(LINE_SEGMENT_INTERSECTS_BOX(line3.a, line3.b, box1.c, box1.h, box1.w) == true, "Line segment should intersect box.")

    test.assert(LINE_SEGMENT_INTERSECTS_BOX(line4.a, line4.b, box1.c, box1.h, box1.w) == true, "Line segment should intersect box.")

    -- Horizontal line

    test.assert(LINE_SEGMENT_INTERSECTS_BOX(line5.a, line5.b, box1.c, box1.h, box1.w) == true, "Horizontal line segment should intersect box.")

    -- Vertical line

    test.assert(LINE_SEGMENT_INTERSECTS_BOX(line6.a, line6.b, box1.c, box1.h, box1.w) == true, "Vertical line segment should intersect box.")

    -- Box out of bounds of line segment

    test.assert(LINE_SEGMENT_INTERSECTS_BOX(line1.a, line1.b, box2.c, box2.h, box2.w) == false, "Line segment should not intersect box which is outside bounds of line segnment.")

    -- Box completely above line segment (in bounds)

    test.assert(LINE_SEGMENT_INTERSECTS_BOX(line1.a, line1.b, box3.c, box3.h, box3.w) == false, "Line segment should not intersect box which is above line segnment.")


end

return test_utils
