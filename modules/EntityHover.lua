--Load after LeaderboardUpdater

local EntityHover = {}
local Misc = require("lib.EntityTools")
local Colors = require("lib.Colors")

local hover_text_instances
local leaderboard

local is_turret = Misc.isTurret

local rank_color_table =
{
    Colors.first_place,
    Colors.second_place,
    Colors.third_place
}
local function get_entry_color(entry)
    local key = "kills"
    local rank = entry.rank[key]
    local color = rank_color_table[rank]
    return color or {r = 1, g = 1, b = 1}
end

local function handle_focus_change(player)
    local index = player.index

    if hover_text_instances[index] ~= nil then
        hover_text_instances[index]:destroy()
        hover_text_instances[index] = nil
    end

    local entity = player.selected
    if not is_turret(entity) then
        return
    end

    local entry = leaderboard:getByEntity(entity)
    if entry==nil then
        return
    end

    local newPos = {entity.position.x, entity.position.y - 2}
    local flyingText = player.surface.create_entity {
        name = "turret-flying-text", 
        position = newPos, 
        text = entry.value.name, 
        color = get_entry_color(entry),
    }

    hover_text_instances[player.index] = flyingText
end





-- ▄▄▄▄▄▄▄▄▄▄▄  ▄               ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ 
--▐░░░░░░░░░░░▌▐░▌             ▐░▌▐░░░░░░░░░░░▌▐░░▌      ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
--▐░█▀▀▀▀▀▀▀▀▀  ▐░▌           ▐░▌ ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌░▌     ▐░▌ ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ 
--▐░▌            ▐░▌         ▐░▌  ▐░▌          ▐░▌▐░▌    ▐░▌     ▐░▌     ▐░▌          
--▐░█▄▄▄▄▄▄▄▄▄    ▐░▌       ▐░▌   ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌ ▐░▌   ▐░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄ 
--▐░░░░░░░░░░░▌    ▐░▌     ▐░▌    ▐░░░░░░░░░░░▌▐░▌  ▐░▌  ▐░▌     ▐░▌     ▐░░░░░░░░░░░▌
--▐░█▀▀▀▀▀▀▀▀▀      ▐░▌   ▐░▌     ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌   ▐░▌ ▐░▌     ▐░▌      ▀▀▀▀▀▀▀▀▀█░▌
--▐░▌                ▐░▌ ▐░▌      ▐░▌          ▐░▌    ▐░▌▐░▌     ▐░▌               ▐░▌
--▐░█▄▄▄▄▄▄▄▄▄        ▐░▐░▌       ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌     ▐░▐░▌     ▐░▌      ▄▄▄▄▄▄▄▄▄█░▌
--▐░░░░░░░░░░░▌        ▐░▌        ▐░░░░░░░░░░░▌▐░▌      ▐░░▌     ▐░▌     ▐░░░░░░░░░░░▌
-- ▀▀▀▀▀▀▀▀▀▀▀          ▀          ▀▀▀▀▀▀▀▀▀▀▀  ▀        ▀▀       ▀       ▀▀▀▀▀▀▀▀▀▀▀ 
                          
local function cache_globals()
    hover_text_instances = global.hover_text_instances
    leaderboard = global.leaderboard
    assert(hover_text_instances ~= nil, "EntityHover was initialized with nil global.hover_text_instances")
    assert(leaderboard ~= nil, "EntityHover was initialized with nil global.leaderboard")
end

-- Called in on_init
function EntityHover.init()
    --Init globals
    global.hover_text_instances = {}

    --Init locals
    cache_globals()
end

-- Called in on_load
function EntityHover.load()
    --Init locals
    cache_globals()
end

--events

local function on_selected_entity_changed(event)
    local player = game.players[event.player_index]
    handle_focus_change(player)
end


local hook_table = 
{
    [defines.events.on_selected_entity_changed] = on_selected_entity_changed,
}
function EntityHover.hooks()
    return hook_table
end




return EntityHover