-- Handles the drawing of images

local GraphicsHandler = {}
GraphicsHandler.__index = GraphicsHandler  -- set up proper metatable for OOP

--creation
function PlayerGraphicsHandler:new(image_item)
    local object = {
        image_item = image_item
    }
    setmetatable(object, GraphicsHandler)
    return object
end

function GraphicsHandler:update()
end

function GraphicsHandler:draw(x, y, rotation, size_x, size_y, alpha)
    if (alpha == nil) then 
        alpha = 1
    end
    love.graphics.setColor(1, 1, 1, alpha)
    love.graphics.draw(
        self.image_item:getImage(),
        x, y, --position
        rotation, --rotation
        size_x / self.image_item:getWidth(), size_y / self.image_item:getHeight(), --scaling factor
        self.image_item:getWidth()/2, self.image_item:getHeight()/2 --offset. Put original image size values not final radius values
    )
end

return GraphicsHandler
