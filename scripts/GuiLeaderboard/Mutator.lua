--Responsible for updating the gui leaderboard that is displayed on screen
local Mutator = {}
local Names = require("scripts.GuiLeaderboard.Names")


local function update_picture_cell(cell, entry)
    cell.entity = entry.entity
end

local function update_cell(cell, entry, key)
    if key == "picture" then
        update_picture_cell(cell, entry)
        return
    end

    cell.caption = tostring(entry.value[key])
end

local fixed_keys =
{
    "rank",
    "picture",
    "name",
}
function Mutator.updateRow(gui_leaderboard, row)
    local sort_key = gui_leaderboard.sort_key
    local list = gui_leaderboard.leaderboard:getSortedArray(sort_key)
    local entry = list[row]

    local table = gui_leaderboard.gui[Names.scrollpane][Names.table]
    local columns = gui_leaderboard.columns
    local column_count = #fixed_keys + #columns
    local offset = (column_count * (row - 1))
    --rank column shouldn't ever need to be updated so we start at 2 for the picture/preview
    for i = 2, column_count do
        local cell = table.children[offset + i]
        local key = fixed_keys[i] or columns[i - #fixed_keys]
        --game.print(string.format("Updating %s[table=%s] with [key=%s]", cell.name, tostring(cell), tostring(key)))
        update_cell(cell, entry, key)
    end
end


return Mutator