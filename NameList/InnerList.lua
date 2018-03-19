--require "NameList.Lexer"
--require "NameList.Parser"
require "NameList.Entry"
require "NameList.MasterList"
require "NameList.Expression"


NameList = NameList or {}

NameList.InnerList = NameList.InnerList or {}
NameList.SimpleList = NameList.SimpleList or {}
NameList.ComplexList = NameList.ComplexList or {}

local InnerList = NameList.InnerList
local SimpleList = NameList.SimpleList
local ComplexList = NameList.ComplexList
local Entry = NameList.Entry
local Expression = NameList.Expression

setmetatable(SimpleList, {__index = InnerList})
setmetatable(ComplexList, {__index = InnerList})


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


--[[
    SimpleList
    A list that has only numeric weights meaning that unless elements are added to the list,
    its weight table will never need to be recalculated

    Ex.
    "{AnimalAdjective} {Animal Name}"       #Explict weight is omitted, implicily assumed to be 1
    [2] "{AnimalAdjective} {Animal Name}"   #Explict weight is 2
    [2 + 5] "{First} {Second} {Third}"      #Explict weight is 7
--]]
function SimpleList.new(o)
    o = InnerList.new(o)
    setmetatable(o, {__index = SimpleList})
    return o
end

function SimpleList.repairMetatable(o)
    InnerList.repairMetatable(o)
    setmetatable(o, {__index = SimpleList})
end

function SimpleList:buildWeightTable()
    self:purgeWeightTable()
    local total_weight = 0
    for i, weight in ipairs(self.weights) do
        if type(weight) ~="table" then
            weight = 1 
        else
            weight = Expression.evaluate(weight)
        end
        total_weight = total_weight + weight
        table.insert(self.running_weight, total_weight)
    end
    self.total_weight = total_weight
end

--[[
    ComplexList
    A list that has only entries with weights dependent on the weights of the lists referenced in those entries.
    This means that this list's weight table needs to be recalculated if any elements are ever added to a dependent.
    Weights in this list are expressions which can be understood in more detail in NameList.Expression.lua

    Ex.
    [%1 * %2] "{AnimalAdjective} {Animal Name}"
    [%2 + 5] "{First} {Second} {Third}"
--]]
function ComplexList.new(o)
    o = InnerList.new(o)
    setmetatable(o, {__index = ComplexList})
    return o
end

function ComplexList.repairMetatable(o)
    InnerList.repairMetatable(o)
    setmetatable(o, {__index = ComplexList})
end

-- This is incomplete and/or wrong. I am leaving this here only to avoid butchering the main code
function ComplexList:buildWeightTable(master_list)
    self:purgeWeightTable()
    local total_weight = 0
    for i, weight in ipairs(self.weights) do
        --calculate weight from token list here and make additional recursive build weight table calls
        local entry = self.entries[i]
        total_weight = total_weight + Expression.evaluate(weight, entry.referenced_lists, master_list)
        table.insert(self.running_weight, total_weight)
    end
    self.total_weight = total_weight
end