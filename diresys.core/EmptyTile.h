#pragma once
#include "Tile.h"

class EmptyTile : public Tile {
public:
	EmptyTile(b2World* world);
	~EmptyTile();
};
