Entity = require("class")()

local free_ids = {}
local next_id = 0

function Entity:__init(components, name)
    self.alive = true
    self.name = #name > 0 and name or ""
    
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
            elseif key == "id" or key == "die" or key == "alive" or key == "components" or key == "name" then
                return table[key]
            else
                return nil
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