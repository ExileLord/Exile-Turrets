require "NameList.Lexer"

NameList = NameList or {}
NameList.Entry = NameList.Entry or {}

local Lexer = NameList.Lexer
local Entry = NameList.Entry
local EntryPiece = {}

function EntryPiece.new(o)
    o = o or {}
    setmetatable(o, {__index = EntryPiece})
    --is_list
    --text
    return o
end

function EntryPiece:toList(master_list)
    assert(self.is_list, "Attempted to convert non-list name entry piece into a list.")
    return master_list:get(self.text)
end

function Entry.new(o)
    o = o or {}
    o.entries = o.entries or {} --List of EntryPiece objects to construct a string with
    o.referenced_lists = o.referenced_lists or {} --Table of with list names as key and number of references as value
    setmetatable(o, {__index = Entry} )

    if o.text ~= nil then
        o:parse(o.text)
    end

    return o
end

function Entry.repairMetatable(o)
    setmetatable(o, {__index = Entry})
    for k, piece in pairs(o.entries) do
        setmetatable(piece, {__index = EntryPiece})
    end
end

local replacement_sequence_table =
{
    ["\\"] = "\\",
    ["{"] = "{",
    ["}"] = "}",
    ["\""] = "\"",
}

local function replace_escape_sequences(s)
    local sb = {}
    local next_index = 1
    while true do
        local escape_index = string.find(s, "\\", next_index)
        if escape_index ~= nil then
            local c = string.sub(s, escape_index+1, escape_index+1)
            assert(c ~= nil, "Unmatched escape sequence found at end of line")
            local replacement = replacement_sequence_table[c]
            assert(replacement ~= nil, "Invalid escape sequence")

            table.insert(sb, string.sub(s, next_index, escape_index-1))
            table.insert(sb, replacement)
            next_index = escape_index + 2
        else
            table.insert(sb, string.sub(s, next_index))
            break
        end
    end

    local new_string = table.concat(sb)
    return new_string
end

function Entry:parse(str)

    local next_index = 1
    while true do
        list_open_index = Lexer.findUnescaped(str, "{", next_index)
        list_close_index = Lexer.findUnescaped(str, "}", next_index)

        --Ensure all lists references are well formed
        if  list_close_index ~= nil and (list_open_index > list_close_index) then
            error("Unmatched \"}\" found in name list entry.")
        end

        if (list_open_index~=nil) ~= (list_close_index~=nil) then
            if list_open_index ~= nil then
                error("Unmatched \"{\" found in name list entry.")
            else
                error("Unmatched \"}\" found in name list entry.")
            end
        end

        --[[if list_open_index ~= nil and (list_close_index - list_open_index == 1) then
            error("A list reference can't be empty!")
        end--]]
        
        --Extract the currently parsed chunks.
        local textChunk, listChunk
        if list_open_index ~= nil then
            textChunk = string.sub(str, next_index, list_open_index-1)
            listChunk = string.sub(str, list_open_index+1, list_close_index-1)
        else
            textChunk = string.sub(str, next_index)
        end

        --Insert text chunk
        if textChunk:len() > 0 then
            textChunk = replace_escape_sequences(textChunk)
            local piece = EntryPiece.new{text=textChunk, is_list=false}
            table.insert(self.entries, piece)
        end

        --Insert list chunk
        if listChunk ~= nil then
            listChunk = replace_escape_sequences(listChunk)
            local piece = EntryPiece.new{text=listChunk, is_list=true}
            table.insert(self.entries, piece)
            table.insert(self.referenced_lists, listChunk)
            --self.references[listChunk] = (self.references[listChunk] or 0) + 1
        end
        
        if list_close_index==nil then
            return
        end
        next_index = list_close_index + 1
    end
end

function Entry:toString(master_list)
    local s = ""

    for i, entry in ipairs(self.entries) do
        if (entry.is_list) then
            s = s .. entry:toList(master_list):randomName(master_list)
        else
            s = s .. entry.text
        end
    end

    return s
end