#pragma once

#include <vector>
#include <memory>

#include <SFML/Graphics.hpp>

#include "Tile.h"
#include "TileMap.h"
#include "Actor.h"
#include "Box2D.h"

using namespace std;

class World {
public:
	World(size_t width, size_t height);
	~World();

	// Map
	const Tile& getTile(size_t x, size_t y);
	void setTile(size_t x, size_t y, const Tile& tile);

	// Actors
	void addActor(Actor* actor);
	void removeActor(Actor* actor);

	// Lights
	//void addLightSource(LightSource* light);
	//void removeLightSource(LightSource* light);

	void render(sf::RenderTarget& target, sf::RenderStates& states);
	void update(const sf::Time& timestep);
	void handleEvent(void* event);

protected:

	void drawBackground();
	void drawMap();
	void drawActors();
	void drawLighting();

	void computeMap();
	void computeLightingMask();

private:

	// Static map
	// ... tile set
	TileMap* mTileMap;
	// ... computed texture

	// World objects
	// ... objects

	// Lights
	// ... objects
	// ... computed light mask

	// Collisions
	// ...
	b2World mB2World;

	// Camera
	// ...
};

