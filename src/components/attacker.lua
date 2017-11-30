Attacker = require("class")()
Attacker.name = "attacker"

function Attacker:__init(dmg)
    self.dmg = dmg
    return self
end

function Attacker:attack(id)
    if game.entities[id] and game.entities[id].alive and game.entities[id].destroyable then
        game.entities[id].destroyable.take_damage(game.entities[id], self.attacker.dmg)
    end
end

return Attacker