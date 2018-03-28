--Names for gui elements in a gui leaderboard
Names = {}

Names.frame = "exile_leaderboard_frame"
Names.header = "leaderboard_header"
Names.scrollpane = "leaderboard_scroll_pane"
Names.keys_table = "leaderboard_keys_table"
Names.table = "leaderboard_table"

Names.rank = "r"
Names.picture = "p"
Names.name = "n"
Names.kills = "k"
Names.damage_dealt = "dd"
Names.damage_taken = "dt"

local header = "h"
Names.rank_header = Names.rank .. header
Names.picture_header = Names.picture .. header
Names.name_header = Names.name .. header
Names.kills_header = Names.kills .. header
Names.damage_dealt_header = Names.damage_dealt .. header
Names.damage_taken_header = Names.damage_taken .. header


local cell = "c"
local rank_cell = Names.rank .. cell
local picture_cell = Names.picture .. cell
local name_cell = Names.name .. cell
local kills_cell = Names.kills .. cell
local damage_dealt_cell = Names.damage_dealt .. cell
local damage_taken_cell = Names.damage_taken .. cell

function Names.rank_cell(row) return rank_cell .. row end
function Names.picture_cell(row) return picture_cell .. row end
function Names.name_cell(row) return name_cell .. row end
function Names.kills_cell(row) return kills_cell .. row end
function Names.damage_dealt_cell(row) return damage_dealt_cell .. row end
function Names.damage_taken_cell(row) return damage_taken_cell .. row end

return Names