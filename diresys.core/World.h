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
	vector<shared_ptr<Tile> > tile_map; //O
	shared_ptr<b2World> physics_world = nullptr; //O
	vector<shared_ptr<Actor> > actor_list; //O
	shared_ptr<Player> player = nullptr; //R
	shared_ptr<Camera> camera = nullptr; //O
	shared_ptr<sf::RenderWindow> window; //R
public:
	World(int width, int height);
	~World();

	shared_ptr<b2World> getPhysicsWorld();
	void setWindow(shared_ptr<sf::RenderWindow> window);
	
	void setTile(int tile_x, int tile_y, shared_ptr<Tile> tile);
	shared_ptr<Tile> getTile(int tile_x, int tile_y);

	void clearMap();

	void setPlayer(shared_ptr<Player> player);

	void addActor(int tile_x, int tile_y, shared_ptr<Actor> actor);
	void removeActor(shared_ptr<Actor> actor);

	void handleEvents();

	shared_ptr<Camera> getCamera();
	void positionCamera();
	void draw_actors();
	void draw_tiles();
	void draw_shadows();
	void draw();

	void step();
};

