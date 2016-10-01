#pragma once
#include "Tile.h"

class EmptyTile : public Tile {
public:
	EmptyTile(shared_ptr<b2World> world, TilePosition position);
	~EmptyTile();
};

