Buffs = require("class")()
Buffs.name = "buffs"

function Buffs:__init()
    self.name = Buffs.name
    self.active = {}
    self.time = 0
    return self
end

function Buffs:update()
    if self.buffs.active.poison then
        if self.buffs.time - self.buffs.active.poison.start >= self.buffs.active.poison.duration then
            self.buffs.active.poison = nil
            self.effects.fx.poison = nil
        else
            self.destroyable.take_damage(self, self.buffs.active.poison.damage)
        end
    end
end

function Buffs:poison(damage, duration)
    self.buffs.active.poison = {}
    self.buffs.active.poison.start = self.buffs.time
    self.buffs.active.poison.damage = damage
    self.buffs.active.poison.duration = duration or 5
    self.effects.poison(self, 0)
end

return Buffs