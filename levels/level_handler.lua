-- An object to initialize all the levels.
-- When a level ends, the game transitions to the next level.

local Level_1 = require("levels.game_levels.level_1")
local Level_2 = require("levels.game_levels.level_2")
local Level_3 = require("levels.game_levels.level_3")

local LevelHandler = {}
LevelHandler.__index = LevelHandler

function LevelHandler:new(tank_factory, entity_handler, player)
    local level_handler = {
        tank_factory = tank_factory,
        entity_handler = entity_handler,
        player = player,
        list_levels = {
            Level_1,
            Level_2,
            Level_3
        },
        current_level_index = 1,
        current_level = nil
    }
    setmetatable(level_handler, LevelHandler)
    level_handler:load_new_level()
    return level_handler
end

function LevelHandler:get_player()
    return self.player
end

function LevelHandler:load_new_level()
    if self.current_level_index > #self.list_levels then
        self.current_level_index = 1
    end
    self.current_level = self.list_levels[self.current_level_index].initialize(self.player, self.tank_factory, self.entity_handler)
end

function LevelHandler:update(dt)
    self.entity_handler:update(dt)
    self.current_level:update(dt, self.entity_handler:get_player_position())
    if self.current_level.next_level == true then
        self.current_level_index = self.current_level_index + 1
        self:load_new_level()
    end
end

function LevelHandler:draw()
    self.entity_handler:draw()
    self.current_level:draw_text()
end

return LevelHandler
