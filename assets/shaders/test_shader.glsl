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

// Other Constants
const float EPSILON = 2.0;

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

glsl vec2 TO_TILE(vec2 pixelPosition) {
    return vec2(floor(pixelPosition.x / TILE_SIZE),
		floor(pixelPosition.y / TILE_SIZE));
}

glsl vec2 TO_WORLD(vec2 tilePosition) {
    return vec2(floor(tilePosition.x * TILE_SIZE),
		floor(tilePosition.y * TILE_SIZE));
}

// Block Boundary Functions
glsl vec2 tile_getTopLeft(vec2 pixelPosition) {
    vec2 tilePosition = TO_TILE(pixelPosition);
    tilePosition.y += 1;
    return TO_WORLD(tilePosition);
}

glsl vec2 tile_getTopRight(vec2 pixelPosition) {
    vec2 tilePosition = TO_TILE(pixelPosition);
    tilePosition.x += 1;
    tilePosition.y += 1;
    return TO_WORLD(tilePosition);
}

glsl vec2 tile_getBottomLeft(vec2 pixelPosition) {
    vec2 tilePosition = TO_TILE(pixelPosition);
    return TO_WORLD(tilePosition);
}

glsl vec2 tile_getBottomRight(vec2 pixelPosition) {
    vec2 tilePosition = TO_TILE(pixelPosition);
    tilePosition.x += 1;
    return TO_WORLD(tilePosition);
}

glsl float getLightDistance(vec2 pixelPosition) {
    return distance(lightSource, pixelPosition);
}

glsl float getMaxLightDistance(vec2 pixelPosition) {
    return max(0,
	       max(getLightDistance(tile_getBottomLeft(pixelPosition)),
		   max(getLightDistance(tile_getBottomRight(pixelPosition)),
		       max(getLightDistance(tile_getTopLeft(pixelPosition)),
			   getLightDistance(tile_getTopRight(pixelPosition))))));
}

glsl float getMinLightDistance(vec2 pixelPosition) {
    return min(getLightDistance(tile_getBottomLeft(pixelPosition)),
	       min(getLightDistance(tile_getBottomRight(pixelPosition)),
		   min(getLightDistance(tile_getTopLeft(pixelPosition)),
		       getLightDistance(tile_getTopRight(pixelPosition)))));
}

glsl bool isInRange(vec2 pixelPosition) {
    float lightDistance = getLightDistance(pixelPosition);
    return lightDistance < lightMaxDistance;
}



glsl vec4 getLightIntensity(vec2 pixelPosition) {
    float lightDistance = getMinLightDistance(pixelPosition);
    if (lightDistance < lightMinFalloff) {
	return toFloatColor(WHITE);
    }
    else {
	return toFloatColor(GREY);
    }
}

glsl vec4 setShadowCast(vec2 pixelPosition) {
    if (getMaxLightDistance(pixelPosition) < lightMaxDistance) {
	return getLightIntensity(pixelPosition);
    }
    return toFloatColor(BLACK);
}

glsl vec4 shadows(vec2 position) {
    vec2 pixelPosition = vec2(floor(WINDOW_WIDTH * position.x),
			      floor(WINDOW_HEIGHT * position.y));

    vec2 tilePosition = TO_TILE(pixelPosition);

    // tiles are defined by the bottom-left corner
    if (tilePosition == blockLocation) {
	return toFloatColor(BLACK);
    }

    return setShadowCast(pixelPosition);
}

glsl vec4 dither(vec4 x) {
    return vec4(0, 0, 0, 0);
}

image MyImage = glsl(shadows, WINDOW_WIDTH, WINDOW_HEIGHT);
