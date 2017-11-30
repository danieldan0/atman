PlayerActor = require("class")()
PlayerActor.name = "actor"

function PlayerActor:__init()
    self.name = PlayerActor.name
    return self
end

function PlayerActor:act()
    self.input.input(self, game.user_input, game.map, game.entities)
end

return PlayerActor