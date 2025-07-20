-- An object to create menus with options that the user can choose.

local MathSupplement = require("utils.math_supplement")
local MENU_INERTIA = 0.1

local Menu = {}
Menu.__index = Menu

local MENU_NAME_POSITION = {
    x = 100,
    y = 100
}
local OPTION_TEXT = {
    x = 300,
    y = 300
}
local OPTION_Y_DISPLACEMENT = 50

function Menu:new(menu_name, option_text, option_return_text)
    local menu = {
        health = 1,
        menu_name = menu_name,
        option_text = option_text,
        option_return_text = option_return_text,
        current_option_index = 1,
        timer = 0,
        type = "menu"
    }
    setmetatable(menu, Menu)
    return menu
end

function Menu:update(dt, player_control)
    self.timer = self.timer + dt
    if self.timer > MENU_INERTIA then
        if player_control.dx1 ~= 0 then
            self.current_option_index = self.current_option_index + 1 * MathSupplement.sign(player_control.dx1)
            self.timer = 0
        end
    end
    if player_control.action == true then
        self:do_action(dt)
    end
end

function Menu:do_action(dt)
    return self.option_return_text[self.current_option_index]
end

function Menu:draw()
    love.graphics.print(
        self.menu_name,
        MENU_NAME_POSITION.x,
        MENU_NAME_POSITION.y
    )
    for i, option_text in ipairs(self.option_text) do
        local scale_x = 1
        local scale_y = 1
        if i == self.current_option_index then
            scale_x = 2
            scale_y = 2
            love.graphics.setColor(1,0,0,1)
        end
        love.graphics.print(
            option_text,
            OPTION_TEXT.x,
            OPTION_TEXT.y + OPTION_Y_DISPLACEMENT * (i - 1),
            0,
            scale_x,
            scale_y
        )
    end
    love.graphics.setColor(1, 1, 1, 1)
end

return Menu
