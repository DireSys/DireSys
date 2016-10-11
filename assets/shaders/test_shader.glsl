const vec4 ORANGE = vec4(1.0, 0.5, 0.0, 1.0);
const vec4 TRANSPARENT = vec4(1.0, 1.0, 1.0, 0.0);

glsl vec4 myShader(vec2 position) {
    float d = distance(position, vec2(0.5, 0.5));
    if (d < 0.4) {
	return ORANGE;
    }
    else {
	return TRANSPARENT;
    }
}

image MyImage = glsl(myShader, 256, 256);
