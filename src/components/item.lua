Item = require("class")()
Item.name = "item"

function Item:__init(amount)
    self.name = Item.name
    self.amount = amount
    return self
end

return Item