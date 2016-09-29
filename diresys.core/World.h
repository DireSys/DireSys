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
	vector<Tile*> map;
	b2World box_world;
	vector<Actor*> actor_list;
public:
	World(int width, int height);
	~World();

	void setTile(int tile_x, int tile_y, const Tile* tile);
	const Tile* getTile(int tile_x, int tile_y);
	void addActor(int tile_x, int tile_y, const Actor* actor);
	void removeActor(const Actor* actor);
	void clearMap();

	void draw();
	void draw_actors();
	void draw_tiles();
	void draw_shadows();
};

