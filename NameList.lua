require "NameList.Lexer"
require "NameList.Parser"
require "NameList.Entry"
require "NameList.InnerList"


NameList = NameList or {}
MasterList = NameList.MasterList or {}

local Parser = NameList.Parser
local InnerList = NameList.InnerList
local SimpleList = NameList.SimpleList
local ComplexList = NameList.ComplexList
local MasterList = NameList.MasterList






--Checks for cycles in th
function CycleCheck(list, checked)
    checked = checked or {}
end

function NameList:AssertNoLoops()
    for list, dependencies in pairs(self.complex_dependencies) do
    end
end

--[[
    The NameList, a random name generator
--]]
function NameList.new(o)
    --List must have a name
    if (o == nil or o.name == nil) then
        error("NameList constructor called without a valid name parameter.")
    end

    --Name must be unique
    --if (NameList.lists[o.name] ~= nil) then
    --    error("A NameList must have a unique name.")
    --end

    setmetatable(o, {__index = NameList})

    o.simple_list = SimpleList.new()
    o.complex_list = ComplexList.new()
    --o.dependents = {}

    --NameList.lists[o.name] = o
    return o
end

function NameList.repairMetatable(o)
    if getmetatable(o) ~= nil then
        return
    end
    setmetatable(o, {__index = NameList})
    SimpleList.repairMetatable(o.simple_list)
    ComplexList.repairMetatable(o.complex_list)
end

local function is_weight_complex(token_chain)
    if token_chain == nil or type(token_chain) ~= "table" then
        return false
    end

    for i, token in ipairs(token_chain) do
        if token.type == Token.types.list_placeholder then
            return true
        end
    end

    return false
end

function NameList:recalculateWeight(o)
    error("Not implemented yet.")
end

--Adds an entry to a name list with the given weight
--(TODO) Weight should be a NameList expression
function NameList:add(entry, weight)
    weight = weight or 1
    assert(weight > 0, "Weight must be greater than zero.")

    if (is_weight_complex(weight)) then
        self.complex_list:add(entry, weight)
    else
        self.simple_list:add(entry,weight)
    end
end

--Returns a random name generated this name list based on the weights given to it
--If this name list references any other lists in its entries, master_list is required or it will error
function NameList:randomName(master_list)
    local list

    if self.complex_list:size() == 0 then
        list = self.simple_list
    else
        local weight = math.random() * self.total_weight
        if weight < self.simple_list.total_weight then
            list = self.simple_list
        else
            list = self.complex_list
        end
    end

    local entry = list:randomEntry()
    local name = entry:toString(master_list)
    return name
end

-- Parses a NameList text
-- returns a MasterList
function NameList.parse(text)
    return Parser.parse(text)
end