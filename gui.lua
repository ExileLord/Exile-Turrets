require "turrets"


local add_leaderboard_header, add_leaderboard_table, add_table_header
local add_table_line, add_table_turret_rank, add_table_turret_entity, add_table_turret_name, add_table_turret_kills, add_table_turret_damage_dealt, add_table_turret_damage_taken


function add_leaderboard_header(frame)
    return frame.add{type = "label", name = "leaderboard_title", caption = "Turret Rankings", style = "large_caption_label"} -- Place
end

function add_leaderboard_table(frame)
    -- scroll pane that the table is nested in
    local scroll_pane = frame.add{type = "scroll-pane", name = "leaderboard_scroll_pane", style = "exile-leaderboard-scrollpane"}
    scroll_pane.vertical_scroll_policy = "always"

    -- actual table
    local gui_table = scroll_pane.add{type = "table", name = "leaderboard_table", column_count = 4, style = "exile-leaderboard-table"}

    return gui_table, scroll_pane
end

function add_table_header(gui_table)
    local style = "exile-leaderboard-header-button"
    gui_table.add{type = "button", name = "rank_header_button", caption = "Rank", style = "exile-leaderboard-header-button"}
    gui_table.add{type = "button", name = "type_header_button", caption = "Type", style = "exile-leaderboard-header-button"} 
    gui_table.add{type = "button", name = "name_header_button", caption = "Name", style = "exile-leaderboard-header-button"}  
    gui_table.add{type = "button", name = "kills_header_button", caption = "Kills", style = "exile-leaderboard-header-button"} 
    gui_table.draw_horizontal_lines = true
    gui_table.draw_horizontal_line_after_headers = false
    gui_table.ignored_by_interaction = false
    gui_table.enabled = true
end

function add_table_line(gui_table, turret, rank)
    add_table_turret_rank(gui_table, rank)
    gui_table.add{type = "entity-preview", name = "turret_preview_" .. rank, style = "exile-leaderboard-turret-preview"}.entity = turret.entity -- Place
    add_table_turret_name(gui_table, turret.name, rank)
    --gui_table.add{type = "label", name = "name_label_" .. rank, caption = turret.name} -- Place
    gui_table.add{type = "label", name = "kills_label_" .. rank, caption = tostring(turret:kills())} -- Place
end

local rank_style =
{
    [1] = "exile-leaderboard-rank1-label",
    [2] = "exile-leaderboard-rank2-label",
    [3] = "exile-leaderboard-rank3-label",
}
function add_table_turret_rank(gui_table, rank)
    local style = rank_style[rank] or "exile-leaderboard-rank-label"
    gui_table.add{
        type = "label",
        name = "rank_label_" .. rank,
        caption = rank,
        style = style,
    }
end

local name_style =
{
    [1] = "exile-leaderboard-name-rank1-label",
    [2] = "exile-leaderboard-name-rank2-label",
    [3] = "exile-leaderboard-name-rank3-label",
}
function add_table_turret_name(gui_table, name, rank)
    local style = name_style[rank] or "exile-leaderboard-name-label"
    gui_table.add{
        type = "label",
        name = "name_label_" .. rank,
        caption = name,
        style = style,
    }
end


local leaderboard_gui
function open_gui(player)
    -- Abort if the player has a menu opened
    if player.opened ~= nil then
        return
    end

    local frame = player.gui.center.add{type = "frame", name = "exile_turrets_leaderboard3", direction = "vertical"}
    add_leaderboard_header(frame)
    local leaderboard_table = add_leaderboard_table(frame)
    add_table_header(leaderboard_table)

    local leaderboard = get_leaderboard_sorted()
    for i, turret in ipairs(leaderboard) do
        add_table_line(leaderboard_table, turret, i)
    end

    player.opened = frame
    leaderboard_gui[player.index] = frame
end

function close_gui(player)
    local i = player.index

    if leaderboard_gui[i] == nil then
        return
    end

    leaderboard_gui[i].destroy()
    leaderboard_gui[i] = nil
end


-- Called in on_init
function gui_initialize()
    global.leaderboard_gui = global.leaderboard_gui or {}

    gui_load()
end

-- Called in on_load
function gui_load()
    --Init locals
    leaderboard_gui = global.leaderboard_gui

    --Fix locals
end
