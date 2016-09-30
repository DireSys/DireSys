#pragma once
#include <vector>
#include <memory>
#include <algorithm>
#include <cassert>
using namespace std;

#include "SFML/Graphics.hpp"
#include "Box2D.h"

#include "Tile.h"
#include "EmptyTile.h"
#include "Actor.h"
#include "Camera.h"
#include "EventManager.h"

class World {
private:
	int width;
	int height;
	vector<Tile*> tile_map; //O
	b2World* physics_world = nullptr; //O
	vector<Actor*> actor_list; //O
	Actor* player = nullptr; //R
	Camera* camera = nullptr; //O
	sf::RenderWindow* window; //R
public:
	World(int width, int height);
	~World();

	b2World* getPhysicsWorld();
	void setWindow(sf::RenderWindow* window);
	
	void setTile(int tile_x, int tile_y, Tile* tile);
	Tile* getTile(int tile_x, int tile_y);
	void clearMap();

	void setPlayer(Actor* player);

	void addActor(Actor* actor);
	void removeActor(Actor* actor);

	void handleEvents();

	void positionCamera();
	void draw_actors();
	void draw_tiles();
	void draw_shadows();
	void draw();

	void step();
};

