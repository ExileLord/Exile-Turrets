--Handles hover text, eg when a player hovers over a turret
require("helpers")
require("turrets")

local hoverTextInstances = {}


local function handle_focus_change(player)
    
    if hoverTextInstances[player.index] ~= nil then
        hoverTextInstances[player.index]:destroy()
        hoverTextInstances[player.index] = nil
        
    end

    local entity = player.selected
    if not is_turret(entity) then
        return
    end
    
    local newPos = {entity.position.x, entity.position.y - 2}
    local turret = GetTurretEntry(entity)
    if turret==nil then
        return
    end

    local flyingText = player.surface.create_entity{
        name = "turret-flying-text", 
        position = newPos, 
        text = turret.name, 
        color = {r = 1, g = 1, b = 1},
    }

    hoverTextInstances[player.index] = flyingText
end

script.on_event({defines.events.on_selected_entity_changed}, function(event)
    local player = game.players[event.player_index]
    handle_focus_change(player)
end
)