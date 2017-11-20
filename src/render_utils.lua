render_utils = {}

colors_table = {}

function render_utils.draw_char(char, x, y, color, bg)
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

function render_utils.draw_tile(v, x, y)
  local wall = not v.transparent
  if fov_map[x..";"..y] then
    if wall then
      render_utils.draw_char('', x, y, {0, 0, 0, 0}, colors.light_wall)
    else
      render_utils.draw_char('', x, y, {0, 0, 0, 0}, colors.light_ground)
    end
  else
    if wall then
      render_utils.draw_char('', x, y, {0, 0, 0, 0}, colors.dark_wall)
    else
      render_utils.draw_char('', x, y, {0, 0, 0, 0}, colors.dark_ground)
    end
  end
  return v
end

function render_utils.render_all(entities, map, fov, colors)
  colors_table = colors
  fov_map = fov
  map:foreach_xy(render_utils.draw_tile)
  for id, entity in pairs(entities) do
    render_utils.draw_char(entity.char, entity.x, entity.y, entity.color, {0, 0, 0, 0})
  end
end

return render_utils
