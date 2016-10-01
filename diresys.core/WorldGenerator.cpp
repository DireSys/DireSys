#include "WorldGenerator.h"

WorldGenerator::WorldGenerator(){}
WorldGenerator::~WorldGenerator(){}

unique_ptr<World> WorldGenerator::loadFromFile(string filename) {
	ifstream filehandle(filename);
	string output((istreambuf_iterator<char>(filehandle)),
		istreambuf_iterator<char>());

	auto world = generateWorld(output);
	return move(world);
}

pair<size_t, size_t> WorldGenerator::getWorldExtents(string input) {
	istringstream stream(input);
	string line;

	size_t i = 0;
	size_t j = 0;
	while (getline(stream, line)) {
		i = line.size();
		j++;
	}

	cout << "Width: " << i << endl;
	cout << "Height: " << j << endl;
	return make_pair(i, j);
}

unique_ptr<World> WorldGenerator::generateWorld(string input) {
	istringstream stream(input);
	string line;

	//Generate world based on extents
	auto dims = WorldGenerator::getWorldExtents(input);
	auto width = dims.first;
	auto height = dims.second;
	auto world = make_unique<World>(World(width, height));
	auto physics = world->getPhysicsWorld();

	int j = 0;
	while (getline(stream, line)) {
		for (int i = 0; i < width; i++) {
			auto position = make_pair(i*TILE_SIZE, j*TILE_SIZE);
			char character = line[i];
			if (character == '.') {
				auto tile = make_shared<Tile>(EmptyTile(physics, position));
				//world->setTile(i, j, tile);
			}
			else if (character == '+') {
				auto tile = make_shared<Tile>(FloorTile(physics, position));
				//world->setTile(i, j, tile);
			}
			else if (character == '@') {
				auto player = make_shared<Actor>(Player(physics, position));
				auto tile = make_shared<Tile>(FloorTile(physics, position));
				//world->setTile(i, j, tile);
				//world->addActor(i, j, player);
				//world->setPlayer(static_pointer_cast<Player>(player));
			}
		}
		j++;
	}
	return move(world);
}
