Effects = require("class")()
Effects.name = "effects"

function Effects:__init()
    self.fx = {}
    return self
end

local function HSV(h, s, v)
    if s <= 0 then return v,v,v end
    h, s, v = h/256*6, s/255, v/255
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end return {(r+m)*255,(g+m)*255,(b+m)*255,255}
end

function Effects:fg_color()
    local color = self.drawable.fg_color
    local time = love.timer.getTime()
    if self.effects.fx.rainbow then
        if time - self.effects.fx.rainbow.start >= self.effects.fx.rainbow.duration and
        not self.effects.fx.rainbow.forever then
            self.effects.fx.rainbow = nil
            return color
        else
            local ms = time - math.floor(time)
            color = HSV(ms * self.effects.fx.rainbow.speed * 255, 255, 255)
        end
    end
    if self.effects.fx.blinking then
        if time - self.effects.fx.blinking.start >= self.effects.fx.blinking.duration and
        not self.effects.fx.blinking.forever then
            self.effects.fx.blinking = nil
            return color
        else
            local ms = time - math.floor(time)
            if (ms >= 0.25 and ms <= 0.5) or ms >= 0.75 then
                return color
            else
                return {0, 0, 0, 0}
            end
        end
    else
        return color
    end
end

function Effects:bg_color()
    return self.drawable.bg_color
end

function Effects:blink(duration, forever)
    self.effects.fx.blinking = {}
    self.effects.fx.blinking.duration = duration or 1
    self.effects.fx.blinking.start = love.timer.getTime()
    self.effects.fx.blinking.forever = forever ~= nil and forever or false
end

function Effects:rainbow(duration, forever)
    self.effects.fx.rainbow = {}
    self.effects.fx.rainbow.duration = duration or 1
    self.effects.fx.rainbow.start = love.timer.getTime()
    self.effects.fx.rainbow.forever = forever ~= nil and forever or true
    self.effects.fx.rainbow.speed = 1
end

return Effects