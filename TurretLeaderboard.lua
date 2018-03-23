local TurretLeaderboard = {}
local TurretEntry = {}
local Rank = {}
local Score = {}

function TurretLeaderboard.new(o)
    o = o or {}
    o.keys = o.keys or {}
    o.living_entries = {} --indexed by entity id -> points to TurretEntry object
    o.dead_entries = {} --indexed by unique id -> points to TurretEntry object
    
    o.sorted_entries = {} --map to TurretEntry arrays. index to map should be a self.key
    for k in pairs(o.keys) do
        o.sorted_entries[k] = {}
    end
    return o
end

function TurretLeaderboard.build(params)
    local keys = params.keys or {
        kills = 1,
        damage_dealt = 1,
        damage_taken = 1,
        name = 1,
    }
    local master_list = params.master_list

    assert(master_list ~= nil)
end

function TurretLeaderboard:addKey(key)
    self.keys[key] = 1
    self.sorted_entries[key] = {}
end


function TurretLeaderboard:add(turret_entry)

end

return TurretLeaderboard










