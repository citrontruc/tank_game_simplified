-- An object to create a state for our enemy
-- In the chase state, the enemy walks towards the player.

local ChaseState = {}
ChaseState.__index = ChaseState


function ChaseState:new(object)
    local chase_state = {object = object}
    setmetatable(chase_state, ChaseState)
    return chase_state
end

-- Helper function for angles
function ChaseState:shortest_angle_diff()
    local diff = (self.object.angle - self.object.current_angle + math.pi) % (2 * math.pi) - math.pi
    return diff
end

function ChaseState:get_angle_target()
    self.object.angle = math.atan2(self.object.target_y - self.object.y, self.object.target_x - self.object.x)
end

function ChaseState:update_angle(dt)
    local diff = self:shortest_angle_diff()
    local max_step = self.object.rotation_speed * dt

    if math.abs(diff) < max_step then
        self.object.current_angle = self.object.angle -- snap to target
    else
        self.object.current_angle = self.object.current_angle + max_step * (diff > 0 and 1 or -1)
    end
end

function ChaseState:update(dt)
    self.object.x = self.object.x + self.object.speed_run * math.cos(self.object.angle) * dt
    self.object.y = self.object.y + self.object.speed_run * math.sin(self.object.angle) * dt
    self:get_angle_target()
    self:update_angle(dt) 
    return true
end

return ChaseState
