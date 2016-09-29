#pragma once
enum class TileType {
	empty,
	floor,
	wall,
	door,
	closet,
	table,
	vent,
	entrance,
	exit,
};

enum class LightIntensity {
	full,
	dim1,
	dim0,
	dark,
};

class Tile {
public:
	Tile();
	virtual ~Tile();

private:
	int id;
	TileType type;
	LightIntensity light_intensity;
	bool bcollidable = false;
};

