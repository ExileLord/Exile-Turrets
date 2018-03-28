--various helper functions used by different areas of code

local Misc = {}

local is_turret_tbl = 
{
    ["ammo-turret"] = true,
    ["artillery-turret"] = true,
    ["artillery-wagon"] = true,
    ["electric-turret"] = true,
    ["fluid-turret"] = true,
}
function Misc.isTurret(e)
    if e==nil then
        return false
    end

    return is_turret_tbl[e.type] or false
end


--TODO: Check extensively for correctness
function Misc.entitiesAreFriendly(entity1, entity2, force2)
    if entity1 == nil then
        return false
    end
    local force1 = entity1.force

    if force2 == nil and entity2 ~= nil then
        force2 = entity2.force
    end
    if force2 == nil then
        return false
    end

    if force1.name == force2.name then
        return true
    end

    if force1.get_friend(force2) then
        return true
    end

    if force1.get_cease_fire(force2) then
        return true
    end

    return false
end

return Misc