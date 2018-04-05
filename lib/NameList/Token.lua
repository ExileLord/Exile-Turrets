-- Token
-- Represents a token from lexing/parsing a NameList text. The grammar is described in more detail in grammar_example.txt

local Token = {}

Token.types = 
{
    eof=0,
    identifier=1,
    string=2,
    literal=3,
    list_placeholder=4,
    parentheses_block=5,
    list_block=6,
    weight_block=7,
    separator=8,
    operator=9,
    comment=10
}

-- Used only for errors / debugging
-- Shouldn't need localization as a result
Token.type_names = 
{
    [Token.types.eof] = "EOF",
    [Token.types.identifier] = "Identifier",
    [Token.types.string] = "String",
    [Token.types.literal] = "Numeric Literal",
    [Token.types.list_placeholder] = "List Placeholder Token",
    [Token.types.parentheses_block] = "Parentheses",
    [Token.types.list_block] = "List Block",
    [Token.types.weight_block] = "Weight Block",
    [Token.types.separator] = "Separator",
    [Token.types.operator] = "Operator",
    [Token.types.comment] = "Comment"
}

function Token.new(o)
    o = o or {}
    assert(o.type ~= nil, "Tokens must have a type associated with them.")
    --value
    return o
end

function Token.debugString(o)
    local token_type_string = Token.type_names[o.type] or string.format("Unknown [%s]", tostring(o.type))

    if o.value == nil then 
        return string.format("(%s)", tostring(token_type_string))
    end
    return string.format("(%s = %s)", token_type_string, tostring(o.value))
end

return Token