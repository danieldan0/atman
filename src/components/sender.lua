Sender = require("class")()
Sender.name = "sender"

function Sender:__init()
    self.name = Sender.name
    return self
end

function Sender:send(id, message, color, ...)
    if game.entities[id + 1] and game.entities[id + 1].alive and game.entities[id + 1].listener then
        game.entities[id + 1].listener.listen(game.entities[id + 1], self.id, {message = message, color = color}, ...)
    end
end

function Sender:send_all(message, color, ...)
    for id, entity in game.entities do
        self.sender.send(self, id - 1, {message = message, color = color}, ...)
    end
end

function Sender:send_area(x, y, dist, message, color, ...)
    for id, entity in game.entities do
        if entity and entity.position and entity.position.x >= x - dist and entity.position.x <= x + dist
        and entity.position.y >= y - dist and entity.position.y <= y + dist then
            self.sender.send(self, id - 1, {message = message, color = color}, ...)
        end
    end
end

return Sender