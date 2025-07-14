-- An object to handle all entities in a level and update them

-- Imports

local EntityHandler = {}
EntityHandler.__index = EntityHandler

local HUD_POSITION = {
    x = 50,
    y = 50
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
            self.list_evaluate_collision[x .. "-" .. y] = {}
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

-- Update functions to update all elements in our entity_hendler
function EntityHandler:update(dt)
    self:reset_cells()
    self:update_all_entity(dt)
    self:update_cells()
    self:evaluate_collision()
    self:check_health()
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
    self:insert_in_correct_cell(self.player.player_entity)
    for key, object in pairs(self.list_object.player) do
        self:insert_in_correct_cell(object)
    end
    for key, object in pairs(self.list_object.enemy) do
        self:insert_in_correct_cell(object)
    end
end

function EntityHandler:insert_in_correct_cell(entity)
    local cell_x = math.floor(entity.position.x / self.cell_size_x + 0.5)
    local cell_y = math.floor(entity.position.y / self.cell_size_y + 0.5)
    table.insert(self.list_evaluate_collision[cell_x .. "-" .. cell_y], entity)
end

-- For entities in the same cell, we evaluate collisions.
function EntityHandler:evaluate_collision()

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
    self:draw_hud()
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

return EntityHandler
