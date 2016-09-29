#pragma once

#include <SFML/Graphics.hpp>

class AnimatedSprite : public sf::Sprite
{
public:
	AnimatedSprite(bool shouldLoop = false);
	~AnimatedSprite();
	
	virtual void draw(sf::RenderTarget &target, sf::RenderStates states);

	void tick(const sf::Time& elapsedTime);
	void pushFrame(sf::Sprite& frame, const sf::Time& duration);
	
	void clear();
	void reset();

	virtual void setLoop(bool shouldLoop);
	virtual bool getLoop();

private:
	bool mLoop;

	std::vector<sf::Sprite*> mFrames;
	std::vector<sf::Time> mFrameDurations;

	sf::Time mElapsedTime = sf::Time::Zero;
	sf::Time mTotalTime = sf::Time::Zero;

	sf::Sprite* getCurrentFrame_();
};