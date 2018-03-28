--Enumeration
--Explains why a turret died

local KillReason = {}

local kill_reasons =
{
    ["unknown"] = 0,
    ["enemy"] = 1,
    ["retired"] = 2,
    ["friendly_fire"] = 3,
    ["suicide"] = 4
}

KillReason.unknown = 0
KillReason.enemy = 1
KillReason.retired = 2
KillReason.friendly_fire = 3
KillReason.suicide = 4

--TODO: Proper localized names
local to_string_table =
{
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