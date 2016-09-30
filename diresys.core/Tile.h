#pragma once
#include "SFML/Graphics.hpp"
#include "Box2D.h"

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

b2BodyDef tile_createBodyDefinition(b2World* world);
b2FixtureDef tile_createFixtureDefinition(b2Body* body);

class Tile {
private:
	int id;
	TileType type;
	LightIntensity light_intensity;
	b2World* physics_world;
	b2Body* physics_body;
public:
	Tile(b2World* physics_world);
	virtual ~Tile();

	virtual void draw(sf::RenderWindow* window, int tile_x, int tile_y);
	virtual void draw_shadow(sf::RenderWindow* window, int tile_x, int tile_y);
};