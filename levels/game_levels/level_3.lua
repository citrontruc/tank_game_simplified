-- Third level of the game, the player faces multiple tanks with chase bullets.

-- Second level of the game, the player faces multiple tanks.

local Level = require("levels.level")
local level_3 = {}

--Player variables
local PLAYER_INITIAL_HEALTH = 3
local PLAYER_POSITION = {
    x = 300,
    y = 300
}
local PLAYER_SPEED = {
    movement = 400,
    rotation = 5
}
local PLAYER_SIZE = {
    x = 40,
    y = 40
}
local PLAYER_ANGLE = 0
local PLAYER_TANK_TYPE = "blue"
local PLAYER_MISSILE_TYPE = "normal"

-- enemy_tank_variables

local ENEMY_INITIAL_HEALTH = 3
local ENEMY_SPEED = {
    movement = 100,
    rotation = 5
}
local ENEMY_SIZE = {
    x = 60,
    y = 60
}
local ENEMY_TANK_TYPE = "red"
local MAX_TANK = 4
local NUM_NORMAL_TANK_IN_LEVEL = 2
local NUM_CHASE_TANK_IN_LEVEL = 4

function level_3.initialize(tank_factory, entity_handler, player)
    local level = Level:new()
    -- We initialize our player and our enemies
    local player_tank = tank_factory:new_tank(
        PLAYER_INITIAL_HEALTH,
        PLAYER_POSITION.x,
        PLAYER_POSITION.y,
        PLAYER_SIZE.x,
        PLAYER_SIZE.y,
        PLAYER_ANGLE,
        PLAYER_SPEED.movement,
        PLAYER_SPEED.rotation,
        PLAYER_TANK_TYPE,
        "player",
        PLAYER_MISSILE_TYPE
    )
    local enemy_tank_table = {}
    for _ = 1, NUM_NORMAL_TANK_IN_LEVEL, 1 do
        local enemy_tank = tank_factory:new_tank(
            ENEMY_INITIAL_HEALTH,
            math.random(ENEMY_SIZE.x, love.graphics.getWidth() - ENEMY_SIZE.x), -- initial x position
            math.random(ENEMY_SIZE.y, love.graphics.getHeight() - ENEMY_SIZE.y),
            ENEMY_SIZE.x,
            ENEMY_SIZE.y,
            math.rad(math.random(0, 360)),
            ENEMY_SPEED.movement,
            ENEMY_SPEED.rotation,
            ENEMY_TANK_TYPE,
            "idle",
            "normal"
        )
        table.insert(enemy_tank_table, enemy_tank)
    end
    for _ = 1, NUM_CHASE_TANK_IN_LEVEL, 1 do
        local enemy_tank = tank_factory:new_tank(
            ENEMY_INITIAL_HEALTH,
            math.random(ENEMY_SIZE.x, love.graphics.getWidth() - ENEMY_SIZE.x), -- initial x position
            math.random(ENEMY_SIZE.y, love.graphics.getHeight() - ENEMY_SIZE.y),
            ENEMY_SIZE.x,
            ENEMY_SIZE.y,
            math.rad(math.random(0, 360)),
            ENEMY_SPEED.movement,
            ENEMY_SPEED.rotation,
            ENEMY_TANK_TYPE,
            "idle",
            "chase"
        )
        table.insert(enemy_tank_table, enemy_tank)
    end
    -- We assign the values to our player and our level entity.
    level:set_entity_handler(entity_handler)
    level:set_remaining_tanks(enemy_tank_table)
    level:set_max_tank(MAX_TANK)
    player:set_entity(player_tank)
    entity_handler:set_player(player)
    return level
end

return level_3
