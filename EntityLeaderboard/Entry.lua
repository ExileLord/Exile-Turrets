local Entry = {}


function Entry.new(o)
    o = o or {}
    assert(o.keys ~= nil)
    --o.entity
    o.rank = {}
    o.value = {}
    for k in pairs(o.keys) do
        o.rank[key] = 0
        o.value[key] = 0
    end
    return o
end


return Entry