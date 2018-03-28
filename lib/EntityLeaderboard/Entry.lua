local Entry = {}

function Entry.new(o)
    o = o or {}
    --o.entity
    o.rank = {}
    o.value = o.value or {}
    for key, value in pairs(o.value) do
        o.rank[key] = 0
        --o.value[key] = 0
    end
    return o
end


return Entry