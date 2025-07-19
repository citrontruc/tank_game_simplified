-- A level contains a certain number of ennemies to beat.
-- When a level ends, the game transitions to the next level.

-- Imports
local MathSupplement = require("utils.math_supplement")


local DISTANCE_THRESHOLD = 100

local Level = {}
Level.__index = Level

function Level:new(tank_factory, remaining_tanks, max_tank)
    local level = {
        active_tanks = {},
        remaining_tanks = remaining_tanks,
        tileset = {},
        finished = false,
        timer = 0,
        max_tank = max_tank,
        tank_factory = tank_factory
    }
    setmetatable(level, Level)
    return level
end

function Level:generate_random_tileset()
    -- Generate a tileset by choosing a random value for each tile.
end

-- Each level has a set number of tanks to clear.
function Level:update(player_position)
    self:check_tank_status()
    if #self.remaining_tanks == 0 and #self.active_tanks == 0 then
        self.finished = true
    end
    if #self.remaining_tanks >= 0 and #self.active_tanks < self.max_tank then
        self:spawn_tank(player_position)
    end
end

function Level:check_tank_status()
    for i = #self.active_tanks, 1, -1 do
        local object = self.list_object.player[i]
        if object.health <= 0 then
            table.remove(self.active_tanks, i)
        end
    end
end

function Level:spawn_tank(player_position)
    local newt_tank = self.remaining_tanks[0]

end

function Level:draw()
    -- draw tileset

end

return Level