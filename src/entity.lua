Entity = require("class")()

local free_ids = {}
local next_id = 0

function Entity:__init(components)
    local id = #free_ids
    if id ~= 0 then
        self.id = free_ids[id]
        table.remove(free_ids, id)
    else
        self.id = next_id
        next_id = next_id + 1
    end
    
    self.components = components

    local index = self.__index
    setmetatable(self, {__index = 
        function(table, key)
            local component = table.components[key]
            if component ~= nil then
                return component
            else
                return index(table, key)
            end
        end
    })
    return self
end

function Entity:die()
    table.insert(free_ids, self.id)
end

return Entity