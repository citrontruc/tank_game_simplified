-- An object to create tanks

local TankFactory = {}
TankFactory.__index = TankFactory

function TankFactory:new()
    local tank_factory = {}
    setmetatable(tank_factory, TankFactory)
    return tank_factory
end

function TankFactory:create_tank()

end


return TankFactory
