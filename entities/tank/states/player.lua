-- An object to create a state for our enemy
-- In the chase state, the enemy walks towards the player.

local PlayerState = {}

-- helpful functions
function PlayerState:shortest_angle_diff(tank)
    local diff = (tank.angle.target - tank.angle.current + math.pi) % (2 * math.pi) - math.pi
    return diff
end

function PlayerState:update_angle(dt, tank)
    local diff = PlayerState:shortest_angle_diff(tank)
    local max_step = tank.speed.rotation * dt

    if math.abs(diff) < max_step then
        tank.angle.current = tank.angle.target -- snap to target
    else
        tank.angle.current = tank.angle.current + max_step * (diff > 0 and 1 or -1)
    end
end

--- We have three possible control types : absolute, tank control and twin stick
function PlayerState:update_position(dt, tank, dx1, dy1, dx2, dy2)
    PlayerState:move_absolute_control(dt, tank, dx1, dy1, dx2, dy2)
    tank:check_border_screen()
end

function PlayerState:move_absolute_control(dt, tank, dx1, dy1, dx2, dy2)
    if dx1~=0 or dy1~=0 then
        tank.angle.target = math.atan2(dy1, dx1)
    end
    tank.position.x = tank.position.x + dx1 * tank.speed.movement * dt
    tank.position.y = tank.position.y + dy1 * tank.speed.movement * dt
    PlayerState:update_angle(dt, tank)
end

function PlayerState:move_tank_control(dt, tank, dx1, dy1, dx2, dy2)
    tank.angle.target = tank.angle.target + tank.speed.rotation * dx1 * dt
    tank.angle.current = tank.angle.target
    tank.position.x = tank.position.x + dy1 * tank.speed.movement * math.cos(tank.angle.target) * dt
    tank.position.y = tank.position.y + dy1 * tank.speed.movement * math.sin(tank.angle.target) * dt
end

function PlayerState:move_twin_stick(dt, tank, dx1, dy1, dx2, dy2)
    if dx2 ~= 0 or dy2 ~= 0 then
        tank.angle.target = math.atan2(dy2, dx2)
    end
    tank.angle.current = tank.angle.target
    tank.position.x = tank.position.x + dx1 * tank.speed.movement * dt
    tank.position.y = tank.position.y + dy1 * tank.speed.movement * dt
end

---
function PlayerState:do_action(dt, action)
end

return PlayerState
