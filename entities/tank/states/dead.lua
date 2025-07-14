-- An object to create a state for our enemy
-- In the dead state, the enemy does nothing at all and stays dead.

local DeadState = {}
local state_name = "dead"

function DeadState:update(dt, tank, args)
    return 0, 0, tank.angle.target
end

function DeadState:update_state(tank, target_position)
    return state_name
end

return DeadState
