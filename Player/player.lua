-- An object to create a player character

local Player = {}
Player.__index = Player

function Player:new()
    local player = {
        player_object = true,
        player_entity = nil,
        player_controller = nil,
        pause = false
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
    local dx1, dy1, dx2, dy2, action, pause = self.player_controller:update(dt)
    if pause == true then
        self.pause = not self.pause
    end
    if self.pause ~= true then
        self.player_entity:update(dt, {dx1 = dx1, dy1 = dy1, dx2 = dx2, dy2 = dy2, action = action})
    end
end

-- draw functions
function Player:draw()
    self.player_entity:draw()
end

return Player
