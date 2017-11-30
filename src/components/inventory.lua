Inventory = require("class")()
Inventory.name = "inventory"

function Inventory:__init(size)
    self.size = size
    self.occupied = 0
    self.inv = {}
    return self
end

function Inventory:add(id)
    local item = game.entities[id + 1]
    if item and item.alive and item.item then
        game.entities[id + 1].die(game.entities[id + 1])
        if self.inventory.inv[item.name] then
            self.inventory.inv[item.name].item.amount = self.inventory.inv[item.name].item.amount + item.item.amount
        elseif self.inventory.occupied < self.inventory.size then
            self.inventory.inv[item.name] = item
            self.inventory.occupied = self.inventory.occupied + 1
        end
    end
end

return Inventory