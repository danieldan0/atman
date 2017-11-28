local moonshine = require 'lib/moonshine'
local utils = require 'utils'
local render = require 'render'
local Map = require 'map'
local Tile = require 'tile'
local Entity = require 'entity'
local Position = require 'components/position'
local Movable = require 'components/movable'
local Drawable = require 'components/drawable'
local Input = require 'components/input'

-- Game state.
-- Global, because I can't make pointers or something in Lua.
-- Or I could do it in the other way?
game = {
    map = Map(100, 100),
    user_input = {
        -- Corrected mouse coords
        mouseXY = {0, 0},
        -- Position of a tile under cursor
        tileXY = {0, 0},
        -- Pressed keys
        keys = {},
        -- Was key pressed?
        pressed_key = false
    }
}
game.map:set(0, 0, Tile.floor)
game.map:set(0, 1, Tile.floor)
game.map:set(1, 0, Tile.floor)
game.map:set(1, 1, Tile.floor)
game.map:set(3, 4, Tile.wall)
game.map:set(5, 4, Tile.wall)
game.map:set(3, 6, Tile.wall)
game.map:set(5, 6, Tile.wall)
player = Entity {
    Position(0, 0),
    Movable(),
    Drawable("@", {255, 255, 255, 255}, {0, 0, 0, 255}),
    Input()
}

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

function love.update(dt)
    if game.user_input.pressed_key then
        player.input.input(player, game.user_input, game.map)
        game.user_input.pressed_key = false
    end
end

function love.keypressed(key)
    if key == "`" then
        debug.debug()
    end
    game.user_input.keys[key] = true
    game.user_input.pressed_key = true
end
  
function love.keyreleased(key)
    game.user_input.keys[key] = nil
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
        render.render_all(player.position.x, player.position.y, 26, 20, game.map, {player})
        -- Rendering a cursor.
        love.graphics.setColor({255, 0, 0, 255})
        love.graphics.rectangle("fill", game.user_input.mouseXY[1] - 5, game.user_input.mouseXY[2] - 5, 10, 10)
    end)

    -- Drawing a screen frame.
    love.graphics.draw(frame, 0, 0)
end