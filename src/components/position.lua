Position = require("class")()
Position.name = "position"

function Position:__init(x, y)
    self.name = Position.name
    self.x = x
    self.y = y
    return self
end

function Position:tostring()
    return self.x .. ";" .. self.y
end

function Position:add(other)
    return Position:__init(self.x + other.x, self.y + other.y)
end

function Position:sub(other)
    return Position:__init(self.x - other.x, self.y - other.y)
end

function Position:mul(other)
    return Position:__init(self.x * other.x, self.y * other.y)
end

function Position:div(other)
    return Position:__init(self.x / other.x, self.y / other.y)
end

function Position:mod(other)
    return Position:__init(self.x % other.x, self.y % other.y)
end

function Position:pow(other)
    return Position:__init(self.x ^ other.x, self.y ^ other.y)
end

function Position:unm()
    return Position:__init(-self.x, -self.y)
end

function Position:eq(other)
    return self.x == other.x and self.y == other.y
end

function Position:dist8(other)
    return math.max(math.abs(self.x - other.x), math.abs(self.x - other.x))
end

function Position:dist4(other)
    return math.abs(self.x - other.x) + math.abs(self.x - other.x)
end

function Position:dist(other)
    return math.sqrt(((self.x - other.x) ^ 2) + ((self.x - other.x) ^ 2))
end

return Position