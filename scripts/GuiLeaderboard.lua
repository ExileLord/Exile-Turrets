local GuiLeaderboard = {}

local Builder = require("scripts.GuiLeaderboard.Builder")
local Mutator = require("scripts.GuiLeaderboard.Mutator")

local _mt = {__index = GuiLeaderboard}
local ALL_COLUMNS = 
{
    "kills",
    "damage_dealt",
    "damage_taken",
    "name",
    "kill_reason"
}
local DEFAULT_COLUMNS = {"kills"}
local DEFAULT_SORT_KEY = "kills"

local create_leaderboard_gui


function create_leaderboard_gui(gui_leaderboard)
    if o.gui ~= nil then
        return
    end

    o.gui = create_leaderboard_frame(gui_leaderboard)
end


function GuiLeaderboard.new(o)
    assert(o.player)
    assert(o.leaderboard)
    --o.gui
    --o.table
    o.columns = o.columns or DEFAULT_COLUMNS
    o.sort_key = o.sort_key or DEFAULT_SORT_KEY
    o.ascending = o.ascending or false
    setmetatable(o, _mt)
    return o
end

function GuiLeaderboard.repairMetatable(o)
    setmetatable(o, _mt)
end

function GuiLeaderboard:open()
end

function GuiLeaderboard:close()
    if self.gui ~= nil then
        self.gui.destroy()
    end
    self.gui = nil
end

function GuiLeaderboard:updateRows(start_row, end_row)
end

function GuiLeaderboard:updateRow(row)
end

function GuiLeaderboard:addRow(row)
    error("Not implemented")
end

function GuiLeaderboard:removeRow(row)
    error("Not implemented")
end

return GuiLeaderboard