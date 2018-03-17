require "NameList.Token"
require "NameList.Lexer"
require "NameList.Entry"

NameList = NameList or {}
NameList.Parser = NameList.Parser or {}
NameList.MasterList = NameList.MasterList or {}

local Token = NameList.Token
local Parser = NameList.Parser
local Lexer = NameList.Lexer
local Entry = NameList.Entry
local MasterList = NameList.MasterList


local function parse_pure_entry(list, start)
    local entry = Entry.new()
    local i = start
    local token = list[i]
    local s = ""

    -- Multiple strings will be concatenated
    repeat
        assert(token ~= nil, "Reached end of file while parsing list entry.")
        assert(token.type == Token.types.string, "Found " .. Token.type_names[token.type] .. " while parsing list entry. Expected string.")
        s = s .. token.value --naive concatenation should be find
        i = i + 1
        token = list[i]
    until token.type == Token.types.separator or token.type == Token.types.list_block

    entry:parse(s)

    return entry, i 
end



local function parse_weight(list, start)
    local i = start
    local token = list[i]
    assert(token ~= nil and token.type == Token.types.weight_block and token.value == "[", "Error parsing weight block.")
    while token~=nil do
        i = i + 1
        token = list[i]
        assert(token ~= nil, "Reached end of file while parsing weight block.")
        if token.type == Token.types.weight_block then
            assert(token.value == "]", "Cannot nest weight blocks inside of a weight block.")
            break
        end
    end

    return nil, i + 1
end



local function parse_entry(list, start)
    local i = start
    local token = list[i]
    
    local weight, entry

    assert(token ~= nil, "Reached end of file while parsing list entry.")
    if token.type == Token.types.weight_block then
        weight, i = parse_weight(list, i)
    end

    entry, i = parse_pure_entry(list, i)

    return weight, entry, i
end



local function parse_list(list, start)
    local i = start
    local token = list[i]
    local name_list

    assert(token.type == Token.types.identifier, "Error while parsing name list. Expected identifier. Found " .. Token.type_names[token.type])
    local name = token.value

    name_list = NameList.new{name=name}

    --Check for opening brace
    i = i + 1
    token = list[i]
    assert(token.value == "{", "Expected \"{\" following list name identifier.")

    --Parse list content
    i = i + 1
    token = list[i]
    while token.type ~= Token.types.list_block do
        if (token.type ~= Token.types.separator) then
            local weight, entry
            weight, entry, i = parse_entry(list, i)
            name_list:add(entry, weight)
        else
            i = i + 1 --This is a comma!
        end
        token = list[i]
    end

    --Check for closing brace
    assert(token.value == "}", "Expected \"}\" at the end of list definition.")

    return name_list, i + 1
end



function Parser.parse(s)
    assert(s ~= nil, "Found nil when trying to par")
    local token_list = Lexer.lex(s)
    local i = 1
    local token = token_list[i]

    local master_list = MasterList.new()
    while token ~= nil and token.type ~= Token.types.eof do
        local name_list
        name_list, i = parse_list(token_list, i)
        master_list:add(name_list)
        token = token_list[i]
    end

    return master_list
end

