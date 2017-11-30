Tile = {}


Tile.void = {
	["name"] = "Void",
	["char"] = " ",
	["color"] = {0, 0, 0, 255},
	["blocked"] = true,
	["block_sight"] = false
}

Tile.floor = {
	["name"] = "Floor",
	["char"] = ".",
	["color"] = {50, 50, 150, 255},
	["blocked"] = false,
	["block_sight"] = false
}

Tile.wall = {
	["name"] = "Wall",
	["char"] = "#",
	["color"] = {0, 0, 100, 255},
	["blocked"] = true,
	["block_sight"] = true
}

return Tile