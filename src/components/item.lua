Item = require("class")()
Item.name = "item"

function Item:__init(amount, on_pickup)
    self.name = Item.name
    self.amount = amount
    self.on_pickup = on_pickup or function(self_id, other) game.entities[self_id]:die() end
    return self
end

return Item