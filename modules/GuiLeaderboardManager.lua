-- Module that manages initialization of and events relating to the gui leaderboard instances

local Manager = {}
local Bindings = require("lib.Bindings")
local Events = require("lib.Events")
local GuiLeaderboard = require("scripts.GuiLeaderboard")
local Names = require("scripts.GuiLeaderboard.Names")

local gui_leaderboards
local leaderboard






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
    gui_leaderboards = global.gui_leaderboards
    leaderboard = global.leaderboard
end

-- Called in on_init
function Manager.init()
    -- Init globals
    global.gui_leaderboards = {}

    -- Init locals
    cache_globals()

    for _, player in pairs(game.players) do
    end
end

-- Called in on_load
function Manager.load()
    -- Init locals
    cache_globals()

    -- Fix locals
    for _, gui_leaderboard in pairs(gui_leaderboards) do
        GuiLeaderboard.repairMetatable(gui_leaderboard)
    end
end

local on_open_gui, on_close_gui
function on_open_gui(event)
    local index = event.player_index
    local player = game.players[index]
    
    if gui_leaderboards[index] == nil then
        gui_leaderboards[index] = GuiLeaderboard.new {
            player = player,
            leaderboard = leaderboard,
        }
    elseif gui_leaderboards[index].gui ~= nil and player.opened == gui_leaderboards[index].gui then
        --If this is already open, close it
        on_close_gui(event)
        return
    end
    
    gui_leaderboards[index]:open()
end

function on_close_gui(event)
    local index = event.player_index
    local player = game.players[index]
    if gui_leaderboards[index] ~= nil then
        gui_leaderboards[index]:close()
    end
end

local function on_leaderboard_update(event)
    local old_rank = event.old_rank
    local new_rank = event.new_rank
    local key = event.key
    local entry = event.entry

    if old_rank == new_rank then
        for _, gui_leaderboard in pairs(gui_leaderboards) do
            gui_leaderboard:updateRow(new_rank, key, entry)
        end
    else
        local start_rank, end_rank
        if old_rank > new_rank then
            start_rank, end_rank = new_rank, old_rank
        else
            start_rank, end_rank = old_rank, new_rank
        end
        for _, gui_leaderboard in pairs(gui_leaderboards) do
            gui_leaderboard:updateRows(start_rank, end_rank, key, entry)
        end
    end
end

local function columns_changed(player_index)
    local gui_leaderboard = gui_leaderboards[player_index]
    local options_gui = gui_leaderboard.gui[Names.options]
    local columns = {}

    for _, v in ipairs(Names.keys) do
        local option = options_gui[Names.table_option[v]]
        if option ~= nil and option.state == true then
            table.insert(columns, v)
        end
    end

    gui_leaderboard:changeColumns(columns)
end

-- The player changed which column they want to sort the leaderboard by (Kills by default)
local function sort_key_changed(player_index, element)
    local sort_key = Names.table_header_reverse[element.name]
    local gui_leaderboard = gui_leaderboards[player_index]
    gui_leaderboard:changeSortKey(sort_key)
end

-- Is the GUI element a column option? (Eg a checkbox to turn a given column on or off such as kills, damage_dealt, or damage_taken)
local function element_is_column_option(element)
    return element ~= nil and Names.table_option_reverse[element.name]
end

-- Is the GUI element a header button in the leaderboard table? (Eg a header for kills, rank, type, damage_dealt, etc)
local function element_is_header_button(element)
    return element ~= nil and Names.table_header_reverse[element.name]
end

local function on_gui_checked_state_changed(event)
    local element = event.element
    if element_is_column_option(element) then
        --game.print("Columns changed: " .. event.element.name)
        columns_changed(event.player_index)
    end
end

local function on_gui_click(event)
    local element = event.element
    if element_is_header_button(element) then
        --game.print("Header Clicked: " .. event.element.name)
        sort_key_changed(event.player_index, element)
    end
end

local hook_table = 
{
    [defines.events.on_gui_closed] = on_close_gui,
    [Bindings.open_leaderboard_gui] = on_open_gui,
    [Events.on_leaderboard_update] = on_leaderboard_update,
    [defines.events.on_gui_checked_state_changed] = on_gui_checked_state_changed,
    [defines.events.on_gui_click] = on_gui_click,
}

function Manager.hooks()
    return hook_table
end


return Manager