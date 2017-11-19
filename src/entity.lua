local class = require 'lib/middleclass'

Entity = class("Entity")

function Entity:initialize(x, y, char, color)
  self.x = x
  self.y = y
  self.char = char
  self.color = color
end

function Entity:move(dx, dy)
  print(self.x * self.y)
  self.x = self.x + dx
  self.y = self.y + dy
end

return Entity
