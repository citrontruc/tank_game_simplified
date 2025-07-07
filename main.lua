-- Imports of our item

local PlayerFactory = require("player.player_factory")
local TankFactory = require("entities.tank.tank_factory")

local player_factory = PlayerFactory:new()
local tank_factory = TankFactory:new()

-- Variables
local flags = {
    minwidth = 600,
    minheight = 400
}

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

local player = player_factory:new_player()
local enemy_tank = tank_factory:new_tank(
        enemy_initial_health,
        enemy_position.x,
        enemy_position.y,
        enemy_size.x,
        enemy_size.y,
        enemy_angle,
        enemy_speed.movement,
        enemy_speed.rotation,
        enemy_tank_type,
        "idle")

tank_factory:set_tank_state_specific_variables(enemy_tank)

-- Change sizeof screen
love.window.setMode(1200, 800, flags)

-- Main methods
function love.load()
    local player_tank =
        tank_factory:new_tank(
        player_initial_health,
        player_position.x,
        player_position.y,
        player_size.x,
        player_size.y,
        player_angle,
        player_speed.movement,
        player_speed.rotation,
        player_tank_type,
        "player"
    )
    player:set_entity(player_tank)
end

function love.update(dt)
    player:update(dt)
    enemy_tank:update(dt, player.player_entity.position)
end

function love.draw()
    player:draw()
    enemy_tank:draw()
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
