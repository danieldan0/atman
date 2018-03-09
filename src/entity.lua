local Object = require 'lib.classic'
local IdGenerator = require('id_gen')()

local Entity = Object:extend()

function Entity:new(components)
    self.id = IdGenerator:get()
    self.alive = true
    self.components = {}
    for _, component in pairs(components) do
        if type(component) == "table" then
            self.components[component.name] = component
            self.components[component.name].owner = self.id
        end
    end

    function self:die()
        self.alive = false
        IdGenerator:remove(self.id)
    end

    setmetatable(self, {
        __index =
            function(table, key)
                local component = table.components[key]
                if component ~= nil then
                    return component
                else
                    return table[key]
                end
            end,
        __newindex =
            function(table, key, value)
                table.components[key] = value
            end
    })
end

return Entity