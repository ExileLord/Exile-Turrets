-- A mathematical expression that can be evaluated
-- Used to represent weights in name lists

local NameListToken = require "NameList.Token"
local ExpressionToken = {}
local Expression = {}

local insert = table.insert
local remove = table.remove

local token_types =
{
    operator = 0,
    literal = 1,
    list = 2
}

local op_precedence =
{
    ["*"] = 3,
    ["/"] = 3,
    ["+"] = 2,
    ["-"] = 2
}


local function add(op1, op2)
    return op1 + op2
end

local function subtract(op1, op2)
    return op1 - op2
end

local function multiply(op1, op2)
    return op1 * op2
end

local function divide(op1, op2)
    return op1 / op2
end

local do_operation = 
{
    ["+"] = add,
    ["-"] = subtract,
    ["*"] = multiply,
    ["/"] = divide
}


local function new_expression_token(type, value)
    return { ["type"] = type, ["value"] = value }
end

local function is_foldable(rpn_list)
    for i,token in ipairs(rpn_list) do
        if token.type == token_types.list then
            return false
        end
    end
    return true
end

-- Evaluates a reverse polish notation (RPN) expression and returns a number.
-- rpn_list is expected to be a lua array formatted as a series of Expression tokens
-- referenced_lists is a table of strings indexed by an integer. An entry of [%1*%2]"{ListA}{ListB}" should have a referenced_lists table composed of {[1]="ListA", [2]="ListB"}
-- master_list is the MasterList to which the referenced lists belong
-- If the expression references no lists, referenced_list and master_list can be safely omitted
local function evaluate(rpn_list, referenced_lists, master_list)
    local stack = {} --literal stack
    local list
    for i,token in ipairs(rpn_list) do
        if token.type == token_types.literal then
            insert(stack, token.value)
        elseif token.type == token_types.operator then
            local op2 = remove(stack)
            local op1 = remove(stack)
            local result = do_operation[token.value](op1, op2)
            insert(stack, result)
        else
            insert(stack, master_list:get(referenced_lists[token.value]):weight())
        end
    end
    return stack[#stack]
end


local function infix_to_rpn(token_list)
    local types = NameListToken.types

    local output = {} --Expression token
    local stack = {} --NameList.Token
    
    for k, token in ipairs(token_list) do
        if token.type == types.literal then
            insert(output, new_expression_token(token_types.literal, token.value))

        elseif token.type == types.list_placeholder then
            insert(output, new_expression_token(token_types.list, token.value))

        elseif token.type == types.operator then
            local precedence = op_precedence[token.value]
            while #stack > 0 do
                local top_op = stack[#stack]
                local top_op_precedence = op_precedence[top_op.value] or 0
                if top_op_precedence < precedence then
                    break
                end
                if top_op.type == types.operator then
                    insert( output, new_expression_token(token_types.operator, top_op.value) )
                end
                remove(stack)
            end
            insert( stack, token )

        elseif token.type == types.parentheses_block then
            if token.value == "(" then
                insert( stack, token )
            else
                local top_op
                while #stack > 0 do
                    top_op = stack[#stack]
                    if top_op.value == "(" then
                        break
                    end
                    if top_op.type == types.operator then
                        insert( output, new_expression_token(token_types.operator, top_op.value) )
                    end
                    remove(stack)
                end

                assert(top_op ~= nil and top_op.value == "(", "Mismatched parentheses in expression")
                remove(stack)
            end

        else
            error("Encountered unexpected token")
        end
    end

    while #stack > 0 do
        local token = remove(stack)
        assert(token.type == types.operator, "Mismatched parentheses in expression")
        insert( output, new_expression_token(token_types.operator, token.value) )
    end

    return output
end
--]]

function Expression.new(o)
    o = o or {}
    if o.rpn_list == nil and o.token_list ~= nil then
        o.rpn_list = infix_to_rpn(o.token_list)
        if (is_foldable(o.rpn_list)) then
            o.value = evaluate(o.rpn_list)
        end
    end
    return o
end

function Expression:evaluate(referenced_lists, master_list)
    if self.value ~= nil then
        return self.value
    else
        return evaluate(self.rpn_list, referenced_lists, master_list)
    end
end

return Expression