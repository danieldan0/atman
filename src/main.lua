local moonshine = require 'lib/moonshine'
local utils = require 'utils'
local handle_input = require 'input_handlers'

function love.load()
  -- Loading shaders
  s_scanlines = moonshine(moonshine.effects.scanlines)
  .chain(moonshine.effects.crt)
  s_scanlines.scanlines.thickness = 0.5
  s_scanlines.crt.scaleFactor = {1.15, 1.15}

  s_screen = moonshine(moonshine.effects.glow)
  .chain(moonshine.effects.scanlines)
  .chain(moonshine.effects.crt)
  s_screen.scanlines.thickness = 0.5
  s_screen.crt.scaleFactor = {1.15, 1.15}

  -- Loading font
  font = love.graphics.newFont("assets/fonts/Press_Start_2P/PressStart2P-Regular.ttf", 24)
  love.graphics.setFont(font)

  -- Loading images
  frame = love.graphics.newImage("assets/images/screen-frame.png")

  -- Initialiazing game state.
  game = {
    playerXY = {0, 0},
    user_input = {
      keys = {},
      mouseXY = {0, 0},
      tileXY = {0, 0},
      pressed_key = false
    }
  }
  action = {}
end

function love.update(dt)
  if game.user_input.pressed_key then
    action = handle_input(game.user_input)
    move = action['move']
    exit = action['exit']
    fullscreen = action['fullscreen']

    if move then
      dx, dy = unpack(move)
      game.playerXY = {game.playerXY[1] + dx, game.playerXY[2] + dy}
    end

    if exit then
      love.event.quit()
    end

    if fullscreen then
      love.window.setFullscreen(not love.window.getFullscreen(), "exclusive")
    end

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
    drawChar("@", game.playerXY[1], game.playerXY[2], {255, 0, 0, 255}, {0, 255, 0, 255})
    if game.user_input.tileXY[1] == game.playerXY[1] and game.user_input.tileXY[2] == game.playerXY[2] then
      drawChar("@", game.playerXY[1], game.playerXY[2], {255, 127, 127, 255}, {127, 255, 127, 255})
    end
    -- cursors
    love.graphics.setColor({255, 0, 0, 255})
    love.graphics.rectangle("fill", game.user_input.mouseXY[1] - 5, game.user_input.mouseXY[2] - 5, 10, 10)
  end)

  love.graphics.draw(frame, 0, 0)
end

function drawChar(char, x, y, color, bg)
  love.graphics.setColor(bg)
  love.graphics.rectangle('fill', x * 24, y * 24, 24, 24)
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.print(char, x * 24 - 1, y * 24 + 7)
  love.graphics.print(char, x * 24 - 1, y * 24 + 9)
  love.graphics.print(char, x * 24 + 1, y * 24 + 7)
  love.graphics.print(char, x * 24 + 1, y * 24 + 9)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print({color, char}, x * 24, y * 24 + 8)
end
