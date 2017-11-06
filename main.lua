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
  mouseXY = {0, 0}
end

function love.update(dt)
  mouseXY = {love.mouse.getX() / 640, love.mouse.getY() / 496}
  mouseXY = {mouseXY[1] * 2.0 - 1.0, mouseXY[2] * 2.0 - 1.0}
  mouseXY = {mouseXY[1] * 1.15, mouseXY[2] * 1.15}
  mouseXY = {mouseXY[1] + (mouseXY[2] * mouseXY[2] * mouseXY[1] * 0.06),
             mouseXY[2] + (mouseXY[1] * mouseXY[1] * mouseXY[2] * 0.065)}
  mouseXY = {(mouseXY[1] + 1.0) / 2.0, (mouseXY[2] + 1.0) / 2.0}
  mouseXY = {mouseXY[1] * 640, mouseXY[2] * 496 - 16}
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
      love.graphics.print({{0, 255, 0, 255}, "Greetings."}, 0, 0)
      love.graphics.print({{0, 255, 0, 255}, "You have been selected to"}, 0, 24)
      love.graphics.print({{0, 255, 0, 255}, "go on a roguelike mission."}, 0, 48)
      love.graphics.print({{0, 255, 0, 255}, "Привет, мир!"}, 0, 456)
      love.graphics.print({{0, 255, 0, 255}, "???"}, 0, 240)
      love.graphics.rectangle("fill", 540, 380, 100, 100)
      -- buttons
      love.graphics.setColor({255, 255, 0, 255})
      love.graphics.rectangle("line", 320-50, 240-50, 100, 100, 10)
      if inArea(mouseXY[1], mouseXY[2], 320-50, 240-50, 100, 100) then
        love.graphics.rectangle("fill", 320-50, 240-50, 100, 100, 10)
      end
      love.graphics.setColor({0, 255, 255, 255})
      love.graphics.rectangle("line", 320+50, 240+50, 100, 100, 10)
      if inArea(love.mouse.getX(), love.mouse.getY(), 320+50, 240+50, 100, 100) then
        love.graphics.rectangle("fill", 320+50, 240+50, 100, 100, 10)
      end
      -- cursors
      love.graphics.setColor({255, 0, 0, 255})
      love.graphics.rectangle("fill", mouseXY[1] - 5, mouseXY[2] - 5, 10, 10)
      love.graphics.setColor({0, 0, 255, 255})
      love.graphics.rectangle("fill", love.mouse.getX() - 5, love.mouse.getY() - 5, 10, 10)
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

function inArea(x, y, area_x, area_y, area_w, area_h)
  return x >= area_x and x <= area_x + area_w and y >= area_y and y <= area_y + area_h
end
