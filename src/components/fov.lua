local ROT = require 'lib/rotLove/rot'
FOV = require("class")()
FOV.name = "fov"

local _id = 0

function FOV:__init(r)
    self.name = FOV.name
    self._fov = ROT.FOV.Recursive:new(FOV.light_callback)
    self.r = r
    self.map = {}
    self.memory = {}
    return self
end

function FOV.light_callback(fov, x, y)
    return game.map:get(x, y) and (not game.map:get(x, y).block_sight)
end
  
function FOV.compute_callback(x, y, r, v)
    game.entities[_id].fov.map[x..";"..y] = v
end

function FOV:update()
    _id = self.id
    self.fov.map = {}
    self.fov._fov:compute(self.position.x, self.position.y, self.fov.r, FOV.compute_callback)
end

return FOV