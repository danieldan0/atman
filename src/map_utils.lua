local ROT = require 'lib/rotLove/rot'
local Map = require 'map'
local Tile = require 'tile'

map_utils = {}

function map_utils.make_map(w, h)
  map = Map:new(w, h)
  local mapgen = ROT.Map.Brogue(26, 20)
  local function callback(x, y, v)
    map:set_tile(x, y, Tile(v == 0))
  end
  mapgen:create(callback, true)
  return map
end

return map_utils
