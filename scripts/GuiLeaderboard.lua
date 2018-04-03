local GuiLeaderboard = {}

local Builder = require("scripts.GuiLeaderboard.Builder")
local Names = require("scripts.GuiLeaderboard.Names")
local Styles = require("lib.Styles")

local IGNORED_COLUMN_SET =
{
    ["name"] = true,
}

local DEFAULT_COLUMNS = {"kills", "damage_dealt"}
local DEFAULT_SORT_KEY = "kills"

local _mt = {__index = GuiLeaderboard}
function GuiLeaderboard.new(o)
    assert(o.player)
    assert(o.leaderboard)
    --o.gui = nil

    --Build available columns from the leaderboard
    local available_column_set = {}
    if o.available_columns == nil then
        o.available_columns = {}
        for k, _ in pairs(o.leaderboard.sorted_entries) do
            if not IGNORED_COLUMN_SET[k] then
                available_column_set[k] = true
                table.insert(o.available_columns, k)
            end
        end
        table.sort(o.available_columns)
    end

    if o.columns == nil then
        o.columns = {}
        for _, v in ipairs(DEFAULT_COLUMNS) do
            table.insert(o.columns, v)
        end
    end

    GuiLeaderboard.rebuildColumnIndex(o)
    o.current_rows = 0

    --o.available_columns = o.available_columns or ALL_COLUMNS
    o.sort_key = o.sort_key or DEFAULT_SORT_KEY
    o.ascending = o.ascending or false
    setmetatable(o, _mt)
    return o
end

function GuiLeaderboard.repairMetatable(o)
    setmetatable(o, _mt)
end

function GuiLeaderboard:rebuildColumnIndex()
    self.column_index = 
    {
        ["rank"] = 1,
        ["type"] = 2,
        ["name"] = 3,
    } 
    for i = 1, #self.columns do
        self.column_index[self.columns[i]] = i + 3
    end
end

function GuiLeaderboard:open()
    if self.gui ~= nil then
        return
    end
    self.gui = Builder.createGui(self)
    self.player.opened = self.gui
    return self.gui
end

function GuiLeaderboard:changeSortKey(sort_key)
    self.sort_key = sort_key
    self:rebuildTable()
end

function GuiLeaderboard:changeColumns(columns)
    self.columns = {table.unpack(columns)}
    self:rebuildColumnIndex()
    self:rebuildTable()
end

function GuiLeaderboard:rebuildTable()
    self.cached_table_children = nil
    Builder.rebuildTable(self)
end


function GuiLeaderboard:close()
    if self.gui ~= nil then
        self.gui.destroy()
    end
    self.gui = nil
    self.cached_table_children = nil
end

function GuiLeaderboard:updateRows(start_row, end_row, key, entry)
    if self.gui == nil then
        return
    end

    --start_row and end_row are only correct if that is the current sort_key
    if key ~= self.sort_key then
        local fixed_row = entry.rank[self.sort_key]
        Builder.updateCell(self, fixed_row, key)
        return
    end

    --If start row and end row are the same, only put in the work to update a single cell
    if start_row == end_row then
        Builder.updateCell(self, row, key)
        return
    end

    -- Ensure the start row actually comes before the end row
    if start_row > end_row then
        start_row, end_row = end_row, start_row
    end

    for row = start_row, end_row do
        Builder.updateRow(self, row)
    end
end

--TODO: Deprecate this
function GuiLeaderboard:updateRow(row, key, entry)
    if self.gui == nil then
        return
    end
    
    --start_row and end_row are only correct if that is the current sort_key
    if key ~= self.sort_key then
        local fixed_row = entry.rank[self.sort_key]
        Builder.updateCell(self, fixed_row, key)
        return
    end

    Builder.updateCell(self, row, key)
end

function GuiLeaderboard:addRow(row)
    error("Not implemented")
end

function GuiLeaderboard:removeRow(row)
    error("Not implemented")
end

function GuiLeaderboard:tableChildren()
    if self.cached_table_children == nil then
        self.cached_table_children = self.gui[Names.scrollpane][Names.table].children
    end

    return self.cached_table_children
end

function GuiLeaderboard:tableChild(i)
    local children = self:tableChildren()

    local child = children[i]
    assert(child.valid)
    return child
end

return GuiLeaderboard