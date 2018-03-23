local NameList = {}

local SimpleList = require "NameList.SimpleInnerList"
local ComplexList = require "NameList.ComplexInnerList"


-- NameList, a random name generator
local instance_metatable = {__index = NameList}
function NameList.new(o)
    --List must have a name
    if (o == nil or o.name == nil) then
        error("NameList constructor called without a valid name parameter.")
    end

    setmetatable(o, instance_metatable)

    o.simple_list = SimpleList.new()
    o.complex_list = ComplexList.new()

    return o
end

function NameList.repairMetatable(o)
    if getmetatable(o) ~= nil then
        return
    end
    setmetatable(o, instance_metatable)
    SimpleList.repairMetatable(o.simple_list)
    ComplexList.repairMetatable(o.complex_list)
end

function NameList:weight(master_list)
    return self.simple_list:weight() + self.complex_list:weight(master_list)
end

--Adds an entry to a name list with the given weight
--entry - NameList.Entry
--weight - NameList.Expression (optional, default:1)
function NameList:add(entry, weight)
    if (weight == nil or weight.value ~= nil) then
        self.simple_list:add(entry, weight)
    else
        self.complex_list:add(entry, weight)
    end
end

--Returns a random name generated this name list based on the weights given to it
--If this name list references any other lists in its entries, master_list is required or it will error
function NameList:randomName(master_list)
    local list

    local weight = math.random() * self:weight(master_list)
    if weight <= self.simple_list:weight() then
        list = self.simple_list
    else
        list = self.complex_list
    end

    local entry = list:randomEntry(master_list)
    local name = entry:toString(master_list)
    return name
end

return NameList