--NameList = NameList or {}
--NameList.Token = NameList.Token or {}

local Token = {} --{NameList.Token}


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
    return o
end

return Token