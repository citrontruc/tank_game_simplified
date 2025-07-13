-- Imports of our item

local EntityHandler = require("entities.entity_handler")
local PlayerFactory = require("player.player_factory")
local TankFactory = require("entities.tank.tank_factory")

-- Variables
local flags = {
    minwidth = 600,
    minheight = 400
}

-- Cell size for our screen grid
local cell_size_x = 200
local cell_size_y = 200

--Player variables
local player_initial_health = 3
local player_position = {
    x = 300,
    y = 300
}
local player_speed = {
    movement = 400,
    rotation = 10
}
local player_size = {
    x = 40,
    y = 40
}
local player_angle = 0
local player_tank_type = "blue"
local player_missile_type = "normal"

-- enemy_tank_variables

local enemy_initial_health = 3
local enemy_position = {
    x = 600,
    y = 600
}
local enemy_speed = {
    movement = 100,
    rotation = 5
}
local enemy_size = {
    x = 60,
    y = 60
}
local enemy_angle = 0
local enemy_tank_type = "red"
local enemy_missile_type = "normal"

-- Change sizeof screen
love.window.setMode(1200, 800, flags)

-- create out important objects
local entity_handler = EntityHandler:new(cell_size_x, cell_size_y)
local player_factory = PlayerFactory:new()
local tank_factory = TankFactory:new(entity_handler)

local player = player_factory:new_player()

-- Main methods
function love.load()
    local player_tank = tank_factory:new_tank(
        player_initial_health,
        player_position.x,
        player_position.y,
        player_size.x,
        player_size.y,
        player_angle,
        player_speed.movement,
        player_speed.rotation,
        player_tank_type,
        "player",
        player_missile_type
    )
    tank_factory:new_tank(
        enemy_initial_health,
        enemy_position.x,
        enemy_position.y,
        enemy_size.x,
        enemy_size.y,
        enemy_angle,
        enemy_speed.movement,
        enemy_speed.rotation,
        enemy_tank_type,
        "idle",
        enemy_missile_type
    )
    player:set_entity(player_tank)
    entity_handler:set_player(player)
end

function love.update(dt)
    entity_handler:update(dt)
end

function love.draw()
    love.graphics.print("Memory (KB): " .. collectgarbage("count"), 10, 10)
    entity_handler:draw()
end

-- Methods to change control type.
-- If a controller is pressed, we change to detect controller input
function love.keypressed(key, scancode, isrepeat)
    player.player_controller:set_control_type("keyboard")
end

function love.gamepadpressed(joy, button)
    player.player_controller:set_control_type("controller", joy)
end

function love.joystickadded(j)
    joystick = j -- support hot-plugging controllers
end
