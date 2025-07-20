-- An object to handle all entities in a level and update them

-- Imports

local MathSupplement = require("utils.math_supplement")

local EntityHandler = {}
EntityHandler.__index = EntityHandler

local HUD_POSITION = {
    x = 50,
    y = 50
}

local PAUSE_POSITION = {
    x = love.graphics.getWidth() /2,
    y = love.graphics.getHeight() /2,
}

function EntityHandler:new(cell_size_x, cell_size_y)
    local entity_handler = {
        cell_size_x = cell_size_x,
        cell_size_y = cell_size_y,
        num_cell_x = math.floor(love.graphics.getWidth() / cell_size_x + .5),
        num_cell_y = math.floor(love.graphics.getHeight() / cell_size_y + .5),
        player = {},
        list_object = {
            player = {},
            enemy = {}
        },
        list_evaluate_collision = {}
    }
    setmetatable(entity_handler, EntityHandler)
    return entity_handler
end

-- Reset function
function EntityHandler:reset_cells()
    self.list_evaluate_collision = {}
    for x = 0, self.num_cell_x + 1 do
        for y = 0, self.num_cell_y + 1 do
            self.list_evaluate_collision[x .. "-" .. y] = { player = {}, enemy = {} }
        end
    end
end

function EntityHandler:set_player(player)
    self.player = player
end

function EntityHandler:assign(entity, player)
    if player == true then
        table.insert(self.list_object.player, entity)
    else
        table.insert(self.list_object.enemy, entity)
    end
end

function EntityHandler:get_player_position()
    return self.player.player_entity.position
end

-- Update functions to update all elements in our entity_hendler
function EntityHandler:update(dt)
    if self.player.pause ~= true then
        self:reset_cells()
        self:update_all_entity(dt)
        self:update_cells()
        self:evaluate_collision()
        self:check_health()
    else
        self.player:update(dt)
    end
end

function EntityHandler:update_all_entity(dt)
    self.player:update(dt)
    local player_entity_position = self.player.player_entity.position
    for _, object in pairs(self.list_object.player) do
        object:update(dt)
    end
    for _, object in pairs(self.list_object.enemy) do
        object:update(dt, player_entity_position)
    end
end

function EntityHandler:update_cells()
    self:reset_cells()
    self:insert_in_correct_cell(self.player.player_entity, true)
    for _, object in pairs(self.list_object.player) do
        self:insert_in_correct_cell(object, true)
    end
    for _, object in pairs(self.list_object.enemy) do
        self:insert_in_correct_cell(object, false)
    end
end

function EntityHandler:insert_in_correct_cell(entity, player)
    local cell_x = math.floor(entity.position.x / self.cell_size_x + 0.5)
    local cell_y = math.floor(entity.position.y / self.cell_size_y + 0.5)
    if player == true then
        table.insert(self.list_evaluate_collision[cell_x .. "-" .. cell_y].player, entity)
    else
        table.insert(self.list_evaluate_collision[cell_x .. "-" .. cell_y].enemy, entity)
    end
end

-- For entities in the same cell, we evaluate collisions.
function EntityHandler:evaluate_collision()
    for cell_x = 0, self.num_cell_x + 1 do
        for cell_y = 0, self.num_cell_y + 1 do
            local num_player = #self.list_evaluate_collision[cell_x .. "-" .. cell_y].player
            local num_enemy = #self.list_evaluate_collision[cell_x .. "-" .. cell_y].enemy
            if num_player > 0 and num_enemy > 0 then
                -- Faire l'évaluation de s'il y a des collisions.
                for player_index = 1, num_player do
                    for enemy_index = 1, num_enemy do
                        local object_1 = self.list_evaluate_collision[cell_x .. "-" .. cell_y].player[player_index]
                        local object_2 = self.list_evaluate_collision[cell_x .. "-" .. cell_y].enemy[enemy_index]
                        for _, circle_player in ipairs(object_1.circle_list) do
                            for _, circle_enemy in ipairs(object_2.circle_list) do
                                local circle_1 = {
                                    x = object_1.position.x + circle_player.x * math.cos(object_1.angle.current) -
                                    circle_player.y * math.sin(object_1.angle.current),
                                    y = object_1.position.y + circle_player.x * math.sin(object_1.angle.current) +
                                    circle_player.y * math.cos(object_1.angle.current),
                                    r = circle_player.r
                                }
                                local circle_2 = {
                                    x = object_2.position.x + circle_enemy.x * math.cos(object_2.angle.current) -
                                    circle_enemy.y * math.sin(object_2.angle.current),
                                    y = object_2.position.y + circle_enemy.x * math.sin(object_2.angle.current) +
                                    circle_enemy.y * math.cos(object_2.angle.current),
                                    r = circle_enemy.r
                                }
                                if MathSupplement.check_intersection_cicles(circle_1, circle_2) then
                                    self:collision_between_two_objects(object_1, object_2)
                                    --print("collision")
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

function EntityHandler:collision_between_two_objects(object_1, object_2)
    object_1:collision(object_2)
    object_2:collision(object_1)
end

function EntityHandler:check_health()
    -- We remove "dead" elements from our loop. A better way would be to deactivate them.
    for i = #self.list_object.player, 1, -1 do
        local object = self.list_object.player[i]
        if object.health <= 0 then
            table.remove(self.list_object.player, i)
        end
    end
    for i = #self.list_object.enemy, 1, -1 do
        local object = self.list_object.enemy[i]
        if object.health <= 0 then
            table.remove(self.list_object.enemy, i)
        end
    end
end

-- Draw functions
function EntityHandler:draw()
    self.player.player_entity:draw()
    for _, object in pairs(self.list_object.player) do
        object:draw()
    end
    for _, object in pairs(self.list_object.enemy) do
        object:draw()
    end
    -- Draw hud once we have drawn all our entities.
    if self.player.player_entity.type ~= "menu" then
        self:draw_hud()
    end
    if self.player.pause == true then
        self:draw_pause()
    end
end

function EntityHandler:draw_hud()
    -- We haven't implemented a player hud so right now, we will just display player life
    --self.player.hud:draw()
    love.graphics.print(
        "Player health " .. self.player.player_entity.health,
        HUD_POSITION.x,
        HUD_POSITION.y
    )
end

function EntityHandler:draw_pause()
    -- Draws a puse menu so that the user knows the game is paused
    love.graphics.print(
        "The game is paused, click on <p> to continue.",
        PAUSE_POSITION.x,
        PAUSE_POSITION.y
    )
end

return EntityHandler
