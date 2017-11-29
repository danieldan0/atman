Input = require("../class")()
Input.name = "input"

function Input:__init()
    self.name = Input.name
    return self
end

function Input:input(user_input, map, entities)
    if user_input.keys['up'] then
        self.movable.move(self, 0, -1, map, entities)
    elseif user_input.keys['down'] then
        self.movable.move(self, 0, 1, map, entities)
    elseif user_input.keys['left'] then
        self.movable.move(self, -1, 0, map, entities)
    elseif user_input.keys['right'] then
        self.movable.move(self, 1, 0, map, entities)
    end
end

return Input
