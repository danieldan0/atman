local Glyph = require 'glyph'

-- Basic tile object
local Tile = Glyph:extend()

function Tile:new(id, char, fg, bg)
    Tile.super.new(self, char, fg, bg)
    self.id = id
end

return Tile