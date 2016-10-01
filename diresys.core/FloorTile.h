#pragma once
#include "Tile.h"
class FloorTile : public Tile {
public:
	FloorTile(shared_ptr<b2World> physics_world, TilePosition position);
	~FloorTile() { Tile::~Tile(); };
};

