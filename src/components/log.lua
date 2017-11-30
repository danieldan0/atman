Log = require("class")()
Log.name = "log"

function Log:__init(length)
    self.name = Log.name
    self.length = length
    self.log = {}
    return self
end

function Log:add(message, color)
    if self.log.log[#self.log.log] and message == self.log.log[#self.log.log].message then
        self.log.log[#self.log.log].amount = self.log.log[#self.log.log].amount + 1
    else
        if #self.log.log >= self.log.length then
            table.remove(self.log.log, 1)
        end
        table.insert(self.log.log, {message = message, color = color, amount = 1})
    end
end

local function text_wrap (s, width)
    width = width or 70
    s = s:gsub('\n',' ')
    local i,nxt = 1
    local lines,line = {}
    while i < #s do
        nxt = i+width
        line = s:sub(i,nxt)
        i = i + #line
        table.insert(lines, line)
    end
    return lines
end

local function slice(tbl, first, last, step)
    local sliced = {}
  
    for i = first or 1, last or #tbl, step or 1 do
        sliced[#sliced+1] = tbl[i]
    end
  
    return sliced
end

function Log:get(width, height)
    local messages = {}
    for _, item in ipairs(self.log.log) do
        local strings = {}
        if item.amount > 1 then
            strings = text_wrap(item.message .. " x" .. item.amount, width)
        else
            strings = text_wrap(item.message, width)
        end
        for _, str in ipairs(strings) do
            table.insert(messages, {color = item.color, message = str})
        end
    end
    return slice(messages, #messages - height + 1)
end

return Log