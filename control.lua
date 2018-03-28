--require "hover_text"
--require "turrets"
--require "gui"


--Currently the only
--local default_name_list_text = require("scripts.default_name_list")
--local Parser = require("lib.NameList.Parser")
--local MasterList = require("lib.NameList.MasterList")

--Loaded in the order they are given
local modules = {
    require("modules.MasterList"),
    require("modules.LeaderboardUpdater"),
    require("modules.EntityHover"),
    require("modules.GuiLeaderboardManager")
}

local function create_multifunction_handler(functions)
    return function(event)
        for i=1, #functions do
            local fn = functions[i]
            fn(event)
        end
    end
end

local function register_events(modules)
    local event_map = {}

    --build event map
    for _, module in ipairs(modules) do
        local hooks = module.hooks()
        for event, fn in pairs(hooks) do
            event_map[event] = event_map[event] or {}
            table.insert(event_map[event], fn)
        end
    end

    --register events
    for event, fn_table in pairs(event_map) do
        if #fn_table == 1 then
            script.on_event(event, fn_table[1])
        elseif #fn_table > 1 then
            script.on_event(event, create_multifunction_handler(fn_table))
        end
    end
end


register_events(modules)

script.on_init(function()
    --global.master_list = global.master_list or Parser.parse(default_name_list_text)
    for _, module in ipairs(modules) do
        module.init()
    end
end
)

script.on_load(function()
    --MasterList.repairMetatable(global.master_list)
    for _, module in ipairs(modules) do
        module.load()
    end
end
)


--[[
script.on_event("exile-turrets-open-leaderboard-gui", function(event)
    local player = game.players[event.player_index]
    --open_gui(player)
end)

script.on_event(defines.events.on_gui_closed, function(event)
    local player = game.players[event.player_index]
    --close_gui(player)
end)
--]]