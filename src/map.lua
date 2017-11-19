--- The map module
-- Has a Map class, which is used to hold a 2D grid of elements.
-- @module map

local class = require 'lib/middleclass'
local Tile = require 'tile'

Map = class("Map")

--- Initializes a Map instance filled with solid Tiles.
-- @param width a positive integer
-- @param height a positive integer
function Map:initialize(width, height)
  self.width = width
  self.height = height
  self.data = {}
  for i = 0, width * height - 1 do
    self.data[i] = Tile()
  end
end

--- Converts position(x, y) to index in map.
-- @param x a positive integer
-- @param y a positive integer
-- @return an index for this map
function Map:to_index(x, y)
  return self.width * y + x
end

--- Converts position in string format("X;Y") to index in map.
-- @param xy a string in X;Y format
-- @return an index for this map
function Map:to_index_str(xy)
  local x, y = xy:match("([^;]+);([^;]+)")
  return self:to_index(x, y)
end

--- Checks if position is in bounds of a map.
-- @param x an integer
-- @param y an integer
-- @return a bool
function Map:in_bounds(x, y)
  return x >= 0 and x < self.width and y > 0 and y < self.height
end

--- Sets a value in position(x, y) to the new value
-- Errors if a position is outside of map's bounds.
-- @param x an integer
-- @param y an integer
-- @param v any value
function Map:set(v, x, y)
  assert(inBounds(x, y), "Trying to set tile out of the map bounds.")
  self.data[self.to_index(x, y)] = v
end

--- Sets all values in the map to the new value.
-- @param v any value
function Map:set_all(v)
  for i = 0, width * height - 1 do
    self.data[i] = v
  end
end

--- Gets a value on the position.
-- @param xy a string in X;Y format
-- @return any value, nil if doesn't exist
function Map:get_str(xy)
  return self.data[to_index_str(x, y)]
end

--- Gets a value on the position.
-- @param x an integer or a string in X;Y format
-- @param y an integer
-- @return any value, nil if doesn't exist
function Map:get(x, y)
  if type(x) == "string" then
    return self:get_str(x)
  end
  return self.data[to_index(x, y)]
end

--- Iterate over map region.
-- @param x an integer
-- @param y an integer
-- @param w an integer(width)
-- @param h an integer(height)
-- @param func a function which will get values and which will return new values
function Map:iter(x, y, w, h, func)
  for row = y, y + h - 1 do
    for column = x, x + w - 1 do
      self.set(row, column, func(self.get(row, column)))
    end
  end
end

--- Iterate over map region.
-- @param x an integer
-- @param y an integer
-- @param w an integer(width)
-- @param h an integer(height)
-- @param func a function which will get values and positions and which will return new values
function Map:iter_xy(x, y, w, h, func)
  for row = y, y + h - 1 do
    for column = x, x + w - 1 do
      self.set(row, column, func(self.get(row, column), row, column))
    end
  end
end

--- Iterate over all map.
-- @param func a function which will get values and which will return new values
function Map:foreach(func)
  self:iter(0, 0, self.width, self.height, func)
end

--- Iterate over all map.
-- @param func a function which will get values and positions and which will return new values
function Map:foreach_xy(func)
  self:iter_xy(0, 0, self.width, self.height, func)
end

--- Gets a piece of a map.
-- @param x an integer
-- @param y an integer
-- @param w an integer(width)
-- @param h an integer(height)
-- @return a new Map
function Map:submap(x, y, w, h)
  local map = Map:initialize(w, h)
  local data = {}
  for row = y, y + h - 1 do
    for column = x, x + w - 1 do
      data:insert(self.get(row, column))
    end
  end
  map.data = data
  return map
end

--- Finds a value in region.
-- @param x an integer
-- @param y an integer
-- @param w an integer(width)
-- @param h an integer(height)
-- @param v any value
-- @return a position{x, y} or nil if there is no that value in the region
function Map:find_region(x, y, w, h, v)
  for row = y, y + h - 1 do
    for column = x, x + w - 1 do
      if self.get(row, column) == v then
        return {row, column}
      end
    end
  end
end

--- Finds a value in region, randomly.
-- @param x an integer
-- @param y an integer
-- @param w an integer(width)
-- @param h an integer(height)
-- @param v any value
-- @param attempts number of attemptsof finding
-- @return a position{x, y} or nil if there is no that value in the region
function Map:find_region_rand(x, y, w, h, v, attempts)
  math.randomseed(os.time())
  math.random(); math.random(); math.random()
  for i = 1, attempts do
    local x = math.random(x, w - 1)
    local y = math.random(y, h - 1)
    if self.get(x, y) == v then
      return {x, y}
    end
  end
end

--- Finds a value in the map.
-- @param v any value
-- @return a position{x, y} or nil if there is no that value in the map
function Map:find(v)
  return self:find_region(0, 0, self.width, self.height, v)
end

--- Finds a value in the map, randomly.
-- @param v any value
-- @return a position{x, y} or nil if there is no that value in the map
function Map:find_rand(v, attempts)
  return self:find_region_rand(0, 0, self.width, self.height, v, attempts)
end

--- Checks values in the region using a function.
-- @param x an integer
-- @param y an integer
-- @param w an integer(width)
-- @param h an integer(height)
-- @param func a function which will get values and which will return a bool
-- @return a set of positions in the "X;Y" format
function Map:check(x, y, w, h, func)
  local results = {}
  for row = y, y + h - 1 do
    for column = x, x + w - 1 do
      if func(self.get(row, column)) then
        results[x.tostring() .. ";" .. y.tostring()] = true
      end
    end
  end
  return results
end

--- Checks values in the region using a function.
-- @param x an integer
-- @param y an integer
-- @param w an integer(width)
-- @param h an integer(height)
-- @param func a function which will get values and positions and which will return a bool
-- @return a set of positions in the "X;Y" format
function Map:check_xy(x, y, w, h, func)
  local results = {}
  for row = y, y + h - 1 do
    for column = x, x + w - 1 do
      if func(self.get(row, column), row, column) then
        results[x.tostring() .. ";" .. y.tostring()] = true
      end
    end
  end
  return results
end

--- Checks values in the map using a function.
-- @param func a function which will get values and which will return a bool
-- @return a set of positions in the "X;Y" format
function Map:check_all(func)
  return self:check(0, 0, self.width, self.height, func)
end

--- Checks values in the map using a function.
-- @param func a function which will get values and positions and which will return a bool
-- @return a set of positions in the "X;Y" format
function Map:check_xy_all(func)
  return self:check_xy(0, 0, self.width, self.height, func)
end

--- Makes an exact copy of the map.
-- @return a new Map
function Map:clone()
  local map = Map:initialize(self.width, self.height)
  map.data = self.data
  return map
end

return Map
