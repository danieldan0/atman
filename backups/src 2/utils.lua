utils = {}

function utils.readAll(file)
  local f = io.open(file, "rb")
  local content = f:read("*all")
  f:close()
  return content
end

function utils.inArea(x, y, area_x, area_y, area_w, area_h)
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

return utils
