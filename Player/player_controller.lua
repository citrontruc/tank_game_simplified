-- A class to control our player character

local PlayerController = {}
PlayerController.__index = PlayerController
local movement_threshold = 0.1

--creation
function PlayerController:new(control_type, speed)
    local object = {
        control_type = control_type
    }
    setmetatable(object, PlayerController)
    return object
end

--setter
function PlayerController:set_control_type(control_type, joystick)
    self.control_type = control_type
end

--update
function PlayerController:update(dt, x, y, angle, size_x, size_y, joystick)
    local move_function = {
        keyboard = PlayerController.move_with_keyboard,
        controller = PlayerController.move_with_controller
    }

    chosen_move_function = move_function[self.control_type]
    dx, dy, angle = chosen_move_function(self, dt, x, y, angle, joystick)
    dx, dy = self:check_position(x, y, dx, dy, size_x, size_y)
    return dx, dy, angle
end

--movement functions
--movement with keyboard
function PlayerController:move_with_keyboard(dt, x, y, angle, joystick)
    local dx = 0
    local dy = 0
    local move_x = 0
    local move_y = 0
    if love.keyboard.isDown("down") then
        dy = self.speed * dt
        move_y = 1
    end
    if love.keyboard.isDown("up") then
        dy = -self.speed * dt
        move_y = -1
    end
    if love.keyboard.isDown("right") then
        dx = self.speed * dt
        move_x = 1
    end
    if love.keyboard.isDown("left") then
        dx = -self.speed * dt
        move_x = -1
    end

    if move_x ~= 0 or move_y ~= 0 then
        angle = math.atan2(move_y, move_x)
    end
    return dx, dy, angle
end

-- movement with controller
function PlayerController:move_with_controller(dt, x, y, angle, joystick)
    local dx = 0
    local dy = 0
    local move_x = 0
    local move_y = 0
    if not joystick then return x, y, angle end
    -- Move with dpad (in which case the angle follows the tank.)
    if joystick:isGamepadDown("dpdown") then
        dy = self.speed * dt
        move_y = 1
    end
    if joystick:isGamepadDown("dpup")then
        dy = -self.speed * dt
        move_y = -1
    end
    if joystick:isGamepadDown("dpright") then
        dx = self.speed * dt
        move_x = 1
    end
    if joystick:isGamepadDown("dpleft")then
        dx = -self.speed * dt
        move_x = -1
    end

    if move_x ~= 0 or move_y ~= 0 then
        angle = math.atan2(move_y, move_x)
    end

    -- Move with joystick (in which case the left joystick takes care of movement and theright of angle)
    local lx = joystick:getAxis(1)
    local ly = joystick:getAxis(2)
    local rx = joystick:getAxis(3)
    local ry = joystick:getAxis(4)
    if math.abs(lx) > movement_threshold then
        dx = self.speed * dt * lx
    end
    if math.abs(ly) > movement_threshold then
        dy = self.speed * dt * ly
    end
    if math.abs(rx) > movement_threshold or math.abs(ry) >= movement_threshold then
        angle = math.atan2(ry, rx)
    end

    return dx, dy, angle
end

-- Check that player stays on screen
function PlayerController:check_position(x, y, dx, dy, size_x, size_y)
    new_x = math.min(math.max(size_x/2, x + dx), love.graphics.getWidth() - size_x/2)
    new_y = math.min(math.max(size_y/2, y + dy), love.graphics.getHeight() - size_y/2)
    dx = new_x - x
    dy = new_y - y
    return dx, dy
end

return PlayerController
