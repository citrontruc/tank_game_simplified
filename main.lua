-- Imports of our item

-- Variable
local flags = {
    minwidth = 600,
    minheight = 400
}

-- Change sizeof screen
love.window.setMode(1200, 800, flags)

-- Main methods
function love.load()
end

function love.update(dt)
end

function love.draw()
end

-- Methods to change control type.
-- If a controller is pressed, we change to detect controller input
function love.keypressed(key, scancode, isrepeat)
   player.player_controller:set_control_type("keyboard")
end

function love.gamepadpressed(joy, button)
    player.player_controller:set_control_type("controller", joystick)
end

function love.joystickadded(j)
    joystick = j  -- support hot-plugging controllers
end
