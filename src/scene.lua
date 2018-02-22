local Object = require 'lib.classic'

local Scene = Object:extend()

function Scene:new()
end

function Scene:load()
end

function Scene:unload()
end

function Scene:directorydropped(path)
end

function Scene:draw()
end

function Scene:errhand(msg)
end

function Scene:errorhandler(msg)
end

function Scene:filedropped(file)
end

function Scene:focus(focus)
end

function Scene:gamepadaxis(joystick, axis, value)
end

function Scene:gamepadpressed(joystick, button)
end

function Scene:gamepadreleased(joystick, button)
end

function Scene:joystickadded(joystick)
end

function Scene:joystickaxis(joystick, axis, value)
end

function Scene:joystickhat(joystick, hat, direction)
end

function Scene:joystickpressed(joystick, button)
end

function Scene:joystickreleased(joystick, button)
end

function Scene:joystickremoved(joystick)
end

function Scene:keypressed(key, scancode, isrepeat)
end

function Scene:keyreleased(key, scancode)
end

function Scene:mousefocus(focus)
end

function Scene:mousemoved(x, y, dx, dy, istouch)
end

function Scene:mousepressed(x, y, button, istouch)
end

function Scene:mousereleased(x, y, button, istouch)
end

function Scene:quit()
    return false
end

function Scene:resize(w, h)
end

function Scene:textedited(text, start, length)
end

function Scene:textinput(text)
end

function Scene:threaderror(thread, errorstr)
end

function Scene:update(dt)
end

function Scene:visible(visible)
end

function Scene:wheelmoved(x, y)
end

return Scene
