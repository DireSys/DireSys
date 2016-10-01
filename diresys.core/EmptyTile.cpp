#include "EmptyTile.h"



EmptyTile::EmptyTile(shared_ptr<b2World> physics_world, TilePosition position) : 
	Tile(physics_world, position) {
	this->setType(TileType::empty);
}

EmptyTile::~EmptyTile() {
	Tile::~Tile();
}
