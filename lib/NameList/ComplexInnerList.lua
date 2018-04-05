-- ComplexList : InnerList
-- A list that has only entries with weights dependent on the weights of the lists referenced in those entries.
-- This means that this list's weight table needs to be recalculated if any elements are ever added to a dependent.
-- Weights in this list are expressions which can be understood in more detail in NameList.Expression.lua
--
-- Ex.
-- [%1 * %2] "{AnimalAdjective} {AnimalName}"   #Weight is (Total weight of AnimalAdjective) * (Total weight of AnimalName)
-- [%2 + 5] "{First} {Second} {Third}"          #Weight is (Total weight of Second) + 5

local ComplexList = {}

local root = (...):match("(.-)[^%.]+$")
local Expression = require(root .. "Expression")
local InnerList = require(root .. "InnerList")

setmetatable(ComplexList, {__index = InnerList}) -- Subclass of InnerList

local _mt = {__index = ComplexList}
function ComplexList.new(o)
    o = InnerList.new(o)
    setmetatable(o, _mt)
    return o
end

function ComplexList.repairMetatable(o)
    InnerList.repairMetatable(o)
    setmetatable(o, _mt)
end

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

return ComplexList