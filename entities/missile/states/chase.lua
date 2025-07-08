-- A state for our missiles.
-- The missile follows its target.

local ChaseState = {}

function ChaseState:aim_for_target(target_position, missile_position)
    local angle = math.atan2(target_position.y - missile_position.y, target_position.x - missile_position.x)
    return angle
end

function ChaseState:update(dt, missile, target_position)
    local angle = self:aim_for_target(target_position, missile.position)
    if missile.state_timer > missile.state_specific_variables.chase.max_time_survival then
        missile.health = missile.health - 1
    end
    return math.cos(angle), math.sin(angle), angle
end

return ChaseState
