-- An object to create a state for our enemy
-- In the chase state, the enemy walks towards the player.

local PlayerState = {}
PlayerState.__index = PlayerState


function PlayerState:new(object)
    local player_state = {object = object}
    setmetatable(player_state, PlayerState)
    return player_state
end

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

--- We have three possible control types : absolute, tank control and twin stick
function PlayerState:update(dt, dx1, dy1, dx2, dy2, action)
    self:move_absolute_control(dt, dx1, dy1, dx2, dy2, action)
    self:check_wall()
end

function PlayerState:move_absolute_control(dt, dx1, dy1, dx2, dy2, action)
    self.angle.target = math.atan2(dx1, dy1)
    self.position.x = self.position.x + dx1 * self.speed.movement * math.cos(self.angle.target) * dt
    self.position.y = self.position.y + dy1 * self.speed.movement * math.sin(self.angle.target) * dt
    self:update_angle(dt)
end


function PlayerState:move_tank_control(dt, dx1, dy1, dx2, dy2, action)
    self.angle.target = self.speed.rotation * dx1 * dt
    self.angle.current =self.angle.target
    self.position.x = self.position.x + dy1 * self.speed.movement * math.cos(self.angle.target) * dt
    self.position.y = self.position.y + dy1 * self.speed.movement * math.sin(self.angle.target) * dt
end

function PlayerState:move_twin_stick(dt, dx1, dy1, dx2, dy2, action)
    math.angle.target = math.atan2(dx1, dy1)
    self.angle.current = self.angle.target
    elf.position.x = self.position.x + dx1 * self.speed.movement * math.cos(self.angle.target) * dt
    self.position.y = self.position.y + dy1 * self.speed.movement * math.sin(self.angle.target) * dt
end

return PlayerState
