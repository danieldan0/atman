local ROT = require "lib/rotLove/rot"
local Entity = require 'entity'
SnakeActor = require("class")()
SnakeActor.name = "actor"
local dirs = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}}

function SnakeActor:__init(life, head, factory)
    self.name = SnakeActor.name
    self.life = life ~= nil and life or 3
    self.head = head ~= nil and head or true
    self.factory = factory and factory or function()
        return {{
            Position(unpack(utils.get_free_tile(10000))),
            Movable(),
            Drawable("s", {0, 50, 0, 255}, {0, 0, 0, 255}),
            Attacker(5),
            Destroyable(10),
            Effects(),
            Sender(),
            Inventory(0),
            SnakeActor(),
            Buffs()
        }, "snake"}
    end
    self.next = nil
    return self
end

function SnakeActor:act()
    self.buffs.update(self)
    if self.actor.head then
        self.actor.move(self)
    end
end

function SnakeActor:move(old_position)
    if old_position == nil then
        local dx, dy = unpack(dirs[ROT.RNG:random(1, 4)])
        local old_position = self.position
        self.movable.move(self, dx, dy, game.map, game.entities)
        if not (self.position:eq(old_position)) then
            if self.actor.life ~= 0 and self.actor.next == nil then
                local snake = Entity(unpack(self.actor.factory()))
                snake.actor.life = self.actor.life - 1
                snake.actor.head = false
                snake.position = old_position
                self.actor.next = snake.id
                game.entities[snake.id] = snake
            elseif self.actor.next then
                game.entities[self.actor.next].actor.move(game.entities[self.actor.next], old_position)
            end
        end
    else
        local pos = self.position
        self.position = old_position
        if not (self.position:eq(old_position)) then
            if self.actor.life ~= 0 and self.actor.next == nil then
                local snake = Entity(unpack(self.actor.factory()))
                snake.actor.life = self.actor.life - 1
                snake.actor.head = false
                snake.position = old_position
                self.actor.next = snake.id
                game.entities[snake.id] = snake
            elseif self.actor.next then
                game.entities[self.actor.next].actor.move(game.entities[self.actor.next], pos)
            end
        end
    end
end

function SnakeActor:die()
    if self.actor.next then
        game.entities[self.actor.next]:die()
    end
end

return SnakeActor