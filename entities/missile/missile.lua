-- An object to create missiles

local MathSupplement = require("utils.math_supplement")

local Missile = {}
Missile.__index = Missile

function Missile:new(initial_health, position_x, position_y, size_x, size_y, initial_angle, movement_speed,
                     rotation_speed, initial_state, player)
    local missile = {
        -- Descriptive variables
        player = player, -- Check if the missile belongs to the player
        health = initial_health,
        position = {
            x = position_x,
            y = position_y
        },
        size = {
            x = size_x,
            y = size_y
        },
        angle = {
            current = initial_angle,
            target = initial_angle
        },
        speed = {
            movement = movement_speed,
            rotation = rotation_speed
        },
        -- State variables
        state_specific_variables = {
            bouncing = {},
            chase = {},
            normal = {},
            triple = {}
        },
        behaviour = initial_state,
        state_timer = 0,
        circle_list = {}

    }
    setmetatable(missile, Missile)
    missile:initialize_collision_circles()
    return missile
end

-- We hve a method to initialize collision circles used to evaluate collisions.
function Missile:initialize_collision_circles()
    self.circle_list = {}
    local biggest_size = math.max(self.size.x, self.size.y)
    local smallest_size = math.min(self.size.x, self.size.y)
    local num_circles = math.floor(biggest_size / smallest_size + .5)
    if (num_circles % 2 ~= 0) then
        num_circles = num_circles + 1
    end
    -- We only store the displacement from the position.x and position.y
    table.insert(
        self.circle_list,
        {
            x = 0,
            y = 0,
            r = smallest_size / 2
        }
    )
    for i = 1, math.floor(num_circles / 2) do
        table.insert(
            self.circle_list,
            {
                x = i * (biggest_size - self.size.x) / num_circles,
                y = i * (biggest_size - self.size.y) / num_circles,
                r = smallest_size / 2
            }
        )
        table.insert(
            self.circle_list,
            {
                x = -i * (biggest_size - self.size.x) / num_circles,
                y = -i * (biggest_size - self.size.y) / num_circles,
                r = smallest_size / 2
            }
        )
    end
end

-- Setter methods
function Missile:set_graphics_handler(graphics_handler)
    self.graphics_handler = graphics_handler
end

function Missile:set_state_specific_variables(state_name, variable)
    self.state_specific_variables[state_name] = variable
end

-- Update functions
function Missile:update(dt, args)
    local dx1, dy1, angle = self.behaviour:update(dt, self, args)
    self:update_angle(dt, angle)
    self:update_position(dt, dx1, dy1)
    self.state_timer = self.state_timer + dt
    print("missile " ..self.angle.current .. ", " .. self.angle.target)
end

-- We have separate updates for position and actions
function Missile:update_position(dt, dx1, dy1)
    self.position.x = self.position.x + self.speed.movement * dx1 * dt
    self.position.y = self.position.y + self.speed.movement * dy1 * dt
    self:check_border_screen()
end

function Missile:update_angle(dt, angle)
    self.angle.target = MathSupplement.normalize_angle(angle)
    self.angle.current = MathSupplement.normalize_angle(self.angle.current)
    local diff = MathSupplement.shortest_angle_diff(self.angle.target, self.angle.current)
    local max_step = self.speed.rotation * dt

    if math.abs(diff) < max_step then
        self.angle.current = self.angle.target -- snap to target
    else
        self.angle.current = self.angle.current + max_step * MathSupplement.sign(diff)
    end
end

function Missile:check_border_screen()
    local max_size = math.max(self.size.x, self.size.y)
    local x = math.min(math.max(max_size / 2, self.position.x), love.graphics.getWidth() - max_size / 2)
    local y = math.min(math.max(max_size / 2, self.position.y), love.graphics.getHeight() - max_size / 2)
    if self.position.x ~= x then
        self.health = self.health - 1
        self.position.x = x
        self.angle.target = self.angle.target + math.pi
    end
    if self.position.y ~= y then
        self.health = self.health - 1
        self.position.y = y
        self.angle.target = -self.angle.target
    end
end

-- Draw methods
function Missile:draw()
    self.graphics_handler:draw(self.position.x, self.position.y, self.size.x, self.size.y, self.angle.current)
    --self.graphics_handler:draw_hitbox(self.position.x, self.position.y, self.angle.current, self.circle_list)
end

return Missile
