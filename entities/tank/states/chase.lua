-- An object to create a state for our enemy
-- In the chase state, the enemy walks towards the player.

local ChaseState = {}


function ChaseState:aim_for_target(target_position, tank_position)
    local angle = math.atan2(target_position.y - tank_position.y, target_position.x - tank_position.x)
    return angle
end

function ChaseState:update(dt, tank, target_position)
    local angle = tank:aim_for_target(target_position, tank.position)
    return math.cos(angle), math.sin(angle), angle
end

function ChaseState:update_state(tank)
end

return ChaseState
