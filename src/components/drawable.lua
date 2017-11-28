Drawable = require("class")()
Drawable.name = "drawable"

function Drawable:__init(char, fg_color, bg_color)
    self.name = Drawable.name
    self.char = char
    self.fg_color = fg_color
    self.bg_color = bg_color
    return self
end

return Drawable