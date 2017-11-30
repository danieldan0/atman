-- Some helper functions.
local Tile = require 'tile'

utils = {}

function utils.read_all(file)
    local f = io.open(file, "rb")
    local content = f:read("*all")
    f:close()
    return content
end

function utils.in_area(x, y, area_x, area_y, area_w, area_h)
    return (((x >= area_x) and (x <= area_x + area_w)) and ((y >= area_y) and (y <= area_y + area_h)))
end

function utils.fisheye(vec, w, h, scale, distortX, distortY)
    result = {vec[1] / w, vec[2] / h}
    result = {result[1] * 2.0 - 1.0, result[2] * 2.0 - 1.0}
    result = {result[1] * scale, result[2] * scale}
    result = {result[1] + (result[2] * result[2] * result[1] * (distortX - 1)),
                         result[2] + (result[1] * result[1] * result[2] * (distortY - 1))}
    result = {(result[1] + 1.0) / 2.0, (result[2] + 1.0) / 2.0}
    result = {result[1] * w, result[2] * h}
    return result
end

function utils.get_free_tile(attempts)
    for i = 1, attempts do
        x, y = unpack(game.map:find_rand(Tile.floor, attempts))
        local free = true
        for id, entity in ipairs(game.entities) do
            if entity and entity.alive and entity.position and entity.position.x == x and
            entity.position.y == y and entity.position.blocks then
                free = false
                break
            end
        end
        if free then
            return {x, y}
        end
    end
end

return utils