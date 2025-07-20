-- Imports of our item

local EntityHandler = require("entities.entity_handler")
local LevelHandler = require("levels.level_handler")
local PlayerFactory = require("player.player_factory")
local TankFactory = require("entities.tank.tank_factory")

-- Variables
local flags = {
    minwidth = 600,
    minheight = 400
}

-- Cell size for our screen grid
local CELL_SIZE_X = 200
local CELL_SIZE_Y = 200

-- Change sizeof screen
love.window.setMode(1200, 800, flags)

-- Main methods
function love.load()
    local entity_handler = EntityHandler:new(CELL_SIZE_X, CELL_SIZE_Y)
    local player_factory = PlayerFactory:new()
    local tank_factory = TankFactory:new(entity_handler)

    local player = player_factory:new_player()
    LEVEL_HANDLER = LevelHandler:new(tank_factory, entity_handler, player)
end

function love.update(dt)
    LEVEL_HANDLER:update(dt)
end

function love.draw()
    -- love.graphics.print("Memory (KB): " .. collectgarbage("count"), 10, 10)
    LEVEL_HANDLER:draw()
end

-- Methods to change control type.
-- If a controller is pressed, we change to detect controller input

function love.keypressed()
    LEVEL_HANDLER:get_player().player_controller:set_control_type("keyboard")
end

function love.gamepadpressed(joy)
    LEVEL_HANDLER:get_player().player_controller:set_control_type("controller", joy)
end
