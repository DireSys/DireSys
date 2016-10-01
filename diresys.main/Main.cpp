#include <SFML/Graphics.hpp>

#include "DireSys.h"
#include "WorldGenerator.h"

int main() {
	auto game = DireSys();
	auto test_map = WorldGenerator::generateWorld("....\n.+@.\n.++.\n....");
	game.addStage(move(test_map));
	game.runGameLoop();

	return 0;
}