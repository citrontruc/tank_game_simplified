-- An object to create a tank

local ChaseState = require("entities.tank.states.chase")
local DeadState = require("entities.tank.states.dead")
local IdleState = require("entities.tank.states.idle")
local PlayerState = require("entities.tank.states.player")
local WaitState = require("entities.tank.states.wait")

local Tank = {}
Tank.__index = Tank

function Tank:new(
    lives,
    position_x,
    position_y,
    size_x,
    size_y,
    initial_angle,
    speed,
    rotation_speed,
    initial_state,
    missile_type)
    local tank = {
        -- Descriptive variables
        lives = lives,
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
            movement = speed,
            rotation = rotation_speed
        },
        action_timer = 0,
        missile_type = missile_type,
        -- State variables
        state_dict = {
            chase = ChaseState,
            dead = DeadState,
            idle = IdleState,
            player = PlayerState,
            wait = WaitState
        },
        state_specific_variables = {
            player = {},
            chase = {},
            wait = {},
            idle = {}
        },
        state_timer = 0,
        -- Collsion variables
        circle_list = {},
        -- Graphics variable
        graphics_handler = nil
    }
    tank.current_state = tank.state_dict[initial_state]
    setmetatable(tank, Tank)
    tank:initialize_collision_circles()
    return tank
end

-- We hve a method to initialize collision circles used to evaluate collisions.
function Tank:initialize_collision_circles()
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

--Setter
function Tank:set_missile_factory(missile_factory)
    self.missile_factory = missile_factory
end

function Tank:set_graphics_handler(graphics_handler)
    self.graphics_handler = graphics_handler
end

function Tank:set_state_specific_variables(state_name, variable)
    self.state_specific_variables[state_name] = variable
end

-- Update function
function Tank:update(dt, args)
    local dx1, dy1, angle, action = self.current_state:update(dt, self, args)
    self:update_angle(dt, angle)
    self:update_position(dt, dx1, dy1)
    if action ~= nil then
        self:do_action(dt, action)
    end
    self:update_state(args)
    self.state_timer = self.state_timer + dt
    self.action_timer = self.action_timer + dt
end

-- We have separate updates for position and actions
function Tank:update_position(dt, dx1, dy1)
    self.position.x = self.position.x + self.speed.movement * dx1 * dt
    self.position.y = self.position.y + self.speed.movement * dy1 * dt
    self:check_border_screen()
end

function Tank:update_angle(dt, angle)
    self.angle.target = angle
    local diff = self:shortest_angle_diff()
    local max_step = self.speed.rotation * dt

    if math.abs(diff) < max_step then
        self.angle.current = self.angle.target -- snap to target
    else
        self.angle.current = self.angle.current + max_step * (diff > 0 and 1 or -1)
    end
end

function Tank:shortest_angle_diff()
    local diff = (self.angle.target - self.angle.current + math.pi) % (2 * math.pi) - math.pi
    return diff
end

function Tank:do_action(dt, action)
    self.current_state:do_action(dt, self, action)
end

-- State related functions
function Tank:update_state(args)
    local state_name, reset_timer = self.current_state:update_state(self, args)
    if reset_timer == true then
        self.state_timer = 0
    end
    if self.lives == 0 then
        state_name = "dead"
    end
    self.current_state = self.state_dict[state_name]
end

-- Check position
function Tank:get_distance_from_point(target_position)
    return (self.position.x - target_position.x) ^ 2 + (self.position.y - target_position.y) ^ 2
end

function Tank:check_border_screen()
    local max_size = math.max(self.size.x, self.size.y)
    self.position.x = math.min(math.max(max_size / 2, self.position.x), love.graphics.getWidth() - max_size / 2)
    self.position.y = math.min(math.max(max_size / 2, self.position.y), love.graphics.getHeight() - max_size / 2)
end

-- Draw methods
function Tank:draw()
    self.graphics_handler:draw(self.position.x, self.position.y, self.size.x, self.size.y, self.angle.current)
    self.graphics_handler:draw_hitbox(self.position.x, self.position.y, self.angle.current, self.circle_list)
end

return Tank
