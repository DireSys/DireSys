#pragma once
#include <string>
#include <tuple>
#include <fstream>
#include <sstream>
#include <streambuf>

using namespace std;

#include "World.h"
#include "Tile.h"
#include "EmptyTile.h"

class WorldGenerator {
private:

public:
	WorldGenerator();
	~WorldGenerator();

	static World* loadFromFile(string filename);
	static pair<int, int> getWorldExtents(string input);
	static World* generateWorld(string input);
};

