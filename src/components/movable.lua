local Position = require "components/position"
Movable = require("class")()
Movable.name = "movable"

function Movable:__init()
    self.name = Movable.name
    return self
end

function Movable:move(dx, dy, map)
    local new_pos = self.position:add(Position(dx, dy))
    if map:get(new_pos.x, new_pos.y) and (not map:get(new_pos.x, new_pos.y).blocked) then
        self.position = new_pos
        return true
    end
    return false
end

return Movable
