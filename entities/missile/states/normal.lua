-- A state for our missiles.
-- The missile just moves in a straight line.

local NormalState = {}

function NormalState:update(dt, missile, args)
    return math.cos(missile.angle.target), math.sin(missile.angle.target), missile.angle.target
end

return NormalState
