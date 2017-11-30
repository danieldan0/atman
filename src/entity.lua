Entity = require("class")()

local free_ids = {}
local next_id = 0

function Entity:__init(components)
    self.alive = true
    
    local id = #free_ids
    if id ~= 0 then
        self.id = free_ids[id]
        table.remove(free_ids, id)
    else
        self.id = next_id
        next_id = next_id + 1
    end

    self.components = {}
    
    for _, component in ipairs(components) do
        self.components[component.name] = component
    end
    
    self.die = function(self)
        self.alive = false
        table.insert(free_ids, self.id)
    end

    -- Making metamethods for components
    local index = self.__index
    setmetatable(self, {__index = 
        function(table, key)
            local component = table.components[key]
            if component ~= nil then
                return component
            else
                return index(table, key)
            end
        end,
    __newindex =
        function(table, key, value)
            table.components[key] = value
        end
    })

    return self
end

return Entity