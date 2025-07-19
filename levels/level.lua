-- A level contains a certain number of ennemies to beat.
-- When a level ends, the game transitions to the next level.

local Level = {}
Level.__index = Level

function Level:new()
end

function Level:update()
    local next_action = {

    }
    self:check_tank_status()
    if 0 >= self.total_tank then
        self.finished = true
    end
end

return Level