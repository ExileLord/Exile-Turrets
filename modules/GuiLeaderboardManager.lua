local Manager = {}
local bindings = require("lib.Bindings")
local events = require("lib.Events")
local GuiLeaderboard = require("scripts.GuiLeaderboard")

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
    --Init globals
    global.gui_leaderboards = {}

    --Init locals
    cache_globals()

    for _, player in pairs(game.players) do
    end
end

-- Called in on_load
function Manager.load()
    --Init locals
    cache_globals()

    --Fix locals
    for _, gui_leaderboard in pairs(gui_leaderboards) do
        GuiLeaderboard.repair_metatable(gui_leaderboard)
    end
end




--events
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

    if old_rank == new_rank then
        for _, gui_leaderboard in pairs(gui_leaderboards) do
            gui_leaderboard:updateRow(new_rank)
        end
    else
        local start_rank, end_rank
        if old_rank > new_rank then
            start_rank, end_rank = new_rank, old_rank
        else
            start_rank, end_rank = old_rank, new_rank
        end
        for _, gui_leaderboard in pairs(gui_leaderboards) do
            gui_leaderboard:updateRows(start_rank, end_rank)
        end
    end
end


local hook_table = 
{
    [defines.events.on_gui_closed] = on_close_gui,
    [bindings.open_leaderboard_gui] = on_open_gui,
    [events.on_leaderboard_update] = on_leaderboard_update,
}

function Manager.hooks()
    return hook_table
end


return Manager