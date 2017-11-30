Destroyable = require("class")()
Destroyable.name = "destroyable"

function Destroyable:__init(hp, max_hp)
    self.hp = hp
    if max_hp then
        self.max_hp = max_hp
    else
        self.max_hp = hp
    end
    return self
end

function Destroyable:take_damage(dmg)
    self.destroyable.hp = math.max(0, self.destroyable.hp - dmg)
    if self.destroyable.hp == 0 then
        self:die()
    end
end

return Destroyable