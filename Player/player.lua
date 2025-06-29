-- An object to create a player character

local Player = {}
Player.__index = Player


function Player:new(initial_x, initial_y, size_x, size_y, initial_angle, player_rotation_speed, initial_image_angle)
    local player = {
        player_object = true,
        health = initial_health,
        position = {
            x = initial_x,
            y = initial_y
        },
        size = {
            x,
            y
        },
        angle = {
            current = initial_angle,
            target = initial_angle,
        },
        speed = {
            movement = speed,
            rotation = rotation_speed
        },
        player_entity = nil,
        player_controller = nil
    }
    setmetatable(player, Player)
    return player
end

--Setter
function Player:set_controller(player_controller)
    self.player_controller = player_controller
end

function Player:set_entity(player_entity)
    self.player_entity = player_entity
end

function Player:set_control_type(control_type, joystick)
    if self.player_controller ~= nil then
        self.player_controller:set_control_type(control_type, joystick)
    end
end

--update functions
function Player:update(dt)
    local player_input = self:get_player_input(dt)
    self.player_entity:update(dt, player_input)
end

function Player:get_player_input(dt)
    self.player_controller:update(dt)
end

-- draw functions
function Player:draw()
    self.player_entity:draw()
end

return Player