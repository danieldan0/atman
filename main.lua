moonshine = require 'lib/moonshine'

function love.load()
  s_screen = moonshine(moonshine.effects.glow)
  .chain(moonshine.effects.scanlines)
  s_screen.scanlines.thickness = 0.5

  s_scanlines = moonshine(moonshine.effects.scanlines)

  s_crt = moonshine(moonshine.effects.crt)
  s_crt.crt.scaleFactor = {1.15, 1.15}

  font = love.graphics.newFont("assets/fonts/Press_Start_2P/PressStart2P-Regular.ttf", 24)
  frame = love.graphics.newImage("assets/images/screen-frame.png")
  screen = love.graphics.newCanvas(640, 480)
  canvas = love.graphics.newCanvas(656, 496)
end

function love.draw()
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.setFont(font)
  love.graphics.setCanvas(screen)
    s_scanlines(function()
      love.graphics.setColor({5, 5, 5, 255})
      love.graphics.rectangle("fill", 0, 0, 640, 480)
    end)
    s_screen(function()
      love.graphics.print({{0, 255, 0, 255}, "Hello world!!!!!!!!!!!!!!!!!"}, 0, 0)
      love.graphics.print({{0, 255, 0, 255}, "hmmm..... :Thonk:"}, 0, 24)
      love.graphics.print({{0, 255, 0, 255}, "Привет, мир!"}, 0, 456)
      love.graphics.print({{0, 255, 0, 255}, "???"}, 0, 240)
      love.graphics.rectangle("fill", 540, 380, 100, 100)
    end)
  love.graphics.setCanvas(canvas)
    s_crt(function()
      love.graphics.setBlendMode("alpha", "premultiplied")
      love.graphics.draw(screen, 0, 16)
    end)
  love.graphics.setCanvas()
  love.graphics.setBlendMode("alpha", "premultiplied")
  love.graphics.draw(canvas)
  love.graphics.setBlendMode("alpha")
  love.graphics.draw(frame, 0, 0)
end

function readAll(file)
  local f = io.open(file, "rb")
  local content = f:read("*all")
  f:close()
  return content
end
