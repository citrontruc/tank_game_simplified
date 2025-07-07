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
    rotation = 20
}
local player_size = {
    x = 40,
    y = 120
}
local player_angle = 0
local player_tank_type = "blue"

local player = player_factory:new_player(player_initial_health)

-- Change sizeof screen
love.window.setMode(1200, 800, flags)

-- Main methods
function love.load()
    local player_tank =
        tank_factory:new_tank(
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
end

function love.draw()
    player:draw()
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
