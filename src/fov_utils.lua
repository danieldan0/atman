fov_utils = {}

function fov_utils.light_callback(fov, x, y)
  return game.map:get_tile(x, y) and game.map:get_tile(x, y).transparent
end

function fov_utils.compute_callback(x, y, r, v)
  game.fov_map[x..";"..y] = v
end

return fov_utils
