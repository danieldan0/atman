local Scene = require 'scene'
local Map = require 'map'
local Tiles, TileID = unpack(require('tiles'))
local Entity = require 'entity'

local TestScene = Scene:extend()

function TestScene:new()
    self.map = Map(100, 100)
    self.map:set(20, 20, Tiles.wall.id)
    local entity = Entity({component = {name = "component"}})
    print(entity.component.name)
    entity.component.name = "???"
    print(entity.component.name)
    entity:die()
    print(entity.alive)
end

local function render_tile(x, y, v)
    TileID[v]:draw(x * 24, y * 24)
    return v
end

function TestScene:draw()
    self.map:foreach(0, 0, 100, 100, render_tile)
end

return TestScene