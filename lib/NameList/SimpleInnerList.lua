-- SimpleList : InnerList
-- A list that has only numeric weights meaning that unless elements are added to the list, its weight table will never need to be recalculated
--
-- Ex.
-- "{AnimalAdjective} {Animal Name}"       #Explict weight is omitted, implicily assumed to be 1
-- [2] "{AnimalAdjective} {Animal Name}"   #Explict weight is 2
-- [2 + 5] "{First} {Second} {Third}"      #Explict weight is 7

local SimpleList = {}

local root = (...):match("(.-)[^%.]+$")
local Expression = require(root .. "Expression")
local InnerList = require(root .. "InnerList")

setmetatable(SimpleList, {__index = InnerList}) -- Subclass of InnerList

local _mt = {__index = SimpleList}
function SimpleList.new(o)
    o = InnerList.new(o)
    setmetatable(o, _mt)
    return o
end

function SimpleList.repairMetatable(o)
    InnerList.repairMetatable(o)
    setmetatable(o, _mt)
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

return SimpleList