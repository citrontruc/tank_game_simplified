-- An object to create menus with options that the user can choose.

local MENU_INERTIA = 0.1

local Menu = {}
Menu.__index = Menu

function Menu:new(option_list)
    local menu = {
        option_list = option_list,
        current_option_index = 1,
        current_option = option_list[1]
    }
    setmetatable(menu, Menu)
    return menu
end

function Menu:update(dt)
end

function Menu:draw()
end

return Menu
