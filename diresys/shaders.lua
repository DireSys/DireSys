local shaders = {}

shaders.test_0 = love.graphics.newShader[[
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
        vec4 pixel;
        pixel.r = 0.5;
        pixel.g = color.g;
        pixel.b = 0.5;
        return pixel;
    }
]]

shaders.test_radial_shader_centered = love.graphics.newShader[[
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){

        vec2 origin = vec2(love_ScreenSize.x/2, love_ScreenSize.y/2);
        vec2 position = screen_coords - origin;

        number radius_inner2 = 8 * 8;
        number radius_outer2 = 64 * 64;

        number dist2 = position.x * position.x + position.y * position.y;

        number intensity = 0;

        if (dist2 < radius_inner2)
            intensity = 1;
        else if (dist2 > radius_inner2 && dist2 < radius_outer2)
            intensity = 1.0 - (dist2 - radius_inner2) / (radius_outer2 - radius_inner2);

        vec4 pixel = Texel(texture, texture_coords);
        pixel.r = color.r * intensity;
        pixel.g = color.g * intensity;
        pixel.b = color.b * intensity;
        return pixel;
    }
]]

shaders.test_radial_shader_centered_2 = love.graphics.newShader[[
    extern number scale;

    extern number light_falloff = 16;
    extern number light_limit = 256;

    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){

        vec2 origin = vec2(love_ScreenSize.x/2, love_ScreenSize.y/2);
        vec2 light_offset = screen_coords - origin;

        light_offset /= scale * scale;
        light_offset = floor(light_offset);
        light_offset *= scale * scale;

        number radius_inner2 = light_falloff * light_falloff;
        number radius_outer2 = light_limit * light_limit;

        number dist2 = light_offset.x * light_offset.x
                       + light_offset.y * light_offset.y;

        number intensity = 0;

        if (dist2 <= radius_inner2)
            intensity = 1;
        else if (dist2 > radius_inner2 && dist2 <= radius_outer2)
            intensity = 1.0 - (dist2 - radius_inner2) / (radius_outer2 - radius_inner2);

        intensity = ceil(15 * intensity) / 15;

        vec4 pixel = Texel(texture, texture_coords);
        pixel.r = color.r * intensity;
        pixel.g = color.g * intensity;
        pixel.b = color.b * intensity;
        return pixel;
    }
]]

shaders.test_radial_shader_fixed = love.graphics.newShader[[
    extern number scale;
    extern vec2 light_origin;
    extern vec2 viewport_world_offset;

    extern number light_falloff = 16;
    extern number light_limit = 256;

    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){

        vec2 light_offset = screen_coords + viewport_world_offset - light_origin;

        light_offset /= scale * scale;
        light_offset = floor(light_offset);
        light_offset *= scale * scale;

        number radius_inner2 = light_falloff * light_falloff;
        number radius_outer2 = light_limit * light_limit;

        number dist2 = light_offset.x * light_offset.x
                       + light_offset.y * light_offset.y;

        number intensity = 0;

        if (dist2 <= radius_inner2)
            intensity = 1;
        else if (dist2 > radius_inner2 && dist2 <= radius_outer2)
            intensity = 1.0 - (dist2 - radius_inner2) / (radius_outer2 - radius_inner2);

        intensity = ceil(15 * intensity) / 15;

        vec4 pixel = Texel(texture, texture_coords);
        pixel.r = color.r * intensity;
        pixel.g = color.g * intensity;
        pixel.b = color.b * intensity;
        return pixel;
    }
]]

shaders.render_light = love.graphics.newShader[[
    extern number scale;
    extern vec2 viewport_offset;

    extern vec2 light_position;
    extern int obstruction_count = 0;
    extern vec4 obstruction_bounds[64];

    extern number light_falloff = 16;
    extern number light_limit = 256;

    /*
        Naive check that "point" is inside "bounds"

        "bounds" represents two points in the order <x0, y0, x1, y1> such that
        x0 > x1 and y0 > y1.
    */
    bool point_in_bounds ( vec2 point, vec4 bounds )
    {
        return point.x >= bounds.x
               && point.y >= bounds.y
               && point.x <= bounds.z
               && point.y <= bounds.w;
    }

    /*
        Naive check that a and b overlap.

        "a" and "b" each represent two points having the order <x0, y0, x1, y1>
        such that x0 > x1 and y0 > y1.
    */
    bool bounds_overlap( vec4 a, vec4 b )
    {
        return point_in_bounds(a.xy, b) ||
               point_in_bounds(a.zw, b) ||
               point_in_bounds(a.xz, b) ||
               point_in_bounds(a.yw, b) ||
               point_in_bounds(b.xy, a) ||
               point_in_bounds(b.zw, a) ||
               point_in_bounds(b.xz, a) ||
               point_in_bounds(b.yw, a);
    }

    /*
        Test whether line intersects box.

        'source' and 'target' define the line segment (target - source).
        First, the box needs to overlap the bounds defined by the line segment.
        Next, each point of the box needs to be on the same side of the line
        segment -- otherwise, the line segment intersects the box at some point.
    */
    bool line_intersects_box( vec2 source, vec2 target, vec4 box )
    {
        // Compute the "bounds" of the line segment
        vec4 ray_bounds = vec4(min(target.x, source.x),
                               min(target.y, source.y),
                               max(target.x, source.x),
                               max(target.y, source.y));

        // Compute the "bounds" of the box
        vec4 box_bounds = vec4(box.x,
                               box.y,
                               box.x + box.z,
                               box.y + box.w);

        // 1. the box needs to overlap the bounds defined by the line segment
        if (!bounds_overlap(ray_bounds, box_bounds))
            return false;

        // 2. the corners of the box need to be on the same side of the line

        // 2a. find the y values of the line at the x values of the box
        number m = (target.y - source.y) / (target.x - source.x);

        number y0 = m * (box_bounds.x - source.x);
        number y1 = m * (box_bounds.z - source.x);

        // 2b. compare the y values of the box to those of the line segment.
        //     They must all be on the same side of the line.
        bool s = ((box_bounds.y - source.y) >= y0);

        return ((box_bounds.y - source.y) >= y1) != s ||
               ((box_bounds.w - source.y) >= y0) != s ||
               ((box_bounds.w - source.y) >= y1) != s;
    }

    /*
        Computes light intensity given pixel and light (world) positions.
    */
    number calculate_intensity( vec2 light_position, vec2 pixel_position ) {

        vec2 position = pixel_position - light_position;

        position /= scale * scale;
        position = floor(position);
        position *= scale * scale;

        number intensity = 0;

        number radius_inner2 = light_falloff * light_falloff;
        number radius_outer2 = light_limit * light_limit;

        number dist2 = position.x * position.x
                       + position.y * position.y;

        if (dist2 <= radius_inner2)
            intensity = 1;
        else if (dist2 > radius_inner2 && dist2 <= radius_outer2)
            intensity = 1.0 - (dist2 - radius_inner2) / (radius_outer2 - radius_inner2);

        intensity = ceil(15 * intensity) / 15;
        
        return intensity;
    }

    /*
        Pixel shader entry point.
    */
    vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ) {

        // Calculate pixel position
        vec2 pixel_position = screen_coords + viewport_offset;

        // Calculate blockedness
        bool blocked = false;

        for (int o = 0; o < obstruction_count; o++) {
            vec4 box = obstruction_bounds[o];

            if (line_intersects_box(light_position, pixel_position, box)) {
                blocked = true;
                break;
            }
        }

        // Calculate intensity
        number intensity;
        
        if (!blocked) {
            intensity = calculate_intensity(light_position, pixel_position);
        }
        else {
            intensity = 0; // TODO "blocked" intensity ?
        }

        // Apply intensity to current pixel
        vec4 pixel = Texel(texture, texture_coords);
        pixel.r = color.r * intensity;
        pixel.g = color.g * intensity;
        pixel.b = color.b * intensity;

        return pixel;
    }
]]


return shaders
