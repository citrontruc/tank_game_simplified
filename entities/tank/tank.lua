-- An object to create a tank

local PlayerState = require("entities.tank.states.player")

local Tank = {}
Tank.__index = Tank

function Tank:new(position_x, position_y, size_x, size_y, initial_angle, speed, rotation_speed, initial_state)
    local tank = {
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
        state_dict = {
            player = PlayerState
        },
        graphics_handler = nil
    }
    tank.current_state = tank.state_dict[initial_state]
    setmetatable(tank, Tank)
    return tank
end

--Setter
function Tank:set_graphics_handler(graphics_handler)
    self.graphics_handler = graphics_handler
end

function Tank:update(dt, dx1, dy1, dx2, dy2, action)
    self.current_state:update(dt, self, dx1, dy1, dx2, dy2, action)
    self:update_state()
end

function Tank:update_state()
    self.current_state:update_state(self)
end

function Tank:check_border_screen()
    self.position.x = math.min(math.max(self.size.x / 2, self.position.x), love.graphics.getWidth() - self.size.x / 2)
    self.position.y = math.min(math.max(self.size.y / 2, self.position.y), love.graphics.getHeight() - self.size.y / 2)
end

function Tank:draw()
    self.graphics_handler:draw(self.position.x, self.position.y, self.size.x, self.size.y, self.angle.current)
end

return Tank
