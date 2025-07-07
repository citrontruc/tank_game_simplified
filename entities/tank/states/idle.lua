-- An object to create a state for our enemy
-- In the idle state, the enemy chooses a direction at random and walks in that direction.

local IdleState = {}
local state_name = "idle"

function IdleState:update(dt, tank, args)
    print(state_name)
    local angle = tank.angle.target
    if tank.state_specific_variables[state_name].y ~= 0 or tank.state_specific_variables[state_name].x ~= 0 then
        angle = math.atan2(tank.state_specific_variables[state_name].y, tank.state_specific_variables[state_name].x)
    end
    return tank.state_specific_variables[state_name].x, tank.state_specific_variables[state_name].y, angle
end

function IdleState:update_state(tank, target_position)
    if tank:get_distance_from_point(target_position) < tank.state_specific_variables[state_name].distance_threshold ^ 2 then
        tank.state_specific_variables[state_name].x, tank.state_specific_variables[state_name].y = self.update_direction()
        return "chase", true
    end
    if tank.state_timer > tank.state_specific_variables[state_name].max_time then
        tank.state_specific_variables[state_name].x, tank.state_specific_variables[state_name].y = self.update_direction()
        return "wait", true
    end
    return state_name
end

function IdleState:update_direction()
    local value = {0, 1}
    local sign = {-1, 1}
    local random_value = value[math.random(#value)]
    local random_sign = sign[math.random(#sign)]
    return random_value * random_sign, (1 - random_value) * random_sign
end

return IdleState
