local TurretEntry = {}


function TurretEntry.new(o)
    o = o or {}
    assert(o.keys ~= nil)
    o.rank = {}
    o.score = {}
    for k in pairs(o.keys) do
        o.rank[key] = 0
        o.score[key] = 0
    end
    return o
end


return TurretEntry