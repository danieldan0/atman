local Object = require 'lib.classic'

local SceneManager = Object:extend()

function SceneManager:new()
    self.current_scene = nil
end

function SceneManager:load(scene)
    if self.current_scene then
        self.current_scene:unload()
    end
    self.current_scene = scene
    collectgarbage()
    self.current_scene:load()
end

return SceneManager