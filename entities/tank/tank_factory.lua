-- An object to create tanks

--Imports
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

local TankFactory = {}
TankFactory.__index = TankFactory

function TankFactory:new()
    local tank_factory = {}
    setmetatable(tank_factory, TankFactory)
    return tank_factory
end

-- We need an initial state and information if the tank is in
function TankFactory:new_tank(position_x, position_y, size_x, size_y, initial_angle, speed, rotation_speed, tank_type, initial_state)
    local tank = Tank:new(position_x, position_y, size_x, size_y, initial_angle, speed, rotation_speed, initial_state)
    local chosen_tank_type = TANK_TYPES[tank_type]
    local graphics_handler = GraphicsHandler:new(chosen_tank_type.image, chosen_tank_type.image_displacement_angle)
    tank:set_graphics_handler(graphics_handler)
    return tank
end

return TankFactory
