local ROT = require "lib/rotLove/rot"
local Position = require "components/position"
BossActor = require("class")()
BossActor.name = "actor"
local dirs = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}}
local id = 0
local path = {}

function BossActor:__init()
    self.name = BossActor.name
    return self
end

local function passable_callback(x, y)
    local can_move = game.entities[id].movable.can_move(game.entities[id],
    Position(x, y), game.map, game.entities)
    return can_move
end

local function astar_callback(x, y)
    table.insert(path, Position(x, y))
end

function BossActor:act()
    self.buffs.update(self)
    local dest = game.entities[PLAYER_ID].position
    if self.position:dist(dest) > 10 then
        id = self.id
        local astar = ROT.Path.AStar(dest.x, dest.y, passable_callback, {topology = 4})
        path = {}
        astar:compute(self.position.x, self.position.y, astar_callback)
        self.position = path[2] or self.position
    else
        local dx, dy = unpack(dirs[ROT.RNG:random(1, 4)])
        self.movable.move(self, dx, dy, game.map, game.entities)
    end
end

return BossActor