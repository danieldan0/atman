Item = require("class")()
Item.name = "item"

function Item:__init()
    self.name = Item.name
    return self
end

function Item:act()
    self.input.input(self, game.user_input, game.map, game.entities)
end

return Item