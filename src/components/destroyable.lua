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

local function blink(id, start)
    local color = game.entities[id+1].drawable.fg_color
    repeat
        game.entities[id+1].drawable.fg_color = {0, 0, 0, 0} 
        love.timer.sleep(1/4) 
        game.entities[id+1].drawable.fg_color = color;
    until (love.timer.getTime() - start) > 2
end

function Destroyable:take_damage(dmg)
    self.destroyable.hp = math.max(0, self.destroyable.hp - dmg)
    if self.effects then
        self.effects.blink(self, 2)
    end
    if self.destroyable.hp == 0 then
        self:die()
    end
end

return Destroyable