local InnerList = {}
local Entry = require "NameList.Entry"


--[[
    InnerList
    The base class for a list
    Do not call this directly
--]]
function InnerList.new(o)
    o = o or {}
    o.entries = {} --list of NameList.Entry classes
    o.weights = {} --Expressions

    o.running_weight = {} --list of increasing numeric weights.
                           --running_weight[1] = weight[1],
                           --running_weight[2] = weight[1]+weight[2], ...

    o.total_weight = 0 --the total weight of the list
                        --should be equal to the last element in running_weight,
    --setmetatable(o, {__index = InnerList})
    return o
end

function InnerList.repairMetatable(o)
    for k, entry in pairs(o.entries) do
        Entry.repairMetatable(entry)
    end
end


function InnerList:size()
    return #self.entries --todo figure out if I can override the # operator and if that's bad practice
end

function InnerList:add(entry, weight)
    weight = weight or 1
    table.insert(self.entries, entry)
    table.insert(self.weights, weight)
    return #self.entries
end

function InnerList:buildWeightTable() error("Cannot directly call abstract method") end

function InnerList:purgeWeightTable()
    self.running_weight = {}
    self.total_weight = 0
end


--Gets a random index in the weight array based on the given weights
local function get_weighted_index(weight_array)
    local min = 1
    local max = #weight_array
    local target_weight = math.random() * weight_array[max]
    local index

    assert(max >= min)

    while true do
        index = math.floor((min + max) / 2)
        local weight = weight_array[index]

        if (max - min <= 1) then
            if target_weight <= weight_array[min] then
                return min
            elseif target_weight <= weight_array[max] then
                return max
            else    
                return max + 1 --In a true binary search this case isn't needed but since we're not searching for exact values we can undershoot
            end
        end
        
        if weight < target_weight then
            min = index
        else
            max = index
        end
    end
end

--Returns a random name list entry in this inner list
--Returns NameList.Entry
function InnerList:randomEntry(master_list)
    if #self.entries == 0 then
        return ""
    end

    assert(self:weight(master_list) > 0, "Tried to get random entry from a table with 0 weight.")

    local index = get_weighted_index(self.running_weight)
    assert(index >= 1 and index <= #self.running_weight, "get_weighted_index returned out of bounds index")
    return self.entries[index]
end

function InnerList:weight(master_list)
    if #self.entries == 0 then 
        return 0 
    end

    if self.total_weight == 0 then
        self:buildWeightTable(master_list)
    end
    
    return self.total_weight
end

return InnerList



