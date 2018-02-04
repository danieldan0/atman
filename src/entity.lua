Entity = require("class")()

local free_ids = {}
local next_id = 1

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
        if self.id == PLAYER_ID then
            self.log.add(self, "You died!", {177, 0, 13, 255})
        end
        if self.id == BOSS_ID then
            game.entities[PLAYER_ID].log.add(game.entities[PLAYER_ID], "You won!", {255, 215, 0, 255})
        end
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

function clean_all()
    free_ids = {}
    next_id = 1
end

return Entity