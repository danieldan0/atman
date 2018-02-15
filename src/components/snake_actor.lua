local ROT = require "lib/rotLove/rot"
local Entity = require "entity"
local Position = require "components/position"
local Movable = require 'components/movable'
local Drawable = require 'components/drawable'
local Attacker = require 'components/attacker'
local Destroyable = require 'components/destroyable'
local Effects = require 'components/effects'
local Sender = require 'components/sender'
local Inventory = require 'components/inventory'
local Buffs = require 'components/buffs'
local utils = require 'utils'
SnakeActor = require("class")()
SnakeActor.name = "actor"
local dirs = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}}

function SnakeActor:__init(life)
    self.name = SnakeActor.name
    self.life = life ~= nil and life or 3
    self.head = nil
    self.next = nil
    return self
end

function SnakeActor:act()
    self.buffs.update(self)
    if not self.actor.head then
        self.actor.move(self)
    end
end

-- FIXME
function SnakeActor:move(old_position)
    if old_position == nil then
        local dx, dy = unpack(dirs[ROT.RNG:random(1, 4)])
        local old_position = self.position
        local moved = ""
        if self.actor.next and (not self.position:add(Position(dx, dy)):eq(game.entities[self.actor.next].position)) then
            moved = self.movable.move(self, dx, dy, game.map, game.entities)
        elseif not self.actor.next then
            moved = self.movable.move(self, dx, dy, game.map, game.entities)
        end
        if moved == "moved" then
            if self.actor.life > 0 and self.actor.next == nil then
                local snake = self:clone()
                snake.destroyable.hp = self.destroyable.max_hp
                snake.actor.life = self.actor.life - 1
                snake.actor.head = self.id
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
            if self.actor.life > 0 and self.actor.next == nil then
                local snake = self:clone()
                snake.destroyable.hp = self.destroyable.max_hp
                snake.actor.life = self.actor.life - 1
                snake.actor.head = self.id
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
    if self.actor.head then
        game.entities[self.actor.head].actor.next = nil
    end
    if self.actor.next then
        game.entities[self.actor.next]:die()
    end
end

return SnakeActor