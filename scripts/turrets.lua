--!deprecated - moving to LeaderboardUpdater

require("scripts.helpers")
EntityLeaderboard = require "EntityLeaderboard"

Turret = Turret or {}


--locals
local MAX_NAME_REGENERATION_ATTEMPTS = 7
local turret_table
local dead_turret_array
local turret_leaderboard
local turret_count
local names_in_use
local master_list

--locals
local leaderboard

--Reason why a turret died
local kill_reasons =
{
    ["unknown"] = 0,
    ["enemy"] = 1,
    ["retired"] = 2,
    ["friendly_fire"] = 3,
    ["suicide"] = 4
}



-- Gets the corresponding turret entry for the given turret entity
function get_turret_entry(e)
    return turret_table[e.unit_number]
end

local function default_leaderboard_sort(a, b)
    local kills1 = Turret.kills(a)
    local kills2 = Turret.kills(b)
    if kills1 ~= kills2 then
        return kills1 > kills2
    end

    return Turret.damageDealt(a) > Turret.damageDealt(b)
end

function get_leaderboard_sorted(sort_function)
    sort_function = sort_function or default_leaderboard_sort
    local sorted_list = {}
    for k,v in pairs(turret_table) do
        table.insert(sorted_list, v)
    end
    table.sort(sorted_list, sort_function)
    return sorted_list
end

-- Unlinks a turret entry from a turret entity. Typically this is done because the turret died and is about to be destroyed
local function unlink_turret(turret)
    local e = turret.entity
    turret.dead_kills = e.kills
    turret.dead_damage_dealt = e.damage_dealt
    turret.entity = nil
end

--Should be called whenever a turret entity is placed on the world
--Sets turret names and sets a turret entry in the stat tracking tables for it
local function add_turret(e)
    turret_count = turret_count + 1

    local turret = Turret.new{entity=e}
    names_in_use[turret.name] = (names_in_use[turret.name] or 0) + 1
    local key = e.unit_number
    turret_table[key] = turret
    debug_print(string.format( "Turret \"%s\" added under key %s. Count: %d", turret.name, tostring(key), turret_count) )

    return turret
end

--Should be called whenever a turret entity is removed
--Performs various stat tracking and cleanup
local function remove_turret(e, cause_of_death)
    turret_count = turret_count - 1

    local key = e.unit_number
    
    -- Remove the turret from the table
    local turret = turret_table[key]
    if (turret == nil) then
        debug_print("Tried to remove turret that didn't exist in the turret table! Key: %s", tostring(key))
        return nil
    end
    turret_table[key] = nil

    -- Add to dead turrets array
    table.insert(dead_turret_array, turret)
    unlink_turret(turret)
    turret.cause_of_death = cause_of_death

    -- Update names in use
    names_in_use[turret.name] = names_in_use[turret.name] - 1
    if names_in_use[turret.name] == 0 then
        names_in_use[turret.name] = nil
    end

    

    debug_print(string.format( "Turret \"%s\" removed under key %s. Cause of death: %d. Count: %d", turret.name, tostring(key), cause_of_death, turret_count) )

    return turret
end

local turretname_to_namelist_map =
{
    ["gun-turret"] = "GunTurretName",
    ["artillery-turret"] = "ArtilleryTurretName",
    ["artillery-wagon"] = "ArtilleryTurretName",
    ["laser-turret"] = "LaserTurretName",
    ["flamethrower-turret"] = "FlamethrowerTurretName"
}

local turrettype_to_namelist_map = 
{
    ["default"] = "GunTurretName",
    ["ammo-turret"] = "GunTurretName",
    ["artillery-turret"] = "ArtilleryTurretName",
    ["artillery-wagon"] = "ArtilleryTurretName",
    ["electric-turret"] = "LaserTurretName",
    ["fluid-turret"] = "FlamethrowerTurretName"
}

--TODO: restructure this. It's gross and not optimal
local function name_list_for_turret_variant(e)
    assert(e ~= nil)
    --Try name first
    local name_list_text = turretname_to_namelist_map[e.name]
    if name_list_text ~= nil and master_list:get(name_list_text) == nil then
        name_list_text = nil
    end

    --Fall back on type
    if name_list_text == nil then
        name_list_text = turrettype_to_namelist_map[e.type]
    end
    if name_list_text ~= nil and master_list:get(name_list_text) == nil then
        name_list_text = nil
    end

    --Fall back on default
    if name_list_text == nil then
        name_list_text = turrettype_to_namelist_map["default"]
    end

    return master_list:get(name_list_text)
end

local function generate_name(e)
    local name_list = name_list_for_turret_variant(e)
    if (name_list ~= nil) then
        for i = 1, MAX_NAME_REGENERATION_ATTEMPTS do
            name = name_list:randomName(master_list)
            if names_in_use[name] == nil then
                break
            end
        end
        return name
    else
        error("Found nil when trying to retrieve name list for " .. e.name)
    end
end


function Turret.new(o)
    o = o or {}
    o.damage_taken = o.damageTaken or 0
    o.damage_healed = o.damageHealed or 0
    o.medals = o.medals or {}
    o.cause_of_death = o.cause_of_death or kill_reasons.unknown
    --o.entity = o.entity or nil
    --o.kills = o.kills or 0
    --o.damage = o.damage or 0
    if o.name==nil and o.entity~=nil then
        o.name = generate_name(o.entity)
    end
    setmetatable(o, {__index = Turret})
    return o
end

function Turret:kills()
    return self.dead_kills or self.entity.kills
end

function Turret:damageDealt()
    return self.dead_damage_dealt or self.entity.damage_dealt
end

function Turret:type()
    return "Unknown"
end





-- Initializer

local function build_turret_table_surface_filtered(surface, type)

    local entities = surface.find_entities_filtered{type = type}

    for k, entity in pairs(entities) do
        if get_turret_entry(entity)==nil then
            add_turret(entity)
        end
    end
end

local function build_turret_table_surface(surface)
    local turret_types = 
    {
        ["ammo-turret"] = true,
        ["artillery-turret"] = true,
        ["artillery-wagon"] = true,
        ["electric-turret"] = true,
        ["fluid-turret"] = true
    }
    for type in pairs(turret_types) do
        build_turret_table_surface_filtered(surface, type)
    end
end

local function build_turret_table()
    for k, surface in pairs(game.surfaces) do
        build_turret_table_surface(surface)
    end
end



-- ▄▄▄▄▄▄▄▄▄▄▄  ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ 
--▐░░░░░░░░░░░▌▐░░▌      ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
-- ▀▀▀▀█░█▀▀▀▀ ▐░▌░▌     ▐░▌ ▀▀▀▀█░█▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ 
--     ▐░▌     ▐░▌▐░▌    ▐░▌     ▐░▌          ▐░▌     
--     ▐░▌     ▐░▌ ▐░▌   ▐░▌     ▐░▌          ▐░▌     
--     ▐░▌     ▐░▌  ▐░▌  ▐░▌     ▐░▌          ▐░▌     
--     ▐░▌     ▐░▌   ▐░▌ ▐░▌     ▐░▌          ▐░▌     
--     ▐░▌     ▐░▌    ▐░▌▐░▌     ▐░▌          ▐░▌     
-- ▄▄▄▄█░█▄▄▄▄ ▐░▌     ▐░▐░▌ ▄▄▄▄█░█▄▄▄▄      ▐░▌     
--▐░░░░░░░░░░░▌▐░▌      ▐░░▌▐░░░░░░░░░░░▌     ▐░▌     
-- ▀▀▀▀▀▀▀▀▀▀▀  ▀        ▀▀  ▀▀▀▀▀▀▀▀▀▀▀       ▀      
                                                    
-- Called in on_init
function turrets_initialize()
    --Init globals
    global.turret_table = global.turret_table or {}
    global.dead_turret_array = global.dead_turret_array or {}
    global.turret_leaderboard = global.turret_leaderboard or {}

    --Init locals
    turrets_load()

    --Code to be run the first time the mod runs
    build_turret_table()
end

-- Called in on_load
function turrets_load()
    --Init locals
    turret_table = global.turret_table
    master_list = global.master_list
    dead_turret_array = global.dead_turret_array
    names_in_use = {}
    turret_count = 0

    --Fix locals
    for k,turret in pairs(turret_table) do
        setmetatable(turret, {__index = Turret})
        turret_count = turret_count + 1
        names_in_use[k] = (names_in_use[k] or 0) + 1
    end
end






-- ▄▄▄▄▄▄▄▄▄▄▄  ▄               ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄        ▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ 
--▐░░░░░░░░░░░▌▐░▌             ▐░▌▐░░░░░░░░░░░▌▐░░▌      ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
--▐░█▀▀▀▀▀▀▀▀▀  ▐░▌           ▐░▌ ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌░▌     ▐░▌ ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ 
--▐░▌            ▐░▌         ▐░▌  ▐░▌          ▐░▌▐░▌    ▐░▌     ▐░▌     ▐░▌          
--▐░█▄▄▄▄▄▄▄▄▄    ▐░▌       ▐░▌   ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌ ▐░▌   ▐░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄ 
--▐░░░░░░░░░░░▌    ▐░▌     ▐░▌    ▐░░░░░░░░░░░▌▐░▌  ▐░▌  ▐░▌     ▐░▌     ▐░░░░░░░░░░░▌
--▐░█▀▀▀▀▀▀▀▀▀      ▐░▌   ▐░▌     ▐░█▀▀▀▀▀▀▀▀▀ ▐░▌   ▐░▌ ▐░▌     ▐░▌      ▀▀▀▀▀▀▀▀▀█░▌
--▐░▌                ▐░▌ ▐░▌      ▐░▌          ▐░▌    ▐░▌▐░▌     ▐░▌               ▐░▌
--▐░█▄▄▄▄▄▄▄▄▄        ▐░▐░▌       ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌     ▐░▐░▌     ▐░▌      ▄▄▄▄▄▄▄▄▄█░▌
--▐░░░░░░░░░░░▌        ▐░▌        ▐░░░░░░░░░░░▌▐░▌      ▐░░▌     ▐░▌     ▐░░░░░░░░░░░▌
-- ▀▀▀▀▀▀▀▀▀▀▀          ▀          ▀▀▀▀▀▀▀▀▀▀▀  ▀        ▀▀       ▀       ▀▀▀▀▀▀▀▀▀▀▀ 
                                                                                    
--Building
script.on_event({defines.events.on_built_entity, defines.events.on_robot_built_entity}, function(event)
    local entity = event.created_entity
    if is_turret(entity) then
        add_turret(entity)
    end
end
)

--Killed
script.on_event({defines.events.on_entity_died}, function(event)
    local entity = event.entity
    if entity==nil or not is_turret(entity) then
        return
    end

    local cause = event.cause
    local force = event.force
    local kill_reason
    if cause == entity then
        kill_reason = kill_reasons.suicide
    elseif entities_are_friendly(entity, cause, force) then
        kill_reason = kill_reasons.friendly_fire
    elseif cause ~= nil then
        kill_reason = kill_reasons.enemy
    else
        kill_reason = kill_reasons.unknown
    end

    remove_turret(entity, kill_reason)
end
)

--Mining
script.on_event({defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity}, function(event)
    local entity = event.entity
    if is_turret(entity) then
        remove_turret(entity, kill_reasons.retired)
    end
    --Attempt to rename and swallow errors if it fails. Hopefully nothing bad happens!
    --pcall(tryRename,event)
end
)