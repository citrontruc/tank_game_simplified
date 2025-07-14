-- A state for our missiles.
-- The missile just moves in a straight line.
local MathSupplement = require("utils.math_supplement")

local NormalState = {}

function NormalState:update(dt, missile, args)
    --return MathSupplement.sign(math.cos(missile.angle.target)), MathSupplement.sign(math.sin(missile.angle.target)), missile.angle.target
    return math.cos(missile.angle.target), math.sin(missile.angle.target), missile.angle.target
end

return NormalState
