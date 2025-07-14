-- An object to create a state for our enemy
-- In the idle state, the enemy chooses a direction at random and walks in that direction.

local MathSupplement = require("utils.math_supplement")

local IdleState = {}
local state_name = "idle"

function IdleState:update(dt, tank, args)
    --print(state_name)
    local action = false
    self:check_border_screen(tank)
    local angle = MathSupplement.atan(tank.state_specific_variables[state_name].y, tank.state_specific_variables[state_name].x)
    return tank.state_specific_variables[state_name].x, tank.state_specific_variables[state_name].y, angle, action
end

function IdleState:update_state(tank, target_position)
    if tank:get_distance_from_point(target_position) < tank.state_specific_variables[state_name].distance_threshold ^ 2 then
        tank.state_specific_variables[state_name].x, tank.state_specific_variables[state_name].y =
            self.update_direction()
        return "chase", true
    end
    if tank.state_timer > tank.state_specific_variables[state_name].max_time then
        tank.state_specific_variables[state_name].x, tank.state_specific_variables[state_name].y =
            self.update_direction()
        return "wait", true
    end
    return state_name
end

function IdleState.update_direction()
    local value = {0, 1}
    local sign = {-1, 1}
    local random_value = value[math.random(#value)]
    local random_sign = sign[math.random(#sign)]
    return random_value * random_sign, (1 - random_value) * random_sign
end

function IdleState:check_border_screen(tank)
    local max_size = math.max(tank.size.x, tank.size.y)
    if tank.position.x == max_size / 2 or tank.position.x == (love.graphics.getWidth() - max_size / 2) then
        tank.state_specific_variables[state_name].x = - tank.state_specific_variables[state_name].x
    end
    if tank.position.y == max_size / 2 or tank.position.y == (love.graphics.getHeight() - max_size / 2) then
        tank.state_specific_variables[state_name].y = - tank.state_specific_variables[state_name].y
    end
end

return IdleState
