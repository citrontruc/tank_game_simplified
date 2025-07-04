-- An Object to initialize our player object

-- Imports
local Player = require("player.player")
local PlayerController = require("player.player_controller")

local PlayerFactory = {}
PlayerFactory.__index = PlayerFactory

function PlayerFactory:new()
    local player_factory = {}
    setmetatable(player_factory, PlayerFactory)
    return player_factory
end

function PlayerFactory:new_player(initial_health)
    local player = Player:new(initial_health)
    local player_controller = PlayerController:new()
    player:set_controller(player_controller)
    return player
end

return PlayerFactory
