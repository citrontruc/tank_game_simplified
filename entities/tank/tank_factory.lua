-- An object to create tanks

local GraphicsHandler = require("graphics.graphics_handler")
local ImageItem = require("graphics.image_item")
local Tank = require("entities.tank.tank")

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
function TankFactory:create_tank(position_x, position_y, size_x, size_y, initial_angle, tank_type)
    local tank = Tank:new(position_x, position_y, size_x, size_y, initial_angle)
    local chosen_tank_type = TANK_TYPES[tank_types]
    tank.set_grahics_handler(GraphicsHandler:new(chosen_tank_type.image, chosen_tank_type.image_displacement_angle))
    return tank
end

return TankFactory
