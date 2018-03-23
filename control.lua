require "hover_text"
require "turrets"
require "gui"


--Currently the only
local default_name_list_text = require("default_name_list")
local Parser = require "NameList.Parser"
local MasterList = require "NameList.MasterList"

script.on_init(function()
    global.master_list = global.master_list or Parser.parse(default_name_list_text)
    hover_text_initialize()
    turrets_initialize()
    gui_initialize()
end
)

script.on_load(function()
    MasterList.repairMetatable(global.master_list)
    hover_text_load()
    turrets_load()
    gui_load()
end
)



script.on_event("exile-turrets-open-leaderboard-gui", function(event)
    local player = game.players[event.player_index]
    open_gui(player)
end)

script.on_event(defines.events.on_gui_closed, function(event)
    local player = game.players[event.player_index]
    close_gui(player)
end)