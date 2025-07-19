-- Contains mathematical functions

local MathSupplement = {}
local THRESHOLD = 10^-5

-- angles
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

function MathSupplement.get_distance_from_point(position_1, position_2)
    return (position_1.x - position_2.x) ^ 2 + (position_1.y - position_2.y) ^ 2
end

-- circles
function MathSupplement.check_intersection_cicles(circle_1, circle_2)
    local dx = circle_1.x - circle_2.x
    local dy = circle_1.y - circle_2.y
    return dx^2 + dy^2 < (circle_1.r + circle_2.r)^2
end

function MathSupplement.sign(number)
    return math.abs(number) < THRESHOLD and 0 or math.abs(number)/number
end

return MathSupplement
