SortedEntryArray = {}

local table_insert = table.insert
local table_sort = table.sort

local instance_metatable = {__index = SortedEntryArray}
function SortedEntryArray.new(o) 
    --o.key
    assert(o.key)
    setmetatable(o, instance_metatable)
    o.array = {}
end

function SortedEntryArray.repair_metatable(o)
    setmetatable(o, instance_metatable)
end



--find insertion point for new value
local function search(sorted_entry_array, target_value)
    --[16, 14, 14, 14, 13, 12, 9, 3, 0] eg min is biggest
    local array = sorted_entry_array.array
    local key = sorted_entry_array.key
    local min = 1
    local max = #array
    local index

    local math_floor = math.floor
    assert(max >= min)

    while true do
        if max - min <= 1 then
            break
        end

        index = math_floor((min + max) / 2)
        local value = array[index].value[key]
        if value < target_value then
            max = index
        else
            min = index
        end
    end

    index = min
    while index < #array do
        local value = array[index].value[key]
        if value < target_value then
            return index
        end
        index = index + 1
    end

    return index
end

function SortedEntryArray:insert(entry)
    --Try lazy insert first since most inserts should be in last place
    local index = search(sorted_entry_array, entry)
    local array = self.array
    local key = self.key

    --Correct ranks of subsequent entries
    for i = index, #array do
        local rank = array[i].rank
        rank[key] = rank[key] + 1
    end

    table_insert(array, index, entry)
    entry.rank[key] = index
end

function SortedEntryArray:modify(entry, new_value)
    local key = self.key
    local old_value = entry.value[key]
    if new_value == old_value then
        return
    end

    local old_rank = entry.rank[key]
    local array = self.array

    if new_value > old_value then
        for i = old_rank-1, 0, -1 do
            if (i == 0 or new_value <= array[i].value[key]) then -- Shouldn't surpass entries that have equal value but existed prior
                array[i + 1] = entry
                entry.rank[key] = i + 1
                break
            end
            local shifted_entry = array[i]
            shifted_entry.rank[key] = shifted_entry.rank[key] + 1
            array[i + 1] = shifted_entry
        end
    else
        for i = old_rank + 1, #array + 1 do
            if (i == #array + 1 or new_value > array[i].value[key]) then -- Should fall below entries that have equal value but existed prior
                array[i - 1] = entry
                entry.rank[key] = i - 1
                break
            end
            local shifted_entry = array[i]
            shifted_entry.rank[key] = shifted_entry.rank[key] - 1
            array[i - 1] = shifted_entry
        end
    end

    entry.value[key] = new_value
end


--Mutation functions



--Get functions

function SortedEntryArray:get(index)
    return self.array[index]
end

function SortedEntryArray:get_rank(index)
    return self.array[index].rank[key]
end

function SortedEntryArray:get_value(index)
    return self.array[index].value[key]
end

function SortedEntryArray:remove(entry)
end



return SortedEntryArray