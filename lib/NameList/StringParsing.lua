-- StringParsing
-- Small independent module providing some helper functions for parsing/lexing NameList texts

local StringParsing = {}

local sub = string.sub
local find = string.find
local insert = table.insert
local concat = table.concat

function StringParsing.isEscaped(s, index)
    local parity = false
    while index > 1 do
        index = index - 1
        local c = sub(s, index, index)
        if c=='\\' then
            parity = not parity
        else
            break
        end
    end
    return parity
end
local is_escaped = StringParsing.isEscaped

--TODO: Double check this code (specifically the end_index part)
function StringParsing.findUnescaped(s, pattern, start)
    local start_index, end_index, new_line_start
    start = start or 1
    end_index = start
    new_line_start = find(s, "\n", start)

    while end_index ~= nil do
        start_index, end_index = find(s, pattern, end_index)

        if start_index ~= nil then
            if new_line_start ~= nil and end_index >= new_line_start then
                return nil, nil
            end

            if not is_escaped(s, start_index) then
                return start_index, end_index
            end
            end_index = end_index + 1
        end
    end

    return nil, nil
end

local replacement_sequence_table =
{
    ["\\"] = "\\",
    ["{"] = "{",
    ["}"] = "}",
    ["\""] = "\"",
}
function StringParsing.replaceEscapeSequences(s)
    local sb = {}
    local next_index = 1
    while true do
        local escape_index = find(s, "\\", next_index)
        if escape_index ~= nil then
            local c = sub(s, escape_index+1, escape_index+1)
            assert(c ~= nil, "Unmatched escape sequence found at end of line")
            local replacement = replacement_sequence_table[c]
            assert(replacement ~= nil, "Invalid escape sequence")

            insert(sb, sub(s, next_index, escape_index-1))
            insert(sb, replacement)
            next_index = escape_index + 2
        else
            insert(sb, sub(s, next_index))
            break
        end
    end

    local new_string = concat(sb)
    return new_string
end

return StringParsing