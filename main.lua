-- Imports of our item

local EntityHandler = require("entities.entity_handler")
local Level_1 = require("levels.game_levels.level_1")
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

-- create out important objects
local entity_handler = EntityHandler:new(CELL_SIZE_X, CELL_SIZE_Y)
local player_factory = PlayerFactory:new()
local tank_factory = TankFactory:new(entity_handler)

local player = player_factory:new_player()
local level_1 = Level_1.initialize(tank_factory, entity_handler, player)

-- Main methods
function love.load()
    
end

function love.update(dt)
    entity_handler:update(dt)
    level_1:update(dt, entity_handler:get_player_position())
end

function love.draw()
    -- love.graphics.print("Memory (KB): " .. collectgarbage("count"), 10, 10)
    entity_handler:draw()
    level_1:draw_text()
end

-- Methods to change control type.
-- If a controller is pressed, we change to detect controller input

function love.keypressed()
    player.player_controller:set_control_type("keyboard")
end

function love.gamepadpressed(joy)
    player.player_controller:set_control_type("controller", joy)
end
