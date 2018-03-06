local SceneManager = require 'scene_manager'
local TestScene = require 'test_scene'

Game = {
	SceneManager = SceneManager(),
	Assets = require('lib.cargo').init('assets')
}

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
                    not Game.SceneManager.current_scene or not Game.SceneManager.current_scene:quit() then
						return a
					end
				end
                love.handlers[name](a,b,c,d,e,f)
                if Game.SceneManager.current_scene then
                    Game.SceneManager.current_scene[name](SceneManager.current_scene,a,b,c,d,e,f)
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
            if Game.SceneManager.current_scene then
                Game.SceneManager.current_scene:update(dt)
            end
        end

		if love.graphics and love.graphics.isActive() then
			love.graphics.clear(love.graphics.getBackgroundColor())
			love.graphics.origin()
            if love.draw then
                love.draw()
                if Game.SceneManager.current_scene then
                    Game.SceneManager.current_scene:draw()
                end
            end
			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end

function love.load()
	love.graphics.setFont(Game.Assets.fonts.Press_Start_2P.PressStart2P_Regular(24))
	Game.SceneManager:load(TestScene())
end

function love.update(dt)
end

function love.draw()
end

function love.quit()
    return false
end