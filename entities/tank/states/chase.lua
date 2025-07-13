-- An object to create a state for our enemy
-- In the chase state, the enemy walks towards the player.

local ChaseState = {}
local state_name = "chase"

function ChaseState:aim_for_target(target_position, tank_position)
    local angle = math.atan2(target_position.y - tank_position.y, target_position.x - tank_position.x)
    return angle
end

function ChaseState:update(dt, tank, target_position)
    --print(state_name)
    local action = false
    local angle = self:aim_for_target(target_position, tank.position)
    if tank.action_timer > tank.state_specific_variables[state_name].action_cooldown then
        action = true
        tank.action_timer = 0
    end
    return math.cos(angle), math.sin(angle), angle, action
end

function ChaseState:update_state(tank, target_position)
    if tank:get_distance_from_point(target_position) > tank.state_specific_variables[state_name].distance_threshold ^ 2 then
        return "wait", true
    end
    return state_name
end

return ChaseState
