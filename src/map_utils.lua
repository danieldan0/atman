local Map = require 'map'
local Tile = require 'tile'

map_utils = {}

function map_utils.make_map(w, h)
  map = Map:new(w, h)
  map.set_all(Tile(true))
  map.set(2, 3, Tile())
  map.set(3, 3, Tile())
  map.set(4, 3, Tile())
  return map
end

return map_utils
