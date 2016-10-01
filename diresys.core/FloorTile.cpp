#include "FloorTile.h"

FloorTile::FloorTile(shared_ptr<b2World> physics_world, TilePosition position) :
	Tile(physics_world, position) {
	this->setType(TileType::floor);
}
