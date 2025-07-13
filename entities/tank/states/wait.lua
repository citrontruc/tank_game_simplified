-- An object to create a state for our enemy
-- In the wait state, the enemy does nothing at all.

local WaitState = {}
local state_name = "wait"

function WaitState:update(dt, tank, args)
    --print(state_name)
    return 0, 0, tank.angle.target, false
end

function WaitState:update_state(tank, target_position)
    if tank:get_distance_from_point(target_position) < tank.state_specific_variables[state_name].distance_threshold ^ 2 then
        return "chase", true
    end
    if tank.state_timer > tank.state_specific_variables[state_name].max_time then
        return "idle", true
    end
    return state_name
end

return WaitState
