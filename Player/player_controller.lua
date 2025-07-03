-- A class to control our player character

local PlayerController = {}
PlayerController.__index = PlayerController

-- Value to move somewhere else?
local movement_threshold = 0.1

--creation
function PlayerController:new(control_type)
    local object = {
        control_type = control_type,
        joystick = nil
    }
    setmetatable(object, PlayerController)
    return object
end

--setter
function PlayerController:set_control_type(control_type, joystick)
    self.control_type = control_type
    self.joystick = joystick
end

--update
function PlayerController:update(dt, x, y, angle, size_x, size_y, joystick)
    local move_function = {
        keyboard = PlayerController.move_with_keyboard,
        controller = PlayerController.move_with_controller
    }

    chosen_move_function = move_function[self.control_type]
    dx1, dy1, dx2, dy2, action = chosen_move_function(self, joystick)
    return dx1, dy1, dx2, dy2, action
end

--movement functions
--movement with keyboard. Keys are hard coded right now
function PlayerController:move_with_keyboard(joystick)
    local dx = 0
    local dy = 0
    if love.keyboard.isDown("down") then
        dy = 1
    end
    if love.keyboard.isDown("up") then
        dy = -1
    end
    if love.keyboard.isDown("right") then
        dx = 1
    end
    if love.keyboard.isDown("left") then
        dx = -1
    end
    return dx, dy, nil, nil, false
end

-- movement with controller
function PlayerController:move_with_controller(dt, joystick)
    local dx1 = 0
    local dy1 = 0
    local dx2 = nil
    local dy2 = nil
    if not joystick then
        return 0, 0
    end
    -- Move with dpad (in which case the angle follows the tank.)
    if joystick:isGamepadDown("dpdown") then
        dy1 = 1
    end
    if joystick:isGamepadDown("dpup") then
        dy1 = -1
    end
    if joystick:isGamepadDown("dpright") then
        dx1 = 1
    end
    if joystick:isGamepadDown("dpleft") then
        dx1 = -1
    end

    -- Move with joystick (in which case the left joystick takes care of movement and theright of angle)
    local lx = joystick:getAxis(1)
    local ly = joystick:getAxis(2)
    local rx = joystick:getAxis(3)
    local ry = joystick:getAxis(4)
    if math.abs(lx) > movement_threshold then
        dx1 = lx
    end
    if math.abs(ly) > movement_threshold then
        dy1 = ly
    end
    if math.abs(rx) > movement_threshold then
        dx2 = rx
    end
    if math.abs(ry) > movement_threshold then
        dy2 = ry
    end

    return dx1, dy1, dx2, dy2, false
end

return PlayerController
