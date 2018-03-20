require "hover_text"
require "turrets"
require "NameList"

--Currently the only
local default_name_list_text = require("default_name_list")


script.on_init(function()
    global.master_list = global.master_list or NameList.parse(default_name_list_text)
    hover_text_initialize()
    turrets_initialize()
end
)

script.on_load(function()
    MasterList.repairMetatable(global.master_list)
    hover_text_load()
    turrets_load()
end
)

local function open_gui(player)
    --local gui = player.gui.left.add{type = "frame", name = "exile_turrets_leaderboard", direction = "vertical"}
    --local gui2 = player.gui.left.add{type = "frame", name = "exile_turrets_leaderboard2", direction = "vertical"}


    
    --place, picture, name, kills
    local frame = player.gui.center.add{type = "frame", name = "exile_turrets_leaderboard3", direction = "vertical"}
    local scroll_pane = frame.add{type = "scroll-pane", name = "leaderboard_scroll_pane", style = "exile-leaderboard-scrollpane"}
    scroll_pane.vertical_scroll_policy = "always"
    local guitable = scroll_pane.add{type = "table", name = "leaderboard_table", column_count = 4}

    local leaderboard = get_leaderboard_sorted()
    for i, turret in ipairs(leaderboard) do
        guitable.add{type = "label", name = "rank_label_" .. i, caption = i} -- Place
        --guitable.add{type = "label", name = "picture_label_" .. i, caption = "Picture Here"} -- Place
        guitable.add{type = "entity-preview", name = "turret_preview_" .. i}.entity = turret.entity -- Place
        guitable.add{type = "label", name = "name_label_" .. i, caption = turret.name} -- Place
        guitable.add{type = "label", name = "kills_label_" .. i, caption = tostring(turret:kills())} -- Place
    end
end

script.on_event("exile-turrets-open-leaderboard-gui", function(event)
    local player = game.players[event.player_index]
    open_gui(player)
  end)