#pragma once
#include <tuple>
#include <iostream>
using namespace std;

#include "SFML/Graphics.hpp"
#include "Box2D.h"

#include "DSConstants.h"

enum class TileType {
	none,
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

typedef pair<float, float> TilePosition;

class Tile {
private:
	int id;
	TileType type = TileType::none;
	LightIntensity light_intensity = LightIntensity::full;
	shared_ptr<b2World> physics_world;
	shared_ptr<b2Body> physics_body;
public:
	Tile(shared_ptr<b2World> physics_world, TilePosition position);
	virtual ~Tile();
	void setType(TileType type);

	virtual void initPhysicsBody(TilePosition position);
	virtual void initPhysicsFixture();

	virtual void draw(shared_ptr<sf::RenderWindow> window,
		int tile_x, int tile_y);
	virtual void draw_shadow(shared_ptr<sf::RenderWindow> window,
		int tile_x, int tile_y);
};