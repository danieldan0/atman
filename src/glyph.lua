local Object = require 'lib.classic'

local Glyph = Object:extend()

function Glyph:new(char, fg, bg)
    self.char = char
    self.fg = fg
    self.bg = bg
end

function Glyph:draw(x, y)
    love.graphics.setColor(self.bg)
    love.graphics.rectangle("fill", x, y, 24, 24)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print({self.fg, self.char}, x, y)
end

return Glyph