--Responsible for initially building the gui gui_leaderboard that is displayed on screen
--Also responsible for modifying that gui leaderboard when it is being displayed on the screen (live updating)
local Builder = {}
local Names = require("scripts.GuiLeaderboard.Names")
local Styles = require("lib.Styles")




local create_gui_leaderboard_frame
local add_header
local add_column_options_table
local add_column_option_cell
local add_table
local add_table_header
local add_table_header_button
local add_table_row
local add_table_cell
local add_table_rank_cell
local add_table_type_cell
local add_table_name_cell
local add_table_label_cell

--Keys (Columns) that should never move in a leaderboard. These should always be the first three elements of a gui leaderboard
local fixed_keys =
{
    "rank",
    "type",
    "name",
}

--Creates the leaderboard frame and everything in it
--Essentially creates the entire gui leaderboard
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

local function table_contains(table, item)
    for _, entry in pairs(table) do
        if item == entry then
            return true
        end
    end
    return false
end

function add_column_options_table(gui_leaderboard, frame)
    
    local container = frame.add {
        type = "flow",
        name = Names.options
    }

    local available_columns = gui_leaderboard.available_columns
    local columns = gui_leaderboard.columns
    for _, key in pairs(available_columns) do
        container.add {
            type = "checkbox",
            name = Names.table_option[key],
            caption = key,
            state = table_contains(columns, key) --check the column option if it's being used (eg it's key is in the active columns)
        }
    end    
end

function add_table(gui_leaderboard, frame)
        frame = frame or gui_leaderboard.gui
        local scroll_pane = frame[Names.scrollpane] or frame.add {
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
            style = Styles.table
        }

        gui_table.draw_vertical_lines = true
        gui_table.draw_horizontal_line_after_headers = true

        local key = gui_leaderboard.sort_key
        local list = gui_leaderboard.leaderboard:getSortedArray(key)
        local columns = gui_leaderboard.columns
        
        
        add_table_header(gui_table, columns)
        for rank = 1, #list do
            add_table_row(gui_table, columns, list, rank)
        end

        return gui_table, scroll_pane
end




function add_table_header(table, columns)
    add_table_header_button(table, "rank")
    add_table_header_button(table, "type")
    add_table_header_button(table, "name")
    for _, column in ipairs(columns) do
        add_table_header_button(table, column)
    end
end

function add_table_header_button(table, key)
    table.add {
        type = "button",
        name = Names.table_header[key],
        caption = key,
        style = Styles.header_button
    }
end

function add_table_row(table, columns, list, rank)
    local entry = list[rank]
    add_table_rank_cell(table, rank)
    add_table_type_cell(table, rank, entry)
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
        name = Names.tableCell("rank", rank),
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
        name = Names.tableCell("name", rank),
        caption = entry.value.name,
        style = style,
    }
end

function add_table_type_cell(table, rank, entry)
    local cell = table.add {
        type = "entity-preview", 
        name = Names.tableCell("type", rank), 
        style = Styles.turret_preview
    }
    cell.entity = entry.entity -- Place
end

function add_table_cell(table, rank, entry, key)
    table.add {
        type = "label", 
        name = Names.tableCell(key, rank), 
        caption = tostring(entry.value[key])
    }
end

Builder.createGui = create_gui_leaderboard_frame

function Builder.rebuildTable(gui_leaderboard)
    local scrollpane = gui_leaderboard.gui[Names.scrollpane]
    local table = gui_leaderboard.gui[Names.scrollpane][Names.table]
    table.destroy()
    return add_table(gui_leaderboard)
end





















--Responsible for updating the gui leaderboard that is displayed on screen

local function update_type_cell(cell, entry)
    
    cell.entity = entry.entity
end

local function update_cell(cell, entry, key)
    if key == "type" then
        update_type_cell(cell, entry)
        return
    end

    --local new_caption = "dummy"
    local new_caption = tostring(entry.value[key])
    if cell.caption ~= new_caption then
        cell.caption = new_caption
    end
end


--!TODO: Redo this garbage so that we're not using GuiElement.children anymore. 
function Builder.updateCell(gui_leaderboard, row, key)
    local cell

    do
        local column = gui_leaderboard.column_index[key]
        if column == nil then
            return --column isn't on the leaderboard
        end
        local column_count = #fixed_keys + #gui_leaderboard.columns
        cell = gui_leaderboard:tableChild(column_count * row + column)
    end

    if cell ~= nil then
        local sort_key = gui_leaderboard.sort_key
        local list = gui_leaderboard.leaderboard:getSortedArray(sort_key)
        local entry = list[row]
        update_cell(cell, entry, key)
    end
end

function Builder.updateRow(gui_leaderboard, row)

    local sort_key = gui_leaderboard.sort_key
    local list = gui_leaderboard.leaderboard:getSortedArray(sort_key)
    local entry = list[row]

    local table = gui_leaderboard.gui[Names.scrollpane][Names.table]
    local columns = gui_leaderboard.columns
    local column_count = #fixed_keys + #columns
    local offset = column_count * row
    --rank column shouldn't ever need to be updated so we start at 2 for the type/preview
    for i = 2, column_count do
        local cell = gui_leaderboard:tableChild(offset + i)
        local key = fixed_keys[i] or columns[i - #fixed_keys]
        --game.print(string.format("Updating %s[table=%s] with [key=%s]", cell.name, tostring(cell), tostring(key)))
        update_cell(cell, entry, key)
    end
end

return Builder