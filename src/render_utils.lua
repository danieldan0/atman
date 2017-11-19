render_utils = {}

function render_utils.draw_char(char, x, y, color, bg)
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

function render_utils.render_all(entities)
  for id, entity in pairs(entities) do
    render_utils.draw_char(entity.char, entity.x, entity.y, entity.color, {0, 0, 0, 0})
  end
end

return render_utils
