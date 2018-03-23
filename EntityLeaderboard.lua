local EntityLeaderboard = {}
local Entry = require "EntityLeaderboard.Entry"
local SortedEntryArray = require "EntityLeaderboard.SortedEntryArray"

local table_insert = table.insert

function EntityLeaderboard.new(o)
    o = o or {}
    o.keys = o.keys or {}
    o.living_entries = {} --indexed by entity id -> points to TurretEntry object
    o.dead_entries = {} --indexed by unique id -> points to TurretEntry object
    
    o.sorted_entries = {} --map to TurretEntry arrays. index to map should be a self.key
    for key in pairs(o.keys) do
        o.sorted_entries[key] = SortedEntryArray.new{key = key}
    end
    return o
end

function EntityLeaderboard:addKey(key)
    self.keys[key] = 1
    self.sorted_entries[key] = SortedEntryArray.new{key = key}
end

function EntityLeaderboard:modify(entry, key, new_value)
    local array = o.sorted_entries[key]
    array:modify(entry, new_value)
end

function EntityLeaderboard:add(entry)
    if entry.entity ~= nil then
        self.living_entries[entity.unit_number] = entry
    else
        table_insert(self.dead_entries, entry)
    end
    
    for key in pairs(self.keys) do
        self.sorted_entries[key]:insert(entry)
    end
end

function EntityLeaderboard:getSortedArray(key)
    return self.sorted_entries[key].array
end

function EntityLeaderboard:getByRank(key, rank)
    return self.sorted_entries[key].array[rank]
end

function EntityLeaderboard:getByEntityId(entity)
    return self.living_entries[entity.unit_number]
end










