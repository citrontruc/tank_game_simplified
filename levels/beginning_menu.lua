-- The beginning menu for the game.

local MenuHandler = require("entities.menu_handler.menu_handler")

local BeginningMenu = {}
BeginningMenu.__index = BeginningMenu

local MENU_NAME = "SuperTank"
local MENU_NAME_POSITION = {
    x = love.graphics.getWidth() / 2,
    y = love.graphics.getHeight() / 2
}

local OPTION_TEXT_VALUE = {
    "Play",
    "Quit"
}
local OPTION_TEXT = {
    x = love.graphics.getWidth() / 2,
    y = love.graphics.getHeight() / 2 + 200
}
local OPTION_Y_DISPLACEMENT = 50


--Creates our menu and the menu_handler to control it.
function BeginningMenu:new(player)
    local menu = {
        menu_name = MENU_NAME,
        option_text_value = OPTION_TEXT_VALUE,
        current_option_index = 1,
        type = "menu",
        next_level = false,
        player = player
    }
    setmetatable(menu, BeginningMenu)
    player:set_entity(MenuHandler:new(menu))
    return menu
end

function BeginningMenu:update(dt)
    self.player:update(dt)
end

-- Does the action where the player cursor is.
function BeginningMenu:do_action(option_index, do_action)
    self.current_option_index = (option_index - 1) % #self.option_text_value + 1
    if do_action == true then
        if self.current_option_index == 1 then
            self.next_level = true
        end
        if self.current_option_index == 2 then
            love.window.close()
        end
    end
end

-- We write the name of the menu and all of the options.
-- The selected option is highlighted.
function BeginningMenu:draw()
    local scale_x_title = 3
    local scale_y_title = 3
    love.graphics.print(
        self.menu_name,
        MENU_NAME_POSITION.x,
        MENU_NAME_POSITION.y,
        0,
        scale_x_title,
        scale_y_title
    )
    for i, option_text in ipairs(self.option_text_value) do
        local scale_x = 1
        local scale_y = 1
        love.graphics.setColor(1, 1, 1, 1)
        if i == self.current_option_index then
            scale_x = 2
            scale_y = 2
            love.graphics.setColor(1, 0, 0, 1)
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

function BeginningMenu.initialize(player)
    return BeginningMenu:new(player)
end

return BeginningMenu
