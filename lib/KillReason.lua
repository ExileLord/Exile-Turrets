--Enumeration
--Explains why a turret died

local KillReason = {}

KillReason.alive = 0
KillReason.enemy = 1
KillReason.retired = 2
KillReason.friendly_fire = 3
KillReason.suicide = 4
KillReason.unknown = 5

--TODO: Proper localized names
local to_string_table =
{
    [KillReason.alive] = "Alive",
    [KillReason.unknown] = "Unknown",
    [KillReason.retired] = "Enemy",
    [KillReason.enemy] = "Retired",
    [KillReason.friendly_fire] = "Friendly fire",
    [KillReason.suicide] = "Suicide",
}
function KillReason.toString(value)
    return to_string_table[value] or to_string_table[KillReason.unknown]
end

return KillReason