--Loaded in the order they are given
local modules = {
    require("modules.MasterList"),
    require("modules.LeaderboardUpdater"),
    require("modules.EntityHover"),
    require("modules.GuiLeaderboardManager")
}

--Returns a event_handler that executers each event handler function passed in
local function create_multifunction_handler(functions)
    return function(event)
        for i=1, #functions do
            local fn = functions[i]
            fn(event)
        end
    end
end

--Registers all event handlers in the given modules
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
    for _, module in ipairs(modules) do
        module.init()
    end
end
)

script.on_load(function()
    for _, module in ipairs(modules) do
        module.load()
    end
end
)