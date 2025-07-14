-- An object to create a state for our enemy
-- In the chase state, the enemy walks towards the player.

local PlayerState = {}
local state_name = "player"

--- We have three possible control types : absolute, tank control and twin stick
function PlayerState:update(dt, tank, player_input)
    local dx1_tank, dy1_tank, angle_tank =
        PlayerState:move_absolute_control(
            dt,
            tank,
            player_input.dx1,
            player_input.dy1,
            player_input.dx2,
            player_input.dy2
        )
    local action = false
    if (tank.action_timer > tank.state_specific_variables[state_name].action_cooldown) and player_input.action then
        action = true
        tank.action_timer = 0
    end
    return dx1_tank, dy1_tank, angle_tank, action
end

function PlayerState:move_absolute_control(dt, tank, dx1, dy1, dx2, dy2)
    local angle = tank.angle.target
    if dx1 ~= 0 or dy1 ~= 0 then
        angle = math.atan(dy1 / dx1)
        if dx1 < 0 then
            if dy1 < 0 then
                angle = angle + math.pi
            else
                angle = angle - math.pi
            end
        end
    end
    return dx1, dy1, angle
end

function PlayerState:move_tank_control(dt, tank, dx1, dy1, dx2, dy2)
    local angle = tank.angle.target + tank.speed.rotation * dx1 * dt
    return -dy1 * math.cos(tank.angle.target), -dy1 * math.sin(tank.angle.target), angle
end

function PlayerState:move_twin_stick(dt, tank, dx1, dy1, dx2, dy2)
    local angle = tank.angle.target
    if dx2 ~= 0 or dy2 ~= 0 then
        angle = math.atan(dy2 / dx2)
        if dx2 < 0 then
            if dy2 < 0 then
                angle = angle + math.pi
            else
                angle = angle - math.pi
            end
        end
    end
    return dx1, dy1, angle
end

function PlayerState:update_state()
    return state_name
end

return PlayerState
