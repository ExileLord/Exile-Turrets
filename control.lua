require("hover-text")
require("turrets")
require("NameList")

--Currently the only
local default_name_list_text = require("default_name_list")


script.on_init(function()
    global.master_list = global.master_list or NameList.parse(default_name_list_text)
    turrets_initialize()
end
)

script.on_load(function()
    MasterList.repairMetatable(global.master_list)
    turrets_load()
end
)
