local Scene = require 'scene'
local Map = require 'map'
local Tiles, TileID = unpack(require('tiles'))

local TestScene = Scene:extend()

function TestScene:new()
    self.map = Map(100, 100)
    self.map:set(2, 2, Tiles.wall.id)
end

local function render_tile(x, y, v)
    TileID[v]:draw(x * 24, y * 24)
    return v
end

function TestScene:draw()
    self.map:foreach(0, 0, 100, 100, render_tile)
end

return TestScene