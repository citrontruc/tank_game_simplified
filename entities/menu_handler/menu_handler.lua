-- An object to create menus with options that the user can choose.

local MathSupplement = require("utils.math_supplement")
local MENU_INERTIA = 0.3

local MenuHandler = {}
MenuHandler.__index = MenuHandler

function MenuHandler:new(menu)
    local menu = {
        current_option_index = 1,
        timer = 0,
        menu = menu
    }
    setmetatable(menu, MenuHandler)
    return menu
end

-- Move menu button on the screen
function MenuHandler:update(dt, player_control)
    self.timer = self.timer + dt
    if self.timer > MENU_INERTIA then
        if player_control.dy1 ~= 0 then
            self.current_option_index = self.current_option_index + 1 * MathSupplement.sign(player_control.dy1)
            self.timer = 0
        end
    end
    if player_control.action == true then
        return self:do_action()
    end
    self.menu:do_action(self.current_option_index, false)
end

-- If the player presses an option, do the option associated to the button.
function MenuHandler:do_action()
    self.menu:do_action(self.current_option_index, true)
end

return MenuHandler
