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

function render.draw_tile(x, y, v, camera_x, camera_y)
    render.draw_char(v.char, x - camera_x, y - camera_y, v.color, {0, 0, 0, 0})
    return v
end

function render.render_all(x, y, w, h, map)
    x = math.max(0, math.max(0, math.min(x, map.width - 1)) - (w / 2))
    y = math.max(0, math.max(0, math.min(y, map.height - 1)) - (h / 2))
    map:for_region(math.floor(x), math.floor(y), w, h, render.draw_tile, math.floor(x), math.floor(y))
end

return render