require "turrets"



local function add_table_header(table)
    table.add{type = "button", name = "rank_header_button", caption = "Rank"}
    table.add{type = "button", name = "type_label_", caption = "Type"} 
    table.add{type = "button", name = "name_label_", caption = "Name"} 
    table.add{type = "button", name = "kills_label_" , caption = "Kills"} 
end

local function open_leaderboard(player)
    --local gui = player.gui.left.add{type = "frame", name = "exile_turrets_leaderboard", direction = "vertical"}
    --local gui2 = player.gui.left.add{type = "frame", name = "exile_turrets_leaderboard2", direction = "vertical"}

    --place, picture, name, kills
    local frame = player.gui.center.add{type = "frame", name = "exile_turrets_leaderboard", direction = "vertical"}
    local scroll_pane = frame.add{type = "scroll-pane", name = "leaderboard_scroll_pane"}
    scroll_pane.vertical_scroll_policy = "always"
    local table = scroll_pane.add{type = "table", name = "leaderboard_table", column_count = 4}
    for i = 1,20 do
        table.add{type = "label", name = "rank_label_" .. i, caption = tostring(i)}
        table.add{type = "label", name = "picture_label_" .. i, caption = "Picture Here"}
        table.add{type = "label", name = "name_label_" .. i, caption = "Name Here"} 
        table.add{type = "label", name = "kills_label_" .. i, caption = tostring(math.random(0,1000))}
    end
end


-- Called in on_init
function gui_initialize()
    --Init globals
end

-- Called in on_load
function gui_load()
    --Init locals

    --Fix locals
end
