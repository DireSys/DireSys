#pragma once
#include <tuple>
using namespace std;

#include "SFML/Graphics.hpp"
#include "Box2D.h"

#include "DSConstants.h"

enum class TileType {
	empty,
	floor,
	wall,
	door,
	closet,
	table,
	vent,
	entrance,
	exit,
};

enum class LightIntensity {
	full,
	dim,
	dark,
	none,
};

class Tile {
private:
	int id;
	TileType type;
	LightIntensity light_intensity;
	b2World* physics_world;
	b2Body* physics_body;
public:
	Tile(b2World* physics_world, pair<float, float> position);
	virtual ~Tile();

	virtual void initPhysicsBody(pair<float, float> position);
	virtual void initPhysicsFixture();

	virtual void draw(sf::RenderWindow* window, int tile_x, int tile_y);
	virtual void draw_shadow(sf::RenderWindow* window, int tile_x, int tile_y);
};