local moonshine = require 'lib/moonshine'
local utils = require 'utils'
local handle_input = require 'input_handlers'
local render_utils = require 'render_utils'
local Entity = require 'entity'
local Map = require 'map'

screen_width = 26
screen_height = 20
map_width = 26
map_height = 15
PLAYER = 1

function love.load()
  -- Loading shaders
  s_scanlines = moonshine(moonshine.effects.scanlines)
  .chain(moonshine.effects.crt)
  s_scanlines.scanlines.thickness = 0.5
  s_scanlines.crt.scaleFactor = {1.15, 1.15}

  s_screen = moonshine(moonshine.effects.scanlines)
  .chain(moonshine.effects.glow)
  .chain(moonshine.effects.crt)
  s_screen.scanlines.thickness = 0.5
  s_screen.crt.scaleFactor = {1.15, 1.15}

  -- Loading font
  font = love.graphics.newFont("assets/fonts/Press_Start_2P/PressStart2P-Regular.ttf", 24)
  love.graphics.setFont(font)

  -- Loading images
  frame = love.graphics.newImage("assets/images/screen-frame.png")

  -- Initializing entities
  local player = Entity(math.floor(screen_width / 2), math.floor(screen_height / 2), "@", {255, 255, 255, 255})
  local npc = Entity(math.floor(screen_width / 2 - 5), math.floor(screen_height / 2), "@", {255, 255, 0, 255})
  local entities = {player, npc}

  -- Initialiazing game state.
  game = {
    entities = entities,
    map = Map(map_width, map_height),
    user_input = {
      keys = {},
      mouseXY = {0, 0},
      tileXY = {0, 0},
      pressed_key = false
    }
  }
end

function love.update(dt)
  if game.user_input.pressed_key then
    local action = handle_input(game.user_input)
    local move = action['move']
    local exit = action['exit']
    local fullscreen = action['fullscreen']

    if move then
      local dx, dy = unpack(move)
      game.entities[PLAYER]:move(dx, dy)
    end

    if exit then
      love.event.quit()
    end

    -- fullscreen is ugly

    -- if fullscreen then
    --   love.window.setFullscreen(not love.window.getFullscreen(), "exclusive")
    -- end

    game.user_input.pressed_key = false
  end
end

function love.keypressed(key)
  game.user_input.keys[key] = true
  game.user_input.pressed_key = true
end

function love.keyreleased(key)
  game.user_input.keys[key] = nil
end

function love.mousemoved(x, y, dx, dy, istouch)
  -- Correcting mouse coordinates.
  game.user_input.mouseXY = utils.fisheye({x, y}, 640, 496, 1.15, 1.06, 1.065)
  game.user_input.tileXY = {math.floor(game.user_input.mouseXY[1] / 24), math.floor(game.user_input.mouseXY[2] / 24)}
end

function love.draw()
  s_scanlines(function()
    love.graphics.setColor({5, 5, 5, 255})
    love.graphics.rectangle("fill", 0, 0, 640, 480)
  end)

  s_screen(function()
    render_utils.render_all(game.entities)
    -- cursors
    love.graphics.setColor({255, 0, 0, 255})
    love.graphics.rectangle("fill", game.user_input.mouseXY[1] - 5, game.user_input.mouseXY[2] - 5, 10, 10)
  end)

  love.graphics.draw(frame, 0, 0)
end
