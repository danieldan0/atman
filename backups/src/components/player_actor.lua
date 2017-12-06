PlayerActor = require("class")()
PlayerActor.name = "actor"

function PlayerActor:__init()
    self.name = PlayerActor.name
    return self
end

function PlayerActor:act()
    self.buffs.update(self)
    self.input.input(self, game.user_input, game.map, game.entities)
end

return PlayerActor