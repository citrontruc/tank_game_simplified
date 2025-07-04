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
function PlayerState:shortest_angle_diff()
    local diff = (self.angle.target - self.angle.current + math.pi) % (2 * math.pi) - math.pi
    return diff
end

function PlayerState:update_angle(dt)
    local diff = self:shortest_angle_diff()
    local max_step = self.speed.rotation * dt

    if math.abs(diff) < max_step then
        self.angle.current = self.angle.target -- snap to target
    else
        self.angle.current = self.angle.current + max_step * (diff > 0 and 1 or -1)
    end
end

function ChaseState:aim_for_target(target_position)
    self.object.angle = math.atan2(target_position.y - self.position.y, target_position.x - self.position.x)
end

function ChaseState:update(dt, target_position)
    self.position.x = self.position.x + self.speed.movement * math.cos(self.angle.target) * dt
    self.position.y = self.position.y + self.speed.movement * math.sin(self.angle.target) * dt
    self:aim_for_target(target_position)
    self:update_angle(dt)
    self:check_border_screen()
end

return ChaseState
