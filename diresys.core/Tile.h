#pragma once

#include <SFML/Graphics.hpp>

class Tile
{
public:
	Tile(sf::Uint16 type = 0,
		 bool isCollidable = false,
		 sf::Uint8 lightIntensity = 0);

	Tile(Tile& copy);

	sf::Uint16 type;
	sf::Uint8 lightIntensity;
	bool isCollidable;
};