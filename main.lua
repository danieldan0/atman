moonshine = require 'lib/moonshine'

function love.load()
  win_w = 640
  win_h = 480
  love.window.setTitle("atman")
  love.window.setMode(win_w, win_h, {resizable = false})
  screenBuffer = love.graphics.newCanvas(win_w, win_h)
  term_shader = love.graphics.newShader(readAll("assets/shaders/term/term.glsl"))
  font = love.graphics.newFont("assets/fonts/Press_Start_2P/PressStart2P-Regular.ttf", 16)
end

function love.update(dt)
end

function love.draw()
  love.graphics.setCanvas(screenBuffer)
  love.graphics.setColor(255, 255, 255)
  love.graphics.print({{0, 255, 0, 255}, "Hello world!"}, 200, 200)
  love.graphics.print({{0, 255, 0, 255}, "hmmm..... :Thonk:"}, 200, 216)
  love.graphics.print({{0, 255, 0, 255}, "Привет, мир!"}, 200, 232)
  love.graphics.setCanvas()

  term_shader:send("iResolution", {win_w, win_h})
  term_shader:send("iChannel", screenBuffer)
  love.graphics.setShader(term_shader)
  love.graphics.draw(screenBuffer, 0, 0)
  love.graphics.setShader()
end

function love.keypressed(k)
  if k == "escape" then
    love.event.quit()
  end
end

function readAll(file)
  local f = io.open(file, "rb")
  local content = f:read("*all")
  f:close()
  return content
end
