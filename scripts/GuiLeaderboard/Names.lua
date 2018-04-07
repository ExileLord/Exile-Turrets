--Names for gui elements in a gui leaderboard
local Names = {}

Names.frame = "exile_leaderboard_frame"
Names.header = "leaderboard_header"
Names.scrollpane = "leaderboard_scroll_pane"
Names.keys_table = "leaderboard_keys_table"
Names.table = "leaderboard_table"
Names.options = "leaderboard_options"
Names.inner_table_cell = "a"

local MAX_CELL_NAME_CACHE = 2000

-- These are useful for autocompletion purposes and causing errors if they are misspelled
Names.rank = "rank"
Names.type = "type"
Names.name = "name"
Names.kills = "kills"
Names.damage_dealt = "damage_dealt"
Names.damage_taken = "damage_taken"
Names.kill_reason = "kill_reason"
Names.age = "age"

Names.keys =
{
    "rank",
    "type",
    "name",
    "kills",
    "damage_dealt",
    "damage_taken",
    "kill_reason",
    "age",
}
local small_keys_array =
{
    "r",
    "t",
    "n",
    "k",
    "d",
    "p",
    "o",
    "a"
}

local function build_map(t1, t2)
    local map = {}
    local reverse = {}
    for i = 1, #t1 do
        map[t1[i]] = t2[i]
        reverse[t2[i]] = t1[i]
    end
    return map, reverse
end

local small_keys, small_keys_reverse = build_map(Names.keys, small_keys_array)
Names.small_keys = small_keys
Names.small_keys_reverse = small_keys_reverse

local function build_derivative_map(tail)
    local map = {}
    local reverseMap = {}
    for _, k in ipairs(Names.keys) do
        local v = k .. tail
        map[k] = v
        reverseMap[v] = k
    end
    return map, reverseMap
end

Names.table_option, Names.table_option_reverse = build_derivative_map("_option")
Names.table_header, Names.table_header_reverse = build_derivative_map("_header")

local table_cell_map = {}
local table_cell_map_reverse = {}
for _, k in ipairs(Names.keys) do
    local map = { n = MAX_CELL_NAME_CACHE }
    for i = 1, MAX_CELL_NAME_CACHE do
        local v = small_keys[k] .. i
        map[i] = v
        table_cell_map_reverse[v] = {k, i}
    end
    table_cell_map[k] = map
end

function Names.tableCell(key, i)
    return table_cell_map[key][i] or small_keys[key] .. i
end

local sub = string.sub
function Names.tableCellReverse(name)
    local t = table_cell_map_reverse[name]
    if t ~= nil then
        return t[1], t[2]
    end
    local key = small_keys_reverse[sub(name,1,1)]
    local index = tonumber(sub(name, 2))
    return key, index
end

return Names