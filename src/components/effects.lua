Effects = require("class")()
Effects.name = "effects"

function Effects:__init()
    self.start = 0
    self.duration = 0
    self.blinking = false
    return self
end

function Effects:fg_color()
    if self.effects.blinking then
        local time = love.timer.getTime()
        if time - self.effects.start >= self.effects.duration then
            self.effects.blinking = false
            return self.drawable.fg_color
        else
            local ms = time - math.floor(time)
            if (ms >= 0.25 and ms <= 0.5) or ms >= 0.75 then
                return self.drawable.fg_color
            else
                return {0, 0, 0, 0}
            end
        end
    else
        return self.drawable.fg_color
    end
end

function Effects:bg_color()
    return self.drawable.bg_color
end

function Effects:blink(duration)
    self.effects.blinking = true
    self.effects.duration = duration
    self.effects.start = love.timer.getTime()
end

return Effects