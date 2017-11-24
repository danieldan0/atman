local moonshine = require 'lib/moonshine'
local ROT = require 'lib/rotLove/rot'
local utils = require 'utils'
local handle_input = require 'input_handlers'
local render_utils = require 'render_utils'
local Entity, get_blocking_entities_at_location = (require 'entity').Entity, (require 'entity').get_blocking_entities_at_location
local Map = require 'map'
local map_utils = require 'map_utils'
local colors = require 'colors'
local fov_utils = require 'fov_utils'

screen_width = 26
screen_height = 20
map_width = 26
map_height = 15
PLAYER = 1
game = {}

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

  -- Initialiazing game state.
  game = {
    entities = {},
    map = {},
    fov_map = {},
    user_input = {
      keys = {},
      mouseXY = {0, 0},
      tileXY = {0, 0},
      pressed_key = false
    }
  }

  -- Initializing entities
  local player = Entity(math.floor(screen_width / 2), math.floor(screen_height / 2), "@", {255, 255, 255, 255}, "player", true)
  game.entities = {player}

  -- Initializing map
  game.map = map_utils.make_map(map_width, map_height, 2)

  -- Initializing FOV
  fov = ROT.FOV.Recursive:new(fov_utils.light_callback)

  -- Placing player at the free space.
  game.entities[PLAYER].x, game.entities[PLAYER].y = unpack(game.map:find_rand(Tile(true), 1000))
  fov:compute(game.entities[PLAYER].x, game.entities[PLAYER].y, 5, fov_utils.compute_callback)
end

function love.update(dt)
  if game.user_input.pressed_key then
    local action = handle_input(game.user_input)
    local move = action['move']
    local exit = action['exit']
    local fullscreen = action['fullscreen']

    if move then
      local dx, dy = unpack(move)
      local destination_x, destination_y = game.entities[PLAYER].x + dx, game.entities[PLAYER].y + dy
      local tile = game.map:get_tile(destination_x, destination_y)
      if tile and tile.walkable and not get_blocking_entities_at_location(game.entities, destination_x, destination_y) then
        game.entities[PLAYER]:move(dx, dy)
        game.fov_map = {}
        fov:compute(game.entities[PLAYER].x, game.entities[PLAYER].y, 5, fov_utils.compute_callback)
      end
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
  if key == "`" then
    debug.debug()
  end
  game.user_input.keys[key] = true
  game.user_input.pressed_key = true
end

function love.keyreleased(key)
  game.user_input.keys[key] = nil
end

function love.mousemoved(x, y, dx, dy, istouch)
  -- Correcting mouse coordinates.
  game.user_input.mouseXY = utils.fisheye({x, y}, 640, 496, 1.15, 1.06, 1.065)
  game.user_input.tileXY = {math.floor((game.user_input.mouseXY[1] - 12) / 24), math.floor(game.user_input.mouseXY[2] / 24)}
end

function love.draw()
  s_scanlines(function()
    love.graphics.setColor({5, 5, 5, 255})
    love.graphics.rectangle("fill", 0, 0, 640, 480)
  end)

  s_screen(function()
    render_utils.render_all(game.entities, game.map, game.fov_map, colors)
    -- cursors
    love.graphics.setColor({255, 0, 0, 255})
    love.graphics.rectangle("fill", game.user_input.mouseXY[1] - 5, game.user_input.mouseXY[2] - 5, 10, 10)
  end)

  love.graphics.draw(frame, 0, 0)
end
