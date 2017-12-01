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
        if self.inventory.inv[item.name] then
            game.entities[id + 1].item.on_pickup(id, self.id)
            self.inventory.inv[item.name].item.amount = self.inventory.inv[item.name].item.amount + item.item.amount
        elseif self.inventory.occupied < self.inventory.size then
            game.entities[id + 1].item.on_pickup(id, self.id)
            self.inventory.inv[item.name] = item
            self.inventory.occupied = self.inventory.occupied + 1
        elseif item.item.amount == 0 then
            game.entities[id + 1].item.on_pickup(id, self.id)
        end
    end
end

return Inventory