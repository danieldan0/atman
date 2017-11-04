moonshine = require 'lib/moonshine'

function love.load()
  local frag = readAll("assets/shaders/fisheye/fisheye.frag")
  local vert = readAll("assets/shaders/fisheye/fisheye.vert")
  fisheye = moonshine.Effect {
    name = "fisheye",
    shader = love.graphics.newShader(frag, vert)
  }
  effect = moonshine(moonshine.effects.crt)
  .chain(moonshine.effects.scanlines)
  .chain(moonshine.effects.glow)
  .chain(fisheye)
  font = love.graphics.newFont("assets/fonts/Press_Start_2P/PressStart2P-Regular.ttf", 16)
end

function love.draw()
  love.graphics.setFont(font)
  effect(function()
    love.graphics.print({{0, 255, 0, 255}, "Hello world!"}, 200, 200)
    love.graphics.print({{0, 255, 0, 255}, "hmmm..... :Thonk:"}, 200, 216)
    love.graphics.print({{0, 255, 0, 255}, "Привет, мир!"}, 200, 232)
  end)
end

function readAll(file)
  local f = io.open(file, "rb")
  local content = f:read("*all")
  f:close()
  return content
end
