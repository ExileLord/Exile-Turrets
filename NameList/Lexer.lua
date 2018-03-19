-- Responsible for lexing a text into a series of tokens to be parsed by the Parser

require "NameList.Token"

NameList = NameList or {}
NameList.Lexer = NameList.Lexer or {}


local Token = NameList.Token
local Lexer = NameList.Lexer

function Lexer.isEscaped(s, index)
    local parity = false
    while index > 1 do
        index = index - 1
        local c = string.sub(s, index, index)
        if c=='\\' then
            parity = not parity
        else
            break
        end
    end
    return parity
end

function Lexer.findUnescaped(s, pattern, start)
    local start_index, end_index
    start = start or 1
    end_index = start
    while end_index ~= nil do
        start_index, end_index = string.find(s, pattern, end_index)
        if start_index ~= nil then
            if not Lexer.isEscaped(s, start_index) then
                return start_index, end_index
            end
            end_index = end_index + 1
        end
    end

    return nil, nil
end





--[[
    Create token functions and the associated table
]]

local function create_eof_token(s, index)
    return Token.new{type=Token.types.eof}, nil
end

local function create_string_token(s, index)
    local token = Token.new{type=Token.types.string}

    assert(string.sub(s,index,index)=='"', "Attempted to tokenize non-string text.")
    local end_index = Lexer.findUnescaped(s, "\"", index + 1)
    assert(end_index ~= nil, "Found unescaped string while parsing.")

    token.value = string.sub(s, index+1, end_index-1)
    return token, end_index+1
end

local function create_literal_token(s, index)
    local token = Token.new{type=Token.types.literal}

    local start_index, end_index = string.find(s, "%d+%.?%d*", index)
    assert(start_index==index, "Found malformed literal while parsing.")
    token.value = tonumber(string.sub(s, start_index, end_index))

    return token, end_index+1
end

local function create_identifier_token(s, index)
    local token = Token.new{type=Token.types.identifier}
    
    local start_index, end_index = string.find(s, "%a[%w_]*", index)
    assert(start_index==index, "Found malformed identifier while parsing." .. string.sub(s, index, index + 20))
    token.value = string.sub(s, start_index, end_index)

    return token, end_index+1
end

local function create_list_placeholder_token(s, index)
    local token = Token.new{type=Token.types.list_placeholder}
    
    local start_index, end_index = string.find(s, "%%%d*", index)
    assert(start_index==index, "Found malformed list placeholder while parsing.")
    token.value = tonumber(string.sub(s, start_index+1, end_index))

    return token, end_index+1
end

local function create_parentheses_block_token(s, index)
    local token = Token.new{type=Token.types.parentheses_block}
    token.value = string.sub(s, index, index)
    return token, index+1
end

local function create_list_block_token(s, index)
    local token = Token.new{type=Token.types.list_block}
    token.value = string.sub(s, index, index)
    return token, index+1
end

local function create_weight_block_token(s, index)
    local token = Token.new{type=Token.types.weight_block}
    token.value = string.sub(s, index, index)
    return token, index+1
end

local function create_separator_token(s, index)
    local token = Token.new{type=Token.types.separator}
    token.value = string.sub(s, index, index)
    return token, index+1
end

local function create_operator_token(s, index)
    local token = Token.new{type=Token.types.operator}
    token.value = string.sub(s, index, index)
    return token, index+1
end

local function create_comment_token(s, index)
    local token = Token.new{type=Token.types.comment}

    local start_index, end_index = string.find(s, "#[^\n]*", index)
    assert(start_index==index, "Found malformed comment while parsing.")
    token.value = string.sub(s, start_index+1, end_index)

    return token, end_index+1
end

--create token function table
local create_token =
{
    [Token.types.eof] = create_eof_token,
    [Token.types.identifier] = create_identifier_token,
    [Token.types.string] = create_string_token,
    [Token.types.literal] = create_literal_token,
    [Token.types.list_placeholder] = create_list_placeholder_token,
    [Token.types.parentheses_block] = create_parentheses_block_token,
    [Token.types.list_block] = create_list_block_token,
    [Token.types.weight_block] = create_weight_block_token,
    [Token.types.separator] = create_separator_token,
    [Token.types.operator] = create_operator_token,
    [Token.types.comment] = create_comment_token,
}





--[[
    Lexing function and helpers
--]]

local token_differentiator_table =
{
    ["\""] = Token.types.string,
    ["("] = Token.types.parentheses_block,
    [")"] = Token.types.parentheses_block,
    ["{"] = Token.types.list_block,
    ["}"] = Token.types.list_block,
    ["["] = Token.types.weight_block,
    ["]"] = Token.types.weight_block,
    ["%"] = Token.types.list_placeholder,
    ["+"] = Token.types.operator,
    ["-"] = Token.types.operator,
    ["*"] = Token.types.operator,
    ["/"] = Token.types.operator,
    [","] = Token.types.separator,
    ["#"] = Token.types.comment,
    ["0"] = Token.types.literal,
    ["1"] = Token.types.literal, 
    ["2"] = Token.types.literal, 
    ["3"] = Token.types.literal, 
    ["4"] = Token.types.literal, 
    ["5"] = Token.types.literal, 
    ["6"] = Token.types.literal, 
    ["7"] = Token.types.literal, 
    ["8"] = Token.types.literal, 
    ["9"] = Token.types.literal  
}

local function identify_token_type(s, index)
    local c = string.sub(s, index, index)
    if c==nil then
        return Token.types.eof
    end

    local type = token_differentiator_table[c]
    if type ~= nil then
        return type
    end

    return Token.types.identifier
end

local function find_next_token(s, index)
    return string.find(s, "%S", index)
end

--Lexes a text into a token list
function Lexer.lex(s)
    local token_list = {}
    local index = 1
    local maxlen = #s

    while index <= maxlen do
        index = find_next_token(s, index)
        if index == nil then
            break
        end

        local type = identify_token_type(s, index)
        local token
        if type == nil then
            break
        end
        token, index = create_token[type](s,index)
        if token.type ~= Token.types.comment then --Don't insert comments in order to make parsing easier later
            table.insert(token_list, token)
        end
    end

    local eof = create_eof_token()
    table.insert(token_list, eof)

    return token_list
end