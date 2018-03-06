local Object = require 'lib.classic'

local Map = Object:extend()

function Map:new(w, h)
    self.data = {}
    self.width = w
    self.height = h
    for i = 1, self.width * self.height do
        self.data[i] = 1
    end
end

function Map:set(x, y, v)
    self.data[self.width * y + x + 1] = v
end

function Map:get(x, y)
    return self.data[self.width * y + x + 1]
end

function Map:foreach(x, y, w, h, func)
    for i = x, x + w - 1 do
        for j = y, y + h - 1 do
            self:set(i, j, func(i, j, self:get(i, j)))
        end
    end
end

return Map