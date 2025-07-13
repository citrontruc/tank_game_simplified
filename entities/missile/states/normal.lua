-- A state for our missiles.
-- The missile just moves in a straight line.

local NormalState = {}

function NormalState:update(dt, missile, args)
    return sign(math.cos(missile.angle.target)), sign(math.sin(missile.angle.target)), missile.angle.target
end

function sign(number)
    return math.abs(number) < 0.001 and 0 or math.abs(number)/number
end

return NormalState
