local function call(self, ...)
    local obj = setmetatable({}, self)
    return obj:__init(...)
end

return function(base)
    local class = setmetatable({}, {
        __index = function(_, k)
        return base and base[k] or nil end,
        __call = call,
    })
    class.__index = class
    return class
end