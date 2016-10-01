#include "FloorTile.h"



FloorTile::FloorTile(b2World* physics_world, pair<float, float> position) :
	Tile(physics_world, position) {
}


FloorTile::~FloorTile() {
	Tile::~Tile();
}
