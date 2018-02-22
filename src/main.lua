SceneManager = require 'scene_manager'
TestScene = require 'test_scene'

SceneManager = SceneManager()
SceneManager:load(TestScene())

function love.run() 
	if love.math then
		love.math.setRandomSeed(os.time())
	end
 
	if love.load then love.load(arg) end
 
	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end
 
	local dt = 0
 
	-- Main loop time.
	while true do
		-- Process events.
		if love.event then
			love.event.pump()
            for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
                    if not love.quit or not love.quit() or 
                    not SceneManager.current_scene or not SceneManager.current_scene:quit() then
						return a
					end
				end
                love.handlers[name](a,b,c,d,e,f)
                if SceneManager.current_scene then
                    SceneManager.current_scene[name](SceneManager.current_scene,a,b,c,d,e,f)
                end
			end
		end
 
		-- Update dt, as we'll be passing it to update
		if love.timer then
			love.timer.step()
			dt = love.timer.getDelta()
		end
 
		-- Call update and draw
        if love.update then
            love.update(dt) -- will pass 0 if love.timer is disabled
            if SceneManager.current_scene then
                SceneManager.current_scene:update(dt)
            end
        end
 
		if love.graphics and love.graphics.isActive() then
			love.graphics.clear(love.graphics.getBackgroundColor())
			love.graphics.origin()
            if love.draw then
                love.draw()
                if SceneManager.current_scene then
                    SceneManager.current_scene:draw()
                end
            end
			love.graphics.present()
		end
 
		if love.timer then love.timer.sleep(0.001) end
	end 
end

function love.load()
end

function love.unload()
end

function love.directorydropped(path)
end

function love.draw()
end

function love.errhand(msg)
end

function love.errorhandler(msg)
end

function love.filedropped(file)
end

function love.focus(focus)
end

function love.gamepadaxis(joystick, axis, value)
end

function love.gamepadpressed(joystick, button)
end

function love.gamepadreleased(joystick, button)
end

function love.joystickadded(joystick)
end

function love.joystickaxis(joystick, axis, value)
end

function love.joystickhat(joystick, hat, direction)
end

function love.joystickpressed(joystick, button)
end

function love.joystickreleased(joystick, button)
end

function love.joystickremoved(joystick)
end

function love.keypressed(key, scancode, isrepeat)
end

function love.keyreleased(key, scancode)
end

function love.mousefocus(focus)
end

function love.mousemoved(x, y, dx, dy, istouch)
end

function love.mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
end

function love.quit()
    return false
end

function love.resize(w, h)
end

function love.textedited(text, start, length)
end

function love.textinput(text)
end

function love.threaderror(thread, errorstr)
end

function love.update(dt)
end

function love.visible(visible)
end

function love.wheelmoved(x, y)
end