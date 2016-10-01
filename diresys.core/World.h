#pragma once
#include <vector>
#include <memory>
#include <algorithm>
#include <cassert>
#include <iostream>
using namespace std;

#include "SFML/Graphics.hpp"
#include "Box2D.h"

#include "Tile.h"
#include "EmptyTile.h"
#include "FloorTile.h"
#include "Actor.h"
#include "Player.h"
#include "Camera.h"
#include "EventManager.h"

class World {
private:
	int width;
	int height;
	vector<Tile*> tile_map; //O
	b2World* physics_world = nullptr; //O
	vector<Actor*> actor_list; //O
	Player* player = nullptr; //R
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

	void setPlayer(Player* player);

	void addActor(int tile_x, int tile_y, Actor* actor);
	void removeActor(Actor* actor);

	void handleEvents();

	Camera* getCamera();
	void positionCamera();
	void draw_actors();
	void draw_tiles();
	void draw_shadows();
	void draw();

	void step();
};

