render = {}

function render.draw_char(char, x, y, color, bg)
  love.graphics.setColor(bg)
  love.graphics.rectangle('fill', x * 24 + 8, y * 24 + 4, 24, 24)
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.print(char, x * 24 - 1 + 8, y * 24 + 9)
  love.graphics.print(char, x * 24 - 1 + 8, y * 24 + 11)
  love.graphics.print(char, x * 24 + 1 + 8, y * 24 + 9)
  love.graphics.print(char, x * 24 + 1 + 8, y * 24 + 11)
  love.graphics.setColor(255, 255, 255, 255)
  love.graphics.print({color, char}, x * 24 + 8, y * 24 + 10)
end

return render