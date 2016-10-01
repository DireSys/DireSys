#include "EmptyTile.h"



EmptyTile::EmptyTile(b2World* physics_world, pair<float, float> position) : 
	Tile(physics_world, position) {

}

EmptyTile::~EmptyTile() {
	Tile::~Tile();
}
