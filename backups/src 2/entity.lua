local class = require 'lib/middleclass'

Entity = class("Entity")

function Entity:initialize(x, y, char, color, name, blocks)
  self.x = x
  self.y = y
  self.char = char
  self.color = color
  self.name = name
  self.blocks = blocks ~= nil and blocks or false
end

function Entity:move(dx, dy)
  self.x = self.x + dx
  self.y = self.y + dy
end

function get_blocking_entities_at_location(entities, x, y)
  for id, entity in pairs(entities) do
    if entity.x == x and entity.y == y and entity.blocks then
      return id
    end
  end
end

return {Entity = Entity, get_blocking_entities_at_location = get_blocking_entities_at_location}
