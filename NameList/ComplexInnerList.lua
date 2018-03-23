local InnerList = require "NameList.InnerList"
local ComplexList = {}
setmetatable(ComplexList, {__index = InnerList})
local Expression = require "NameList.Expression"

--[[
    ComplexList
    A list that has only entries with weights dependent on the weights of the lists referenced in those entries.
    This means that this list's weight table needs to be recalculated if any elements are ever added to a dependent.
    Weights in this list are expressions which can be understood in more detail in NameList.Expression.lua

    Ex.
    [%1 * %2] "{AnimalAdjective} {Animal Name}"
    [%2 + 5] "{First} {Second} {Third}"
--]]
local instance_metatable = {__index = ComplexList}
function ComplexList.new(o)
    o = InnerList.new(o)
    setmetatable(o, instance_metatable)
    return o
end

function ComplexList.repairMetatable(o)
    InnerList.repairMetatable(o)
    setmetatable(o, instance_metatable)
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