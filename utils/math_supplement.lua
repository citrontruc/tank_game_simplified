-- Contains mathematical functions

local MathSupplement = {}
local THRESHOLD = 10^-5

function MathSupplement.atan(y, x, default_value)
    if default_value == nil then
        default_value = 0
    end
    local angle = default_value
    if x ~= 0 then
        angle = math.atan(y / x)
        if x < 0 then
            if y > 0 then
                angle = angle + math.pi
            else
                angle = angle - math.pi
            end
        end
    else
        if y ~= 0 then
            angle = math.pi / 2 * MathSupplement.sign(y)
        end
    end
    return angle
end

function MathSupplement.normalize_angle(angle)
    return (angle + math.pi) % (2 * math.pi) - math.pi
end

function MathSupplement.shortest_angle_diff(target_angle, current_angle)
    local diff = MathSupplement.normalize_angle(target_angle - current_angle)
    return diff
end

function MathSupplement.sign(number)
    return math.abs(number) < THRESHOLD and 0 or math.abs(number)/number
end

return MathSupplement
