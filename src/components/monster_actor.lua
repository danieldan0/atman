local ROT = require "lib/rotLove/rot"
MonsterActor = require("class")()
MonsterActor.name = "actor"
local dirs = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}}

function MonsterActor:__init()
    self.name = MonsterActor.name
    return self
end

function MonsterActor:act()
    self.buffs.update(self)
    local dx, dy = unpack(dirs[ROT.RNG:random(1, 4)])
    self.movable.move(self, dx, dy, game.map, game.entities)
end

return MonsterActor