-- An object to create a tank

local Tank = {}
Tank.__index = Tank

function Tank:new(position_x, position_y, size_x, size_y, initial_angle)
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
        }
    }
    setmetatable(tank, Tank)
    return Tank
end

--Setter
function Tank:set_grahics_handler(self, graphics_handler)
    self.graphics_handler = graphics_handler
end

function Tank:update(dt)
end

function Tank:update_state()
end

function Tank:check_border_screen()
    self.position.x = math.min(math.max(self.size.x / 2, self.position.x), love.graphics.getWidth() - self.size.x / 2)
    self.position.y = math.min(math.max(self.size.y / 2, self.position.y), love.graphics.getHeight() - self.size.y / 2)
end

function Tank:draw()
    self.graphics_handler:draw(self.position.x, self.position.y, self.size.x, self.size.y, self.angle.current)
end

return Tank
