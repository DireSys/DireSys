#include <SFML/Graphics.hpp>

#include "DireSys.h"

int main()
{
	sf::RenderWindow window(sf::VideoMode(160, 144), APP_NAME);
	sf::CircleShape shape(60.f);
	shape.setFillColor(sf::Color::Green);

	while (window.isOpen())
	{
		sf::Event event;
		while (window.pollEvent(event))
		{
			if (event.type == sf::Event::Closed)
				window.close();
		}

		window.clear();
		window.draw(shape);
		window.display();
	}

	return 0;
}