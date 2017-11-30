Inventory = require("class")()
Inventory.name = "inventory"

function Inventory:__init()
    self.name = Inventory.name
    return self
end

function Inventory:act()
    self.input.input(self, game.user_input, game.map, game.entities)
end

return Inventory