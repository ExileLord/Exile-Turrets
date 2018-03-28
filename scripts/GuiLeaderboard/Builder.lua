--Responsible for initially building the gui gui_leaderboard that is displayed on screen
local Builder = {}
local Names = require("scripts.GuiLeaderboard.Names")
local Styles = require("lib.Styles")


local create_gui_leaderboard_frame
local add_header
local add_column_options_table
local add_column_option_cell
local add_table
local add_table_header
local add_table_row
local add_table_cell
local add_table_rank_cell
local add_table_picture_cell
local add_table_name_cell
local add_table_label_cell

function create_gui_leaderboard_frame(gui_leaderboard)
    local player = gui_leaderboard.player
    if player.opened then
        return
    end
    
    local frame = player.gui.center.add {
        type = "frame",
        name = Names.frame,
        direction = "vertical",
        style = Styles.frame
    }
    frame.style.maximal_height = player.display_resolution.height * 0.71


    --add children to frame
    add_header(gui_leaderboard, frame)
    add_column_options_table(gui_leaderboard, frame)
    add_table(gui_leaderboard, frame)

    return frame
end

function add_header(gui_leaderboard, frame)
    return frame.add {
        type = "label",
        name = Names.header,
        caption = "Turret Rankings",
        style = "large_caption_label"
    }
end

function add_column_options_table(gui_leaderboard, frame)
end

function add_table(gui_leaderboard, frame)
        -- scroll pane that the table is nested in
        local scroll_pane = frame.add {
            type = "scroll-pane",
            name = Names.scrollpane,
            style = Styles.scrollpane
        }
        scroll_pane.vertical_scroll_policy = "always"
    
        -- actual table
        local gui_table = scroll_pane.add {
            type = "table", 
            name = "leaderboard_table", 
            column_count = 3 + #gui_leaderboard.columns, 
            style = "exile-leaderboard-table"
        }

        local key = gui_leaderboard.sort_key
        local list = gui_leaderboard.leaderboard:getSortedArray(key)
        local columns = gui_leaderboard.columns
        for rank = 1, #list do
            add_table_row(gui_table, columns, list, rank)
        end

        return gui_table, scroll_pane
end

function add_table_header(gui_leaderboard, table)
end

function add_table_row(table, columns, list, rank)
    local entry = list[rank]
    add_table_rank_cell(table, rank)
    add_table_picture_cell(table, rank, entry)
    add_table_name_cell(table, rank, entry)
    for i = 1, #columns do
        add_table_cell(table, rank, entry, columns[i])
    end
end

--Rank cell in the leaderboard ranking table. The turret's rank
local default_rank_label_style = Styles.rank_label
local rank_label_style =
{
    [1] = Styles.rank1_label,
    [2] = Styles.rank2_label,
    [3] = Styles.rank3_label,
}
function add_table_rank_cell(table, rank)
    local style = rank_label_style[rank] or default_rank_label_style
    table.add {
        type = "label",
        name = Names.rank_cell(rank),
        caption = rank,
        style = style,
    }
end

--Name cell in the leaderboard ranking table. The turret's name
local default_name_label_style = Styles.name_label
local name_rank_label_style =
{
    [1] = Styles.name_rank1_label,
    [2] = Styles.name_rank2_label,
    [3] = Styles.name_rank3_label,
}
function add_table_name_cell(table, rank, entry)
    local style = name_rank_label_style[rank] or default_name_label_style
    table.add {
        type = "label",
        name = Names.name_cell(rank),
        caption = entry.value.name,
        style = style,
    }
end

function add_table_picture_cell(table, rank, entry)
    local cell = table.add{
        type = "entity-preview", 
        name = Names.picture_cell(rank), 
        style = Styles.turret_preview
    }
    cell.entity = entry.entity -- Place
end

function add_table_cell(table, rank, entry, key)
    table.add {
        type = "label", 
        name = tostring(key) .. rank, 
        caption = tostring(entry.value[key])
    }
end

Builder.createGui = create_gui_leaderboard_frame

return Builder