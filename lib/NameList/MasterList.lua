-- MasterList
-- A list of name lists. If a name list ever references another list, it must have a reference to the master list that holds it

local MasterList = {}

local root = (...):match("(.-)[^%.]+$")
local NameList = require(root .. "List")

local _mt = {__index = MasterList}
function MasterList.new(o)
    o = o or {}
    o.lists = o.lists or {}
    setmetatable(o, _mt)
    return o
end

function MasterList.repairMetatable(o)
    setmetatable(o, _mt)
    for k, list in pairs(o.lists) do
        NameList.repairMetatable(list)
    end
end

--Removes all entries from the MasterList
function MasterList:purge()
    self.lists = {}
end

--Retrieves a NameList with a name matching the given string
function MasterList:get(name_list_string)
    assert(name_list_string ~= nil, "Attempted to retrieve nil from master list. Expected name list name.")

    return self.lists[name_list_string]
end

--Removes a NameList object with a name matching the given string from this master list.
--Returns the removed NameList
function MasterList:remove(name_list_string)
    assert(name_list_string ~= nil, "Attempted to remove nil from master list. Expected name list name.")

    self.lists[name_list_string] = nil

    return list
end

--Adds a NameList object to this MasterList
function MasterList:add(name_list)   
    assert(name_list ~= nil, "Attempted to add nil to master list. Expected name list.")
    assert(self.lists[name_list.name] == nil, string.format("Attempted to add duplicate name list \"%s\" to master list.", name_list.name))

    self.lists[name_list.name] = name_list
end

function MasterList:randomName(name_list_string)
    local list = self.lists[name_list_string]

    assert(list ~= nil, string.format("Attempted to retrieve non-existant name list \"%s\" from master list while generating random name.", name_list_string))

    return list:randomName(self)
end

function MasterList:clone()
    error("Not implemented")
end

function MasterList.merge(master_list_1, master_list_2)   
    error("Not implemented")
end

return MasterList