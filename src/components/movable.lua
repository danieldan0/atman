local Position = require "components/position"
Movable = require("class")()
Movable.name = "movable"

function Movable:__init()
    self.name = Movable.name
    return self
end

function Movable:can_move(new_pos, map, entities)
    if not map:get(new_pos.x, new_pos.y) then
        return false
    end
    if map:get(new_pos.x, new_pos.y).blocked then
        return false
    end
    for id, entity in pairs(entities) do
        if entity and entity.position and entity.position.x == new_pos.x and
        entity.position.y == new_pos.y and entity.position.blocks then
            return false
        end
    end
    return true
end

function Movable:move(dx, dy, map, entities)
    local new_pos = Position(self.position.x + dx, self.position.y + dy)
    if self.movable.can_move(self, new_pos, map, entities) then
        self.position = new_pos
        return true
    end
    return false
end

return Movable
