#pragma once
#include "Tile.h"
class FloorTile : public Tile {
public:
	FloorTile(b2World * physics_world, pair<float, float> position);
	~FloorTile();
};

