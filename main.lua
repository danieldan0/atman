moonshine = require 'lib/moonshine'

function love.load()
  s_scanlines = moonshine(moonshine.effects.scanlines)
  .chain(moonshine.effects.crt)
  s_scanlines.scanlines.thickness = 0.5
  s_scanlines.crt.scaleFactor = {1.15, 1.15}

  s_screen = moonshine(moonshine.effects.glow)
  .chain(moonshine.effects.scanlines)
  .chain(moonshine.effects.crt)
  s_screen.scanlines.thickness = 0.5
  s_screen.crt.scaleFactor = {1.15, 1.15}

  font = love.graphics.newFont("assets/fonts/Press_Start_2P/PressStart2P-Regular.ttf", 24)
  frame = love.graphics.newImage("assets/images/screen-frame.png")
  mouseXY = {0, 0}
  rectXY = {320 - 50, 240 - 50}
  dragged = false
  delta = {0, 0}
  intersection_canvas = love.graphics.newCanvas(640, 496)
end

function love.update(dt)
end

function love.mousepressed(x, y, button, istouch)
  if button == 1 and inArea(mouseXY[1], mouseXY[2], rectXY[1], rectXY[2], 100, 100) then
    dragged = true
    delta = {math.abs(mouseXY[1] - rectXY[1]), math.abs(mouseXY[2] - rectXY[2])}
    rectXY = {mouseXY[1] - delta[1], mouseXY[2] - delta[2]}
  end
end

function love.mousemoved(x, y, dx, dy, istouch)
  -- Correcting mouse coordinates.
  mouseXY = fisheye({x, y}, 640, 496, 1.15, 1.06, 1.065)
  if dragged then
    rectXY = {mouseXY[1] - delta[1], mouseXY[2] - delta[2]}
  end
end

function love.mousereleased(x, y, button, istouch)
  if button == 1 then
    dragged = false
    delta = {0, 0}
  end
end

function love.draw()
  love.graphics.setFont(font)

  love.graphics.setCanvas(intersection_canvas)
      love.graphics.clear()
      love.graphics.setBlendMode("add")
      love.graphics.setColor({127, 127, 127, 255})
      love.graphics.rectangle("fill", 540, 380, 100, 100)
      love.graphics.rectangle("fill", rectXY[1], rectXY[2], 100, 100, 10, 10)
      love.graphics.setBlendMode("subtract")
      love.graphics.rectangle("fill", 0, 0, 640, 496)
  love.graphics.setCanvas()

  love.graphics.setColor({255, 255, 255, 255})
  love.graphics.setBlendMode("alpha")

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

    love.graphics.setColor({0, 255, 255, 255})
    love.graphics.rectangle("fill", 540, 380, 100, 100)
    -- buttons
    love.graphics.setColor({255, 255, 0, 255})
    love.graphics.rectangle("line", rectXY[1], rectXY[2], 100, 100, 10, 10)
    if inArea(mouseXY[1], mouseXY[2], rectXY[1], rectXY[2], 100, 100) then
      love.graphics.rectangle("fill", rectXY[1], rectXY[2], 100, 100, 10, 10)
      love.graphics.setColor({255, 255, 127, 255})
      if dragged then
        love.graphics.rectangle("fill", rectXY[1], rectXY[2], 100, 100, 10, 10)
      end
    end
    love.graphics.setBlendMode("alpha", "premultiplied")
    love.graphics.setColor({255, 255, 255, 255})
    love.graphics.draw(intersection_canvas, 0, 0)
    love.graphics.setBlendMode("alpha")
    -- cursors
    love.graphics.setColor({255, 0, 0, 255})
    love.graphics.rectangle("fill", mouseXY[1] - 5, mouseXY[2] - 5, 10, 10)
    -- test
    love.graphics.setColor({255, 0, 0, 255})
    local gx, gy = math.floor(mouseXY[1] / 24) * 24, math.floor(mouseXY[2] / 24) * 24
    love.graphics.rectangle('fill', gx, gy, 24, 24)
    if love.keyboard.isDown("z") then
        print(gx..";"..gy)
    end
    -- set font size to 480
    -- love.graphics.printf({{0, 255, 0, 255}, "@"}, 320-240+25, 288-240+100, 500, "center")
  end)

  love.graphics.draw(frame, 0, 0)
end

function readAll(file)
  local f = io.open(file, "rb")
  local content = f:read("*all")
  f:close()
  return content
end

function inArea(x, y, area_x, area_y, area_w, area_h)
  return (((x >= area_x) and (x <= area_x + area_w)) and ((y >= area_y) and (y <= area_y + area_h)))
end

function fisheye(vec, w, h, scale, distortX, distortY)
  result = {vec[1] / w, vec[2] / h}
  result = {result[1] * 2.0 - 1.0, result[2] * 2.0 - 1.0}
  result = {result[1] * scale, result[2] * scale}
  result = {result[1] + (result[2] * result[2] * result[1] * (distortX - 1)),
             result[2] + (result[1] * result[1] * result[2] * (distortY - 1))}
  result = {(result[1] + 1.0) / 2.0, (result[2] + 1.0) / 2.0}
  result = {result[1] * w, result[2] * h}
  return result
end
