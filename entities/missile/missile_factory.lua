-- An object to create missile

--Imports
local GraphicsHandler = require("graphics.graphics_handler")
local ImageItem = require("graphics.image_item")
local Missile = require("entities.missile.missile")

-- Missile behaviours
local ChaseState = require("entities.missile.states.chase")
local NormalState = require("entities.missile.states.normal")

-- Global variables
-- Note: Colours of bullets depend on bullet states
local MISSILE_TYPES = {
    bouncing = {
        image = ImageItem:new("assets/Topdown Tanks Redux/PNG/Default size/bulletGreen1_outline.png"),
        image_displacement_angle = math.rad(90)
    },
    chase = {
        image = ImageItem:new("assets/Topdown Tanks Redux/PNG/Default size/bulletRed1_outline.png"),
        image_displacement_angle = math.rad(90)
    },
    normal = {
        image = ImageItem:new("assets/Topdown Tanks Redux/PNG/Default size/bulletBlue1_outline.png"),
        image_displacement_angle = math.rad(90)
    },
    triple = {
        image = ImageItem:new("assets/Topdown Tanks Redux/PNG/Default size/bulletSand1_outline.png"),
        image_displacement_angle = math.rad(90)
    }
}

local DEFAULT_MISSILE_STATE_VARIABLES = {
    bouncing = {
        behaviour = NormalState,
        health = 3,
        speed = {
            movement = 400,
            rotation = 20
        },
        size = {
            x = 15,
            y = 25
        }
    },
    chase = {
        behaviour = ChaseState,
        health = 1,
        max_time_survival = 5,
        speed = {
            movement = 200,
            rotation = 20
        },
        size = {
            x = 15,
            y = 25
        }
    },
    normal = {
        behaviour = NormalState,
        health = 1,
        speed = {
            movement = 400,
            rotation = 0
        },
        size = {
            x = 15,
            y = 25
        }
    },
    triple = {
        behaviour = NormalState,
        angle_displacement = math.pi / 4,
        health = 1,
        speed = {
            movement = 400,
            rotation = 0
        },
        size = {
            x = 10,
            y = 20
        }
    }
}

local MissileFactory = {}
MissileFactory.__index = MissileFactory

function MissileFactory:new(entity_handler)
    local missile_factory = {
        entity_handler = entity_handler
    }
    setmetatable(missile_factory, MissileFactory)
    return missile_factory
end

-- We need an initial state and information if the tank is in
function MissileFactory:new_missile(
    position_x,
    position_y,
    initial_angle,
    missile_type,
    player)
    local missile_characteristics = DEFAULT_MISSILE_STATE_VARIABLES[missile_type]
    local chosen_missile_type = MISSILE_TYPES[missile_type]
    local missile = Missile:new(missile_characteristics.health, position_x, position_y, missile_characteristics.size.x, missile_characteristics.size.y, initial_angle, missile_characteristics.speed.movement, missile_characteristics.speed.rotation, missile_characteristics.behaviour, player)
    local graphics_handler =
        GraphicsHandler:new(chosen_missile_type.image, chosen_missile_type.image_displacement_angle)
    missile:set_graphics_handler(graphics_handler)
    self:set_missile_state_specific_variables(missile, DEFAULT_MISSILE_STATE_VARIABLES)
    self.entity_handler:assign(missile, player)
    -- return missile
end

function MissileFactory:set_missile_state_specific_variables(missile, missile_specific_variables)
    if missile_specific_variables == nil then
        missile_specific_variables = DEFAULT_MISSILE_STATE_VARIABLES
    end
    for state_name, state_variables in pairs(missile_specific_variables) do
        missile:set_state_specific_variables(state_name, state_variables)
    end
end

return MissileFactory
