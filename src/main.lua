local moonshine = require 'lib/moonshine'
local ROT = require "lib/rotLove/rot"
local bitser = require 'lib/bitser'
local utils = require 'utils'
local render = require 'render'
local Map = require 'map'
local Mapgen = require 'mapgen'
local Tile = require 'tile'
local Entity = require 'entity'
local Position = require 'components/position'
local Movable = require 'components/movable'
local Drawable = require 'components/drawable'
local Input = require 'components/input'
local PlayerActor = require 'components/player_actor'
local MonsterActor = require 'components/monster_actor'
local Attacker = require 'components/attacker'
local Destroyable = require 'components/destroyable'
local FOV = require 'components/fov'
local Effects = require 'components/effects'
local Listener = require 'components/listener'
local Sender = require 'components/sender'
local Log = require 'components/log'
local Inventory = require 'components/inventory'
local Item = require 'components/item'
local BossActor = require 'components/boss_actor'
local Buffs = require 'components/buffs'

-- Game state.
-- Global, because I can't make pointers or something in Lua.
-- Or I could do it in the other way?
game = {
    map = Mapgen.generate(100, 100),
    entities = {},
    scores = {},
    user_input = {
        -- Corrected mouse coords
        mouseXY = {0, 0},
        -- Position of a tile under cursor
        tileXY = {0, 0},
        -- Pressed keys
        keys = {},
        -- Was key pressed?
        pressed_key = false
    }
}

local saved = false
local time = 0

if love.filesystem.exists("scores.dat") then
    game.scores = bitser.loadLoveFile('scores.dat')
end

PLAYER_ID = 0
BOSS_ID = 1

local function monster_template()
    return {{
        Position(unpack(utils.get_free_tile(10000))),
        Movable(),
        Drawable("?", {255, 0, 0, 255}, {0, 0, 0, 255}),
        Attacker(5),
        Destroyable(10),
        Effects(),
        Sender(),
        Inventory(0),
        MonsterActor(),
        Buffs()
    }, "?"}
end

local function gold_template(amount)
    x, y = unpack(utils.get_free_tile(10000))
    return {{
        Position(x, y, false),
        Drawable("$", {255, 255, 0, 255}, {0, 0, 0, 255}),
        Item(amount)
    }, "gold"}
end

local function heal_template()
    x, y = unpack(utils.get_free_tile(10000))
    return {{
        Position(x, y, false),
        Drawable("+", {127, 255, 127, 255}, {0, 0, 0, 255}),
        Sender(),
        Item(0, function(self_id, other_id)
            if other_id == PLAYER_ID then
                game.entities[self_id + 1].sender.send(game.entities[self_id + 1], other_id, "You are healed!", {0, 255, 0, 255})
                game.entities[self_id + 1]:die()
                game.entities[other_id + 1].destroyable.heal(game.entities[other_id + 1], 10)
            end
        end)
    }, "heal"}
end

local function trap_template()
    x, y = unpack(utils.get_free_tile(10000))
    return {{
        Position(x, y, false),
        Drawable("^", {255, 127, 0, 255}, {0, 0, 0, 255}),
        Attacker(10),
        Sender(),
        Item(0, function(self_id, other_id)
            game.entities[self_id + 1].attacker.attack(game.entities[self_id + 1], other_id)
            game.entities[self_id + 1]:die()
        end)
    }, "trap"}
end

local function poison_template()
    x, y = unpack(utils.get_free_tile(10000))
    return {{
        Position(x, y, false),
        Drawable("^", {75, 100, 0, 255}, {0, 0, 0, 255}),
        Attacker(10),
        Sender(),
        Item(0, function(self_id, other_id)
            game.entities[self_id + 1].sender.send(game.entities[self_id + 1], other_id, "You are poisoned!", {75, 100, 0, 255})
            game.entities[other_id + 1].buffs.poison(game.entities[other_id + 1], 2, 6)
            game.entities[self_id + 1]:die()
        end)
    }, "trap"}
end

local function bonus_template()
    x, y = unpack(utils.get_free_tile(10000))
    return {{
        Position(x, y, false),
        Drawable("O", {127, 255, 127, 255}, {0, 0, 0, 255}),
        Sender(),
        Effects(),
        Item(0, function(self_id, other_id)
            if other_id == PLAYER_ID then
                game.entities[self_id + 1].sender.send(game.entities[self_id + 1], other_id, "You feel more powerful!", {0, 255, 255, 255})
                game.entities[self_id + 1]:die()
                game.entities[other_id + 1].attacker.dmg = game.entities[other_id + 1].attacker.dmg + 5
            end
        end)
    }, "bonus"}
end

function place_entities()
    clean_all()

    player = Entity ({
        Position(unpack(game.map:find_rand(Tile.floor, 10000))),
        Movable(),
        Drawable("@", {255, 255, 255, 255}, {0, 0, 0, 255}),
        Input(),
        Attacker(5),
        Destroyable(20),
        FOV(5),
        Effects(),
        PlayerActor(),
        Sender(),
        Listener(),
        Log(4),
        Inventory(1),
        Buffs()
    }, "player")
    
    game.entities[player.id + 1] = player
    
    game.entities[PLAYER_ID + 1].fov.update(game.entities[PLAYER_ID + 1])
    --game.entities[PLAYER_ID + 1].effects.rainbow(game.entities[PLAYER_ID + 1])
    
    local pos = utils.get_free_tile(10000)
    repeat
        pos = utils.get_free_tile(10000)
    until pos ~= nil
    
    local boss = Entity({
        Position(unpack(pos)),
        Movable(),
        Drawable("D", {255, 255, 255, 255}, {0, 0, 0, 255}),
        Attacker(10),
        Destroyable(100),
        Effects(),
        Sender(),
        Inventory(0),
        BossActor(),
        Buffs()
    }, "dragon")
    BOSS_ID = boss.id
    game.entities[BOSS_ID + 1] = boss
    game.entities[BOSS_ID + 1].effects.rainbow(game.entities[BOSS_ID + 1])

    for i = 1, 40 do
        local monster = Entity(unpack(monster_template()))
        game.entities[monster.id + 1] = monster
    end

    for i = 1, 100 do
        local gold = Entity(unpack(gold_template(ROT.RNG:random(1, 5))))
        game.entities[gold.id + 1] = gold
    end

    for i = 1, 25 do
        local heal = Entity(unpack(heal_template()))
        game.entities[heal.id + 1] = heal
    end

    for i = 1, 25 do
        local trap = Entity(unpack(trap_template()))
        game.entities[trap.id + 1] = trap
    end

    for i = 1, 25 do
        local trap = Entity(unpack(poison_template()))
        game.entities[trap.id + 1] = trap
    end

    for i = 1, 5 do
        local bonus = Entity(unpack(bonus_template()))
        bonus.effects.rainbow(bonus)
        game.entities[bonus.id + 1] = bonus
    end

    game.entities[PLAYER_ID + 1].inventory.inv["gold"] = Entity(unpack(gold_template(0)))
end

place_entities()

-- Loading assets
function love.load()
    -- Loading shaders
    -- Just scanlines and crt, used for the screen "texture".
    s_scanlines = moonshine(moonshine.effects.scanlines)
    .chain(moonshine.effects.crt)
    s_scanlines.scanlines.thickness = 0.5
    s_scanlines.crt.scaleFactor = {1.15, 1.15}

    -- Glowing screen, used for actual drawing.
    -- Use this for rendering characters and stuff.
    s_screen = moonshine(moonshine.effects.scanlines)
    .chain(moonshine.effects.glow)
    .chain(moonshine.effects.crt)
    s_screen.scanlines.thickness = 0.5
    s_screen.crt.scaleFactor = {1.15, 1.15}

    -- Loading font.
    font = love.graphics.newFont("assets/fonts/Press_Start_2P/PressStart2P-Regular.ttf", 24)
    love.graphics.setFont(font)

    -- Loading screen frame image.
    frame = love.graphics.newImage("assets/images/screen-frame0.png")

    -- Hiding cursor.
    love.mouse.setVisible(false)

    -- Loading music loop.
    music = love.audio.newSource("assets/music/1.ogg")
    music:setLooping(true)
    music:play()

    -- Loading sounds for damage.
    dmg_sounds = {love.audio.newSource("assets/music/dmg0.ogg"), love.audio.newSource("assets/music/dmg1.ogg"),
    love.audio.newSource("assets/music/dmg2.ogg"), love.audio.newSource("assets/music/dmg3.ogg"),
    love.audio.newSource("assets/music/dmg4.ogg")}
end

-- Correcting mouse position.
function love.mousemoved(x, y, dx, dy, istouch)
    -- Correcting mouse coordinates.
    game.user_input.mouseXY = utils.fisheye({x, y}, 640, 496, 1.15, 1.06, 1.065)
    game.user_input.tileXY = {math.floor((game.user_input.mouseXY[1] - 12) / 24), math.floor(game.user_input.mouseXY[2] / 24)}
end

function love.update(dt)
    if not saved then
        time = time + dt
    end
    if game.user_input.pressed_key then
        for id, entity in ipairs(game.entities) do
            if entity and entity.alive and entity.actor then
                if not game.entities[PLAYER_ID + 1].alive or not game.entities[BOSS_ID + 1].alive then
                    break
                end
                entity.actor.act(entity)
            end
        end
        game.entities[PLAYER_ID + 1].fov.update(game.entities[PLAYER_ID + 1])
        game.user_input.pressed_key = false
    end
    if (not game.entities[PLAYER_ID + 1].alive or not game.entities[BOSS_ID + 1].alive) and not saved then
        local bonus = (game.entities[BOSS_ID + 1].alive and 0 or 1000) - math.floor(time / 3)
        table.insert(game.scores, math.max(0, game.entities[PLAYER_ID + 1].inventory.inv["gold"].item.amount + bonus))
        table.sort(game.scores, function(a,b) return a>b end)
        bitser.dumpLoveFile('scores.dat', game.scores)
        saved = true
    end
end

function love.keypressed(key)
    if key == "`" then
        debug.debug()
    end
    if key == "0" then
        game.map = Mapgen.generate(100, 100)
        place_entities()
    end
    game.user_input.keys[key] = true
    game.user_input.pressed_key = true
end
  
function love.keyreleased(key)
    game.user_input.keys[key] = nil
end

-- Rendering stuff
function love.draw()
    -- Drawing black scanlines background.
    s_scanlines(function()
        love.graphics.setColor({5, 5, 5, 255})
        love.graphics.rectangle("fill", 0, 0, 640, 480)
    end)

    -- Drawing all other stuff.
    s_screen(function()
        render.render_all(game.entities[PLAYER_ID + 1].position.x, game.entities[PLAYER_ID + 1].position.y, 26, 16,
                            game.map, game.entities)
        local min = tostring(math.floor(time / 60))
        local sec = tostring(math.floor(time) - (math.floor(time / 60) * 60))
        if #min < 2 then
            min = "0"..min
        end
        if #sec < 2 then
            sec = "0"..sec
        end
        render.draw_str(min..":"..sec, 0, 0, {255, 0, 255, 255}, {0, 0, 0, 255})
        if not game.entities[PLAYER_ID + 1].alive or not game.entities[BOSS_ID + 1].alive then
            if game.entities[BOSS_ID + 1].alive then
                render.draw_str("GAME OVER", 8, 0, {255, 0, 0, 255}, {0, 0, 0, 255})
            else
                render.draw_str("You won!", 8, 0, {0, 255, 0, 255}, {0, 0, 0, 255})
            end
            local bonus = (game.entities[BOSS_ID + 1].alive and 0 or 1000) - math.floor(time / 3)
            local score = math.max(0, game.entities[PLAYER_ID + 1].inventory.inv["gold"].item.amount + bonus)
            render.draw_str("Your score: "..score, 8, 1, {255, 0, 255, 255}, {0, 0, 0, 255})
            render.draw_str("Top scores:", 8, 2, {255, 255, 0, 255}, {0, 0, 0, 255})
            for i = 1, 5 do
                if game.scores[i] then
                    render.draw_str(tostring(game.scores[i]), 8, 2 + i, {255, 255, 255, 255}, {0, 0, 0, 255})
                end
            end
        end
        -- Rendering a cursor.
        love.graphics.setColor({255, 0, 0, 255})
        love.graphics.rectangle("fill", game.user_input.mouseXY[1] - 5, game.user_input.mouseXY[2] - 5, 10, 10)
    end)

    -- Drawing a screen frame.
    love.graphics.draw(frame, 0, 0)
end
