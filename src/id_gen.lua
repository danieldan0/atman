local Object = require 'lib.classic'

local IdGenerator = Object:extend()

function IdGenerator:new()
    self._next = 1
    self._free_ids = {}
end

function IdGenerator:get()
    if #self._free_ids > 0 then
        local id = self._free_ids[#self._free_ids]
        table.remove(self._free_ids)
        return id
    end
    local id = self._next
    self._next = self._next + 1
    return id
end

function IdGenerator:remove(id)
    table.insert(self._free_ids, id)
end

return IdGenerator