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
  tileXY = {0, 0}
  playerXY = {0, 0}
end

function love.update(dt)
end

function love.keypressed(key)
  if key == "z" then
    print(tileXY[1]..";"..tileXY[2])
  end

  if key == "up" then
    playerXY = {playerXY[1], playerXY[2] - 1}
  elseif key == "down" then
    playerXY = {playerXY[1], playerXY[2] + 1}
  elseif key == "left" then
    playerXY = {playerXY[1] - 1, playerXY[2]}
  elseif key == "right" then
    playerXY = {playerXY[1] + 1, playerXY[2]}
  end
end

function love.mousemoved(x, y, dx, dy, istouch)
  -- Correcting mouse coordinates.
  mouseXY = fisheye({x, y}, 640, 496, 1.15, 1.06, 1.065)
  tileXY = {math.floor(mouseXY[1] / 24), math.floor(mouseXY[2] / 24)}
end

function love.draw()
  love.graphics.setFont(font)

  s_scanlines(function()
    love.graphics.setColor({5, 5, 5, 255})
    love.graphics.rectangle("fill", 0, 0, 640, 480)
  end)

  s_screen(function()
    drawChar("@", playerXY[1], playerXY[2], {255, 0, 0, 255}, {0, 255, 0, 255})
    if tileXY[1] == playerXY[1] and  tileXY[2] == playerXY[2] then
      drawChar("@", playerXY[1], playerXY[2], {255, 127, 127, 255}, {127, 255, 127, 255})
    end
    -- cursors
    love.graphics.setColor({255, 0, 0, 255})
    love.graphics.rectangle("fill", mouseXY[1] - 5, mouseXY[2] - 5, 10, 10)
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
