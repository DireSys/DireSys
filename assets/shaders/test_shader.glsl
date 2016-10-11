/*
  Prototype Shader for Shadows on tiles
 */
#include <debug>

// Parameters
parameter ivec2 viewport = ivec2(0, 0) : range(ivec2(-16, -16), ivec2(16, 16));
parameter ivec2 lightSource = ivec2(255, 255) : range(ivec2(0, 0), ivec2(512, 512));
parameter ivec2 blockLocation = ivec2(8, 8) : range(ivec2(0, 0), ivec2(31, 31));

// Light Parameters
parameter float lightMaxDistance = 32.0 : range(0.0, 512.0);
parameter float lightMinFalloff = 16.0 : range(0.0, 512.0);

// Window Size
const int TILE_SIZE = 16;
const int WINDOW_WIDTH = 512;
const int WINDOW_HEIGHT = 512;

// Greyscale values
const vec4 BLACK = vec4(0, 0, 0, 255);
const vec4 DARK = vec4(100, 100, 100, 255);
const vec4 GREY = vec4(200, 200, 200, 255);
const vec4 WHITE = vec4(255, 255, 255, 255);

glsl vec4 toFloatColor(in vec4 c) {
    return c/255.0;
}

glsl vec4 shadows(vec2 position) {
    vec2 pixelPosition = ivec2(floor(WINDOW_WIDTH * position.x),
			       floor(WINDOW_HEIGHT * position.y));

    vec2 tilePosition = ivec2(pixelPosition.x / TILE_SIZE,
			      pixelPosition.y / TILE_SIZE);

    // tiles are defined by the top-left corner
    if (tilePosition.x == blockLocation.x && tilePosition.y == blockLocation.y) {
	return toFloatColor(BLACK);
    }

    // start working with shadows
    float lightDistance = distance(lightSource, pixelPosition);
    if (lightDistance < lightMaxDistance) {
	return toFloatColor(GREY);
    }

    return toFloatColor(WHITE);
}

glsl vec4 dither(vec4 x) {
    return vec4(0, 0, 0, 0);
}

image MyImage = glsl(shadows, WINDOW_WIDTH, WINDOW_HEIGHT);
