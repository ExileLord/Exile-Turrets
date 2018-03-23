-- The parser that generates a series of name lists (a master list) from a set of lexed tokens

local Parser = {}
local NameList = require "NameList"
local Token = require "NameList.Token"
local Lexer = require "NameList.Lexer"
local Entry = require "NameList.Entry"
local Expression = require "NameList.Expression"
local MasterList = require "NameList.MasterList"

local assert = assert
local token_types = Token.types

--local type_separator = token_types.separator

local function parse_pure_entry(list, start)
    local entry = Entry.new()
    local i = start
    local token = list[i]
    local s

    -- Multiple strings will be concatenated
    repeat
        assert(token ~= nil, "Reached end of file while parsing list entry.")
        if token.type ~= token_types.string then
             error("Found unexpected" .. Token.type_names[token.type] .. " while parsing list entry. Expected comma separator or string.")
        end

        if s == nil then 
            s = token.value
        else
            s = s .. token.value -- should be rare
        end
        i = i + 1
        token = list[i]
    until token.type == token_types.separator or token.type == token_types.list_block

    entry:parse(s)

    return entry, i 
end

local function parse_weight_inner(list, start)
end

local function parse_weight(list, start)
    local i = start
    local token = list[i]
    assert(token ~= nil and token.type == token_types.weight_block and token.value == "[", "Error parsing weight block.")
    while token~=nil do
        i = i + 1
        token = list[i]
        assert(token ~= nil, "Reached end of file while parsing weight block.")
        if token.type == token_types.weight_block then
            assert(token.value == "]", "Cannot nest weight blocks inside of a weight block.")
            break
        end
    end

    local expression
    if i - start > 1 then
        expression = Expression.new{token_list = {table.unpack(list, start + 1, i - 1)}}
    end
    return expression, i + 1
end



local function parse_entry(list, start)
    local i = start
    local token = list[i]
    
    local weight, entry

    assert(token ~= nil, "Reached end of file while parsing list entry.")
    if token.type == token_types.weight_block then
        weight, i = parse_weight(list, i)
    end

    entry, i = parse_pure_entry(list, i)

    return weight, entry, i
end



local function parse_list(list, start)
    local i = start
    local token = list[i]
    local name_list

    assert(token.type == token_types.identifier, "Error while parsing name list. Expected identifier")
    local name = token.value

    name_list = NameList.new{name=name}

    --Check for opening brace
    i = i + 1
    token = list[i]
    assert(token.value == "{", "Expected \"{\" following list name identifier.")

    --Parse list content
    i = i + 1
    token = list[i]
    while token.type ~= token_types.list_block do
        if (token.type ~= token_types.separator) then
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
    local eof = token_types.eof
    while token ~= nil and token.type ~= eof do
        local name_list
        name_list, i = parse_list(token_list, i)
        master_list:add(name_list)
        token = token_list[i]
    end

    return master_list
end

return Parser