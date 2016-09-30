#pragma once

#include "Tile.h"

class TileMap
{
public:

	TileMap(size_t width, size_t height)
	{
		mHeight = height;
		mWidth = width;
		mMap = new Tile[height * width];
	}

	~TileMap()
	{
		delete mMap;
	}

	size_t getHeight() const
	{
		return mHeight;
	}

	size_t getWidth() const
	{
		return mWidth;
	}

	size_t index(size_t x, size_t y) const
	{
		return x + mWidth * y;
	}

	Tile* operator [](size_t i) const
	{
		return &mMap[i];
	}

	Tile* operator ()(size_t x, size_t y) const
	{
		return &mMap[index(x, y)];
	}

private:
	size_t mWidth;
	size_t mHeight;
	Tile* mMap;
};