-- An object to create tanks

--Imports
local MissileFactory = require("entities.missile.missile_factory")
local GraphicsHandler = require("graphics.graphics_handler")
local ImageItem = require("graphics.image_item")
local Tank = require("entities.tank.tank")

-- Global variables
local TANK_TYPES = {
    blue = {
        image = ImageItem:new("assets/Topdown Tanks Redux/PNG/Default size/tank_blue.png"),
        image_displacement_angle = math.rad(90)
    },
    red = {
        image = ImageItem:new("assets/Topdown Tanks Redux/PNG/Default size/tank_red.png"),
        image_displacement_angle = math.rad(90)
    }
}

local DEFAULT_TANK_STATE_VARIABLES = {
    player = {
        action_cooldown = .5
    },
    chase = {
        distance_threshold = 500,
        action_cooldown = 2
    },
    idle = {
        distance_threshold = 400,
        max_time = 1,
        x = 0,
        y = 0
    },
    wait = {
        distance_threshold = 400,
        max_time = .5
    }
}

local TankFactory = {}
TankFactory.__index = TankFactory

function TankFactory:new(entity_handler)
    local tank_factory = {
        entity_handler = entity_handler,
        missile_factory = MissileFactory:new(entity_handler)
    }
    setmetatable(tank_factory, TankFactory)
    return tank_factory
end

-- We need an initial state and information if the tank is in
function TankFactory:new_tank(
    initial_health,
    position_x,
    position_y,
    size_x,
    size_y,
    initial_angle,
    speed,
    rotation_speed,
    tank_type,
    initial_state,
    missile_type)
    local player = false
    if initial_state == "player" then
        player = true
    end
    local tank =
        Tank:new(
            initial_health,
            position_x,
            position_y,
            size_x,
            size_y,
            initial_angle,
            speed,
            rotation_speed,
            initial_state,
            missile_type,
            player
        )
    local chosen_tank_type = TANK_TYPES[tank_type]
    local graphics_handler = GraphicsHandler:new(chosen_tank_type.image, chosen_tank_type.image_displacement_angle)
    tank:set_graphics_handler(graphics_handler)
    tank:set_missile_factory(self.missile_factory)
    self:set_tank_state_specific_variables(tank)
    return tank
end

function TankFactory:set_tank_state_specific_variables(tank, tank_specific_variables)
    if tank_specific_variables == nil then
        tank_specific_variables = DEFAULT_TANK_STATE_VARIABLES
    end
    for state_name, state_variables in pairs(tank_specific_variables) do
        tank:set_state_specific_variables(state_name, state_variables)
    end
end

return TankFactory
