local ROT = require "lib/rotLove/rot"
Attacker = require("class")()
Attacker.name = "attacker"

function Attacker:__init(dmg)
    self.dmg = dmg
    return self
end

function Attacker:attack(id)
    if game.entities[id] and game.entities[id].alive and game.entities[id].destroyable then
        local dmg = self.attacker.dmg + ROT.RNG:random(-2, 2)
        if self.sender then
            self.sender.send(self, id, self.name .." attacks you! -".. dmg .." HP", {255, 0, 0, 255})
        end
        if self.log then
            self.log.add(self, "You attack ".. game.entities[id].name .."! ".. dmg .." DMG", {255, 255, 0, 255})
        end
        game.entities[id].destroyable.take_damage(game.entities[id], dmg)
    end
end

return Attacker