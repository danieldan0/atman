local class = require "lib/middleclass"

Tile = class("Tile")

function Tile:initialize(walkable, transparent)
  if walkable ~= nil then
    self.walkable = walkable
  else
    self.walkable = false
  end

  if transparent ~= nil then
    self.transparent = transparent
  else
    self.transparent = self.walkable
  end
end

function Tile:__eq(other)
  return self.walkable == other.walkable and self.transparent == other.transparent
end

return Tile
