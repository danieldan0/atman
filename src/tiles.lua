local Tile = require 'tile'

local Tiles = {}
Tiles.void = Tile(1, "", {0, 0, 0, 0}, {0, 0, 0, 0})
Tiles.wall = Tile(2, "#", {127, 127, 127, 255}, {63, 63, 63, 255})

local TileID = {
    Tiles.void,
    Tiles.wall
}

return {Tiles, TileID}