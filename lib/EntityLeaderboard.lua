local EntityLeaderboard = {}
local Entry = require "lib.EntityLeaderboard.Entry"
local SortedEntryArray = require "lib.EntityLeaderboard.SortedEntryArray"

local table_insert = table.insert

local instance_metatable = {__index = EntityLeaderboard}
function EntityLeaderboard.new(o)
    o = o or {}
    o.keys = o.keys or {}
    o.living_entries = {} --indexed by entity id -> points to TurretEntry object
    o.dead_entries = {} --indexed by unique id -> points to TurretEntry object
    
    o.sorted_entries = {} --map to TurretEntry arrays. index to map should be a self.key
    for k, v in pairs(o.keys) do
        o.sorted_entries[v] = SortedEntryArray.new{key = v}
    end
    o.keys = nil

    setmetatable(o, instance_metatable)
    return o
end

function EntityLeaderboard.repairMetatable(o)
    setmetatable(o, instance_metatable)
    for _, array in pairs(o.sorted_entries) do
        SortedEntryArray.repairMetatable(array)
    end
end

function EntityLeaderboard:modify(entry, key, new_value)
    local array = self.sorted_entries[key]
    array:modify(entry, new_value)
end

function EntityLeaderboard:add(entry)
    if entry.entity ~= nil then
        self.living_entries[entry.entity.unit_number] = entry
    else
        table_insert(self.dead_entries, entry)
    end
    
    for _, array in pairs(self.sorted_entries) do
        array:insert(entry)
    end
end

function EntityLeaderboard:kill(entry)
end

function EntityLeaderboard:getSortedArray(key)
    return self.sorted_entries[key].array
end

function EntityLeaderboard:getByRank(key, rank)
    return self.sorted_entries[key].array[rank]
end

function EntityLeaderboard:getByEntity(entity)
    return self.living_entries[entity.unit_number]
end

return EntityLeaderboard