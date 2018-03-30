--Names for gui elements in a gui leaderboard
local Names = {}

Names.frame = "exile_leaderboard_frame"
Names.header = "leaderboard_header"
Names.scrollpane = "leaderboard_scroll_pane"
Names.keys_table = "leaderboard_keys_table"
Names.table = "leaderboard_table"
Names.options = "leaderboard_options"

local MAX_CELL_NAME_CACHE = 1000


--TODO: Don't think these most of these are used and/or useful. Confirm and remove
Names.rank = "rank"
Names.type = "type"
Names.name = "name"
Names.kills = "kills"
Names.damage_dealt = "damage_dealt"
Names.damage_taken = "damage_taken"
Names.keys =
{
    "rank",
    "type",
    "name",
    "kills",
    "damage_dealt",
    "damage_taken",
}
local small_keys_array =
{
    "r",
    "t",
    "n",
    "k",
    "d",
    "p"
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

function Names.keyExists(key)
    return small_keys[key] ~= nil
end


function Names.tableCell(key, i)
    return table_cell_map[key][i] or small_keys_map[key] .. i
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

    --[[
local cell = ""
local rank_cell = Names.rank .. cell
local type_cell = Names.type .. cell
local name_cell = Names.name .. cell
local kills_cell = Names.kills .. cell
local damage_dealt_cell = Names.damage_dealt .. cell
local damage_taken_cell = Names.damage_taken .. cell
function Names.rank_cell(row) return rank_cell .. row end
function Names.type_cell(row) return type_cell .. row end
function Names.name_cell(row) return name_cell .. row end
function Names.kills_cell(row) return kills_cell .. row end
function Names.damage_dealt_cell(row) return damage_dealt_cell .. row end
function Names.damage_taken_cell(row) return damage_taken_cell .. row end
]]

return Names