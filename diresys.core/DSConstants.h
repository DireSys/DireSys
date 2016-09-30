#pragma once

#define APP_NAME "DireSys"

// Window Properties
#define WINDOW_WIDTH 160
#define WINDOW_HEIGHT 144
constexpr float WINDOW_ASPECT() {
	return (WINDOW_WIDTH / WINDOW_HEIGHT);
}

// Box2D Properties
#define PHYSICS_SCALE 16

// Scale to fit within box2d physics constraints
constexpr float SCALE_OUT() {
	return PHYSICS_SCALE;
}
constexpr float SCALE_IN() {
	return 1.0f / PHYSICS_SCALE;
}

#define TIME_STEP (1.0f / 60.0f)
#define VELOCITY_ITERATIONS 8
#define POSITION_ITERATIONS 3