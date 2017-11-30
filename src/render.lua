utils = require 'utils'

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
    if v and game.entities[PLAYER_ID + 1].fov.map[x .. ";" .. y] then
        render.draw_char(v.char, x - camera_x, y - camera_y, v.color, {0, 0, 0, 0})
    end
    return v
end

function render.draw_entity(entity, camera_x, camera_y, w, h)
    if entity and entity.alive and entity.drawable and entity.position
    and game.entities[PLAYER_ID + 1].fov.map[entity.position.x .. ";" .. entity.position.y] and
    utils.in_area(entity.position.x, entity.position.y, camera_x, camera_y, w - 1, h - 1) then
        render.draw_char(entity.drawable.char, entity.position.x - camera_x,
                        entity.position.y - camera_y, entity.drawable.fg_color, entity.drawable.bg_color)
    end
end

function render.render_all(x, y, w, h, map, entities)
    x = math.max(0, math.max(0, math.min(x, map.width - 1 - (w / 2))) - (w / 2)) + 1
    y = math.max(0, math.max(0, math.min(y, map.height - 1 - (h / 2))) - (h / 2)) + 1
    map:for_region(math.floor(x), math.floor(y), w, h, render.draw_tile, math.floor(x), math.floor(y))
    for _, entity in ipairs(entities) do
        render.draw_entity(entity, x, y, w, h)
    end
end

return render