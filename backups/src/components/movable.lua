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
    for id, entity in ipairs(entities) do
        if entity and entity.alive and entity.position and entity.position.x == new_pos.x and
        entity.position.y == new_pos.y then
            return id - 1
        end
    end
    return true
end

function Movable:move(dx, dy, map, entities)
    local new_pos = Position(self.position.x + dx, self.position.y + dy)
    if self.movable.can_move(self, new_pos, map, entities) == true then
        self.position = new_pos
        return true
    elseif type(self.movable.can_move(self, new_pos, map, entities)) == "number" then
        local id = self.movable.can_move(self, new_pos, map, entities)
        if game.entities[id + 1].destroyable and self.attacker then
            self.attacker.attack(self, id)
        end
        if game.entities[id + 1].item and self.inventory then
            self.inventory.add(self, id)
        end
        if not game.entities[id + 1].position.blocks then
            self.position = new_pos
        end
        return true
    end
    return false
end

return Movable
