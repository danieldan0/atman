local ROT = require "lib/rotLove/rot"
local Map = require "map"
local Tile = require "tile"

Mapgen = {}
local Tiles = {[0] = Tile.floor, [1] = Tile.wall, [2] = Tile.floor}

function Mapgen.generate(w, h)
    local map = Map(w, h)
    local mapgen = ROT.Map.Brogue(w, h)
    local function callback(x, y, v)
      map:set(x, y, Tiles[v])
    end
    mapgen:create(callback, true)
    return map
end

return Mapgen