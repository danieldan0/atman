Listener = require("class")()
Listener.name = "listener"

function Listener:__init(func)
    self.name = Listener.name
    self.func = func
    return self
end

function Listener:listen(other, msg, ...)
    if self.listener.func then
        self.listener.func(self, other, msg, ...)
    end
    if self.log then
        self.log.add(self, msg.message, msg.color or {255, 255, 255, 255})
    end
end

return Listener