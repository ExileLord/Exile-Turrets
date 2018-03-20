--Handles hover text, eg when a player hovers over a turret
require "helpers"
require "turrets"

--TODO Fix

local hover_text_instances


local function handle_focus_change(player)
    
    if hover_text_instances[player.index] ~= nil then
        hover_text_instances[player.index]:destroy()
        hover_text_instances[player.index] = nil
        
    end

    local entity = player.selected
    if not is_turret(entity) then
        return
    end
    
    local newPos = {entity.position.x, entity.position.y - 2}
    local turret = get_turret_entry(entity)
    if turret==nil then
        return
    end

    local flyingText = player.surface.create_entity{
        name = "turret-flying-text", 
        position = newPos, 
        text = turret.name, 
        color = {r = 1, g = 1, b = 1},
    }

    hover_text_instances[player.index] = flyingText
end

-- ▄▄▄▄▄▄▄▄▄▄▄  ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ 
--▐░░░░░░░░░░░▌▐░░▌      ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
-- ▀▀▀▀█░█▀▀▀▀ ▐░▌░▌     ▐░▌ ▀▀▀▀█░█▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ 
--     ▐░▌     ▐░▌▐░▌    ▐░▌     ▐░▌          ▐░▌     
--     ▐░▌     ▐░▌ ▐░▌   ▐░▌     ▐░▌          ▐░▌     
--     ▐░▌     ▐░▌  ▐░▌  ▐░▌     ▐░▌          ▐░▌     
--     ▐░▌     ▐░▌   ▐░▌ ▐░▌     ▐░▌          ▐░▌     
--     ▐░▌     ▐░▌    ▐░▌▐░▌     ▐░▌          ▐░▌     
-- ▄▄▄▄█░█▄▄▄▄ ▐░▌     ▐░▐░▌ ▄▄▄▄█░█▄▄▄▄      ▐░▌     
--▐░░░░░░░░░░░▌▐░▌      ▐░░▌▐░░░░░░░░░░░▌     ▐░▌     
-- ▀▀▀▀▀▀▀▀▀▀▀  ▀        ▀▀  ▀▀▀▀▀▀▀▀▀▀▀       ▀      
                                                    
-- Called in on_init
function hover_text_initialize()
    --Init globals
    global.hover_text_instances = global.hover_text_instances or {}

    --Init locals
    hover_text_load()
end

-- Called in on_load
function hover_text_load()
    --Init locals
    hover_text_instances = global.hover_text_instances
end



script.on_event({defines.events.on_selected_entity_changed}, function(event)
    local player = game.players[event.player_index]
    handle_focus_change(player)
end
)
