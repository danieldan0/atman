local moonshine = require 'lib/moonshine'
local utils = require 'utils'
local render = require 'render'
local Map = require 'map'
local Tile = require 'tile'
local Entity = require 'entity'

-- Game state.
-- Global, because I can't make pointers or something in Lua.
-- Or I could do it in the other way?
game = {
    map = Map(100, 100),
    user_input = {
        -- Corrected mouse coords
        mouseXY = {0, 0},
        -- Position of a tile under cursor
        tileXY = {0, 0}
    }
}
game.map:set(3, 4, Tile.wall)
game.map:set(5, 4, Tile.wall)
game.map:set(3, 6, Tile.wall)
game.map:set(5, 6, Tile.wall)

-- Loading assets
function love.load()
    -- Loading shaders
    -- Just scanlines and crt, used for the screen "texture".
    s_scanlines = moonshine(moonshine.effects.scanlines)
    .chain(moonshine.effects.crt)
    s_scanlines.scanlines.thickness = 0.5
    s_scanlines.crt.scaleFactor = {1.15, 1.15}

    -- Glowing screen, used for actual drawing.
    -- Use this for rendering characters and stuff.
    s_screen = moonshine(moonshine.effects.scanlines)
    .chain(moonshine.effects.glow)
    .chain(moonshine.effects.crt)
    s_screen.scanlines.thickness = 0.5
    s_screen.crt.scaleFactor = {1.15, 1.15}

    -- Loading font.
    font = love.graphics.newFont("assets/fonts/Press_Start_2P/PressStart2P-Regular.ttf", 24)
    love.graphics.setFont(font)

    -- Loading screen frame image.
    frame = love.graphics.newImage("assets/images/screen-frame.png")

    -- Hiding cursor.
    love.mouse.setVisible(false)
end

-- Correcting mouse position.
function love.mousemoved(x, y, dx, dy, istouch)
    -- Correcting mouse coordinates.
    game.user_input.mouseXY = utils.fisheye({x, y}, 640, 496, 1.15, 1.06, 1.065)
    game.user_input.tileXY = {math.floor((game.user_input.mouseXY[1] - 12) / 24), math.floor(game.user_input.mouseXY[2] / 24)}
end

-- Rendering stuff
function love.draw()
    -- Drawing black scanlines background.
    s_scanlines(function()
        love.graphics.setColor({5, 5, 5, 255})
        love.graphics.rectangle("fill", 0, 0, 640, 480)
    end)

    -- Drawing all other stuff.
    s_screen(function()
        render.render_all(game.user_input.tileXY[1], game.user_input.tileXY[2], 26, 20, game.map)
        -- Rendering a cursor.
        love.graphics.setColor({255, 0, 0, 255})
        love.graphics.rectangle("fill", game.user_input.mouseXY[1] - 5, game.user_input.mouseXY[2] - 5, 10, 10)
    end)

    -- Drawing a screen frame.
    love.graphics.draw(frame, 0, 0)
end