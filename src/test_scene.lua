local Scene = require 'scene'

local TestScene = Scene:extend()

function TestScene:new()
end

function TestScene:draw()
    love.graphics.rectangle("fill", 100, 100, 100, 100)
end

return TestScene