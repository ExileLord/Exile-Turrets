-- Manages the entity leaderboard object in the background, updating it based on events that happen in the game
-- Also responsible for building it the first time this mod launches
-- Dependent on MasterList module

local EntityLeaderboard = require "lib.EntityLeaderboard"
local Entry = require "lib.EntityLeaderboard.Entry"
local EntityTools = require "lib.EntityTools"
local Events = require "lib.Events"
local KillReason = require "lib.KillReason"

local LeaderboardUpdater = {}

-- Constants
local LEADERBOARD_KEYS = 
{
    "type",
    "kills",
    "damage_dealt",
    "damage_taken",
    "name",
    "kill_reason",
}

local EVENT_LEADERBOARD_UPDATED = Events.on_leaderboard_update

local MAX_NAME_REGENERATION_ATTEMPTS = 7

-- Locals
local leaderboard --cached global
local master_list --cached global
local names_in_use

-- Cached functions
is_turret = EntityTools.isTurret

-- Declared functions
local build_leaderboard
local add_turret, remove_turret
local build_names_in_use, add_name, remove_name




-- Entity related
local function get_kill_reason(victim, killer, killer_force)
    if killer == nil and killer_force == nil then
        return KillReason.unknown
    end

    if victim == killer then
        return KillReason.suicide
    end

    if EntityTools.entitiesAreFriendly(victim, killer, killer_force) then
        return KillReason.friendly_fire
    end

    return KillReason.enemy
end


----------------
--Name Related--
----------------

-- Local builders (stuff used for caching but that shouldn't be in global)
function build_names_in_use()
    names_in_use = {}

    for _, entry in pairs(leaderboard.living_entries) do
        add_name(entry.value.name)
    end

    for _, entry in pairs(leaderboard.dead_entries) do
        add_name(entry.value.name)
    end
end


local turretname_to_namelist_map =
{
    ["gun-turret"] = "GunTurretName",
    ["artillery-turret"] = "ArtilleryTurretName",
    ["artillery-wagon"] = "ArtilleryTurretName",
    ["laser-turret"] = "LaserTurretName",
    ["flamethrower-turret"] = "FlamethrowerTurretName"
}

--This will be the fallback if there is a modded turret in the game
local turrettype_to_namelist_map = 
{
    ["default"] = "GenericTurretName",
    ["ammo-turret"] = "GunTurretName",
    ["artillery-turret"] = "ArtilleryTurretName",
    ["artillery-wagon"] = "ArtilleryTurretName",
    ["electric-turret"] = "LaserTurretName",
    ["fluid-turret"] = "FlamethrowerTurretName"
}

-- Returns the appropriate NameList instance for generating a random name for the given turret entity
local function name_list_for_turret_variant(e)
    assert(e ~= nil)
    --Try name first
    local name_list_text = turretname_to_namelist_map[e.name]
    if name_list_text ~= nil and master_list:get(name_list_text) ~= nil then
        return master_list:get(name_list_text)
    end

    --Fall back on type
    name_list_text = turrettype_to_namelist_map[e.type]
    if name_list_text ~= nil and master_list:get(name_list_text) ~= nil then
        return master_list:get(name_list_text)
    end

    --Fall back on default
    name_list_text = turrettype_to_namelist_map["default"]
    return master_list:get(name_list_text)
end

local function generate_turret_name(e)
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





----------------------------
-- Leaderboard Management --
----------------------------



--Debug functions
local function print_sorted_array(array, key)
    for k,v in ipairs(array) do
        game.print(string.format("#%d: %s - %s %s", k, v.value["name"], tostring(v.value[key]), key))
    end
end

local function print_leaderboard(leaderboard)
    for k,v in pairs(leaderboard.sorted_entries) do
        print_sorted_array(v.array, k)
    end
end

--Leaderboard building / initialization
local turret_types = 
{
    "ammo-turret",
    "artillery-turret",
    "artillery-wagon",
    "electric-turret",
    "fluid-turret"
}
-- This should be called on initialization or if a new turret type is ever added that isn't tracked yet
local function build_turret_table()
    local get = leaderboard.getByEntity
    names_in_use = names_in_use or {}

    for _, surface in pairs(game.surfaces) do
        for _, type in pairs(turret_types) do
            for _, entity in pairs(surface.find_entities_filtered{type = type}) do
                if get(leaderboard, entity)==nil then
                    add_turret(entity)
                end
            end
        end
    end
end





--Leaderboard manipulation
function add_turret(e)
    local kills = e.kills
    local damage_dealt = e.damage_dealt
    local damage_taken = 0
    local kill_reason = KillReason.alive
    local name = generate_turret_name(e)
    local type = e.name

    local entry = Entry.new{
        entity = e,
        value = 
        {
            kills = kills,
            damage_dealt = damage_dealt,
            damage_taken = damage_taken,
            kill_reason = kill_reason,
            name = name,
            type = type,
        }
    }

    leaderboard:add(entry)
    add_name(name)
end

function kill_turret(e, kill_reason)
    local entry = leaderboard:getByEntity(e)

    local type_event = { 
        old_rank = entry.rank.type, 
        new_rank = entry.rank.type,  
        key = "type",
        entry = entry,
    }

    local kill_reason_event = { 
        old_rank = entry.rank.kill_reason, 
        key = "kill_reason",
        entry = entry,
    }

    if kill_reason ~= nil or entry.value.kill_reason == KillReason.alive then
        leaderboard:modify(entry, "kill_reason", kill_reason or KillReason.unknown)
    end

    kill_reason_event.new_rank = entry.rank.kill_reason

    leaderboard:kill(entry)

    script.raise_event(EVENT_LEADERBOARD_UPDATED, type_event)

    script.raise_event(EVENT_LEADERBOARD_UPDATED, kill_reason_event)
end

function remove_turret(e)
end

function add_name(name)
    names_in_use[name] = (names_in_use[name] or 0) + 1
end

function remove_name(name)
    local i = names_in_use[name] - 1
    if i == 0 then 
        i = nil 
    end
    names_in_use[name] = i
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
                                                                                    
local function cache_globals()
    leaderboard = global.leaderboard
    master_list = global.master_list  
    assert(leaderboard ~= nil, "LeaderboardUpdater was initialized with nil global.leaderboard")
    assert(master_list ~= nil, "LeaderboardUpdater was initialized with nil global.master_list")
end

function LeaderboardUpdater.init()
    --init globals
    global.leaderboard = EntityLeaderboard.new{keys = LEADERBOARD_KEYS}

    cache_globals()

    --construct leaderboard from turrets on the map
    build_turret_table()
end

function LeaderboardUpdater.load()
    cache_globals()
    EntityLeaderboard.repairMetatable(leaderboard)
    build_names_in_use()
end

--Events
local function on_entity_built(event)
    local entity = event.created_entity 
    if entity ~= nil and is_turret(entity) then
        add_turret(entity)
    end
end

local function on_turret_kill(event)
    local turret = event.cause
    local victim = event.entity
    local entry = leaderboard:getByEntity(turret)
    
    local new_event = { old_rank = entry.rank.kills }
    leaderboard:modify(entry, "kills", entry.value.kills + 1)
    new_event.new_rank = entry.rank.kills
    new_event.key = "kills"
    new_event.entry = entry
    script.raise_event(EVENT_LEADERBOARD_UPDATED, new_event)
end

local function on_turret_died(event)
    local turret = event.entity
    local killer = event.cause
    local killer_force = event.force
    local kill_reason = get_kill_reason(turret, killer, killer_force)
    kill_turret(turret, kill_reason)
end

local function on_entity_died(event)
    if is_turret(event.cause) then
        on_turret_kill(event)
    end

    if is_turret(event.entity) then
        on_turret_died(event)
    end
end



local function on_entity_mined(event)
    if is_turret(event.entity) then
        local turret = event.entity
        kill_turret(turret, KillReason.retired)
    end
end



local function on_turret_dealt_damage(event)
    local turret = event.cause
    local entry = leaderboard:getByEntity(turret)
    local new_event = { old_rank = entry.rank.damage_dealt }
    leaderboard:modify(entry, "damage_dealt", turret.damage_dealt)
    new_event.new_rank = entry.rank.damage_dealt
    new_event.key = "damage_dealt"
    new_event.entry = entry
    script.raise_event(EVENT_LEADERBOARD_UPDATED, new_event)
end

local function on_turret_damaged(event)
    local damage = event.final_damage_amount
    local turret = event.entity
    local entry = leaderboard:getByEntity(turret)
    local new_event = { old_rank = entry.rank.damage_taken }
    leaderboard:modify(entry, "damage_taken", entry.value.damage_taken + damage)
    new_event.new_rank = entry.rank.damage_taken
    new_event.key = "damage_taken"
    new_event.entry = entry
    script.raise_event(EVENT_LEADERBOARD_UPDATED, new_event)
end

local function on_entity_damaged(event)
    if is_turret(event.cause) then
        on_turret_dealt_damage(event)
    end

    if is_turret(event.entity) then
        on_turret_damaged(event)
    end
end





local hook_table = 
{
    [defines.events.on_entity_died] = on_entity_died,
    [defines.events.on_entity_damaged] = on_entity_damaged,
    [defines.events.on_built_entity] = on_entity_built,
    [defines.events.on_robot_built_entity] = on_entity_built,
    [defines.events.on_player_mined_entity] = on_entity_mined,
    [defines.events.on_robot_mined_entity] = on_entity_mined,
}
function LeaderboardUpdater.hooks()
    return hook_table
end

return LeaderboardUpdater