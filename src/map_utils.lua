local ROT = require 'lib/rotLove/rot'
local Map = require 'map'
local Tile = require 'tile'
local Entity = (require 'entity').Entity

map_utils = {}

function map_utils.make_map(w, h, monsters_per_room)
  local map = Map:new(w, h)
  local mapgen = ROT.Map.Brogue(26, 20)
  local function callback(x, y, v)
    map:set_tile(x, y, Tile(v == 0))
  end
  mapgen:create(callback, true)
  local rooms = mapgen:getRooms()
  for _, room in pairs(rooms) do
    local monsters = 0
    while monsters < monsters_per_room do
      local x, y = ROT.RNG:random(room:getLeft(), room:getRight()), ROT.RNG:random(room:getRight(), room:getBottom())
      local occupied = false
      for _, entity in ipairs(game.entities) do
        if x == entity.x and y == entity.y then
          occupied = true
          break
        end
      end
      if map:get_tile(x, y) ~= Tile() and (not occupied) then
        table.insert(game.entities, Entity(x, y, "?", {ROT.RNG:random(0, 255), ROT.RNG:random(0, 255), ROT.RNG:random(0, 255), 255}, "???", true))
        monsters = monsters + 1
      end
    end
  end
  return map
end

return map_utils
