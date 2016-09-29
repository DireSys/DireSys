#include "AnimatedSprite.h"

AnimatedSprite::AnimatedSprite(bool shouldLoop)
{
	mLoop = shouldLoop;
}

AnimatedSprite::~AnimatedSprite()
{
	mFrames.clear();
	mFrameDurations.clear();
}

void AnimatedSprite::draw(sf::RenderTarget & target, sf::RenderStates states)
{
	sf::Sprite* currentSprite = getCurrentFrame_();

	// TODO assert sprite exists

	if (currentSprite)
		target.draw(*currentSprite, states);
}

void AnimatedSprite::tick(const sf::Time & elapsedTime)
{
	// TODO assert elapsed time > 0

	mElapsedTime += elapsedTime;

	if (mLoop)
	{
		// Looping: mElapsed mod mTotalTime
		while (mElapsedTime > mTotalTime)
			mElapsedTime -= mTotalTime;

	}
	else
	{
		// Non-looping: cap at end-time
		if (mElapsedTime > mTotalTime)
			mElapsedTime = mTotalTime;
	}
}

void AnimatedSprite::pushFrame(sf::Sprite & frame, const sf::Time & duration)
{
	mFrames.push_back(&frame);
	mFrameDurations.push_back(sf::Time(duration));
}

void AnimatedSprite::clear()
{
	mFrames.clear();
	mFrameDurations.clear();
	mTotalTime = sf::Time();
}

void AnimatedSprite::reset()
{
	mElapsedTime = sf::Time();
}

void AnimatedSprite::setLoop(bool shouldLoop)
{
	mLoop = shouldLoop;
}

bool AnimatedSprite::getLoop()
{
	return mLoop;
}

sf::Sprite* AnimatedSprite::getCurrentFrame_()
{
	size_t frameIndex = 0;
	sf::Time frameStart = sf::Time();

	for (auto frameLength : mFrameDurations)
	{
		if (mElapsedTime > frameStart && mElapsedTime < frameStart + frameLength)
		{
			// Current time on this frame
			return mFrames.at(frameIndex);
		}
		else
		{
			// Current time not on this frame
			frameStart += frameLength;
			frameIndex++;
		}
	}
	
	// TODO shouldn't happen

	return nullptr;
}