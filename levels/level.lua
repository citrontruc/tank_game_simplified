-- A level contains a certain number of ennemies to beat.
-- When a level ends, the game transitions to the next level.

-- Imports
local MathSupplement = require("utils.math_supplement")

local BEGINNING_COUNTDOWN = 5
local END_COUNTDOWN = 5
local COUNTDOWN_POSITION = {
    x = love.graphics.getWidth() - 50,
    y = 50
}
local DISTANCE_THRESHOLD = 100^2
local SPAWN_COOLDOWN =  3
local VICTORY_POSITION = {
    x = love.graphics.getWidth() / 2,
    y = love.graphics.getHeight() / 2,
}

local Level = {}
Level.__index = Level

function Level:new(level_name)
    local level = {
        -- Tank related variables
        active_tanks = {},
        remaining_tanks = {},
        max_tank = 0,
        entity_handler = {},
        -- Status of level variables
        beginning = true,
        finished = false,
        next_level = false,
        timer = 0,
        level_name = level_name
    }
    setmetatable(level, Level)
    return level
end

-- Setter functions
function Level:set_max_tank(max_tank)
    self.max_tank = max_tank
end

function Level:set_entity_handler(entity_handler)
    self.entity_handler = entity_handler
end

function Level:set_remaining_tanks(remaining_tanks)
    self.remaining_tanks = remaining_tanks
end

function Level:generate_random_tileset()
    -- Generate a tileset by choosing a random value for each tile.
end

-- Each level has a set number of tanks to clear.
function Level:update(dt, player_position)
    self.timer = self.timer + dt
    if self.beginning ~= true and self.finished ~= true then
        self:check_tank_status()
        if #self.remaining_tanks == 0 and #self.active_tanks == 0 then
            self.finished = true
            self.timer = 0
        end
        if #self.remaining_tanks > 0 and #self.active_tanks < self.max_tank and self.timer > SPAWN_COOLDOWN then
            self:spawn_tank(player_position)
        end
    else
        if self.timer > BEGINNING_COUNTDOWN then
            self.beginning = false
        end
        if self.finished == true and self.timer > END_COUNTDOWN then
            self.next_level = true
        end
    end
end

function Level:check_tank_status()
    for i = #self.active_tanks, 1, -1 do
        local object = self.active_tanks[i]
        if object.health <= 0 then
            table.remove(self.active_tanks, i)
        end
    end
end

-- When we spawn a tank, we take one of our remaining tanks and put it in the active tanks.
function Level:spawn_tank(player_position)
    local new_tank = self.remaining_tanks[1]
    if MathSupplement.get_distance_from_point(new_tank.position, player_position) > DISTANCE_THRESHOLD then
        self.entity_handler:assign(new_tank, new_tank.player)
        table.remove(self.remaining_tanks, 1)
        table.insert(self.active_tanks, new_tank)
        self.timer = 0
    end
end

function Level:draw_tileset()
    -- draw tileset : TODO
end

-- Text in order to display the number of tanks to destroy and messages to greet the player at the beginning and end of each levels
function Level:draw_text()
    love.graphics.print(
        "There are " .. #self.active_tanks + #self.remaining_tanks .. " tanks to beat, you can do it!",
        COUNTDOWN_POSITION.x,
        COUNTDOWN_POSITION.y
    )
    if self.beginning then
        love.graphics.print(
            "Welcome to the level: " .. self.level_name .. "! You must beat " .. #self.remaining_tanks .. " tanks to win!",
            VICTORY_POSITION.x,
            VICTORY_POSITION.y
        )
    end
    if self.finished then
        love.graphics.print(
            "Good job, you made it through the level! Loading next level...",
            VICTORY_POSITION.x,
            VICTORY_POSITION.y
        )
    end
end

return Level
