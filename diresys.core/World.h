#pragma once
#include <vector>
#include <memory>
using namespace std;

#include "Tile.h"
#include "Actor.h"
#include "Box2D.h"

class World {
private:
	int width;
	int height;
	vector<unique_ptr<Tile>> map;
	b2World box_world;
public:
	World(int width, int height);
	~World();

	void setTile(int tile_x, int tile_y, unique_ptr<Tile> tile);
	unique_ptr<Tile> getTile(int tile_x, int tile_y);
	void addActor(int tile_x, int tile_y, unique_ptr<Actor> actor);
	void removeActor(unique_ptr<Actor> actor);
	void clearMap();

	void draw();
	void draw_actors();
	void draw_tiles();
	void draw_shadows();
};

