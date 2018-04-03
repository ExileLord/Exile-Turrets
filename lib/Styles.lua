Styles = {}

local prefix = "exile-leaderboard-"

--Defaults
Styles.label = prefix .. "default-label"
Styles.frame = prefix .. "default-frame"

--Header Buttons
Styles.header_button = prefix .. "header-button"
Styles.scrollpane = prefix .. "scrollpane"
Styles.table = prefix .. "table"
Styles.table_cell_flow = prefix .. "cell-flow"
Styles.table_type_cell_flow = prefix .. "type-cell-flow"


Styles.rank_label = prefix .. "rank-label"
Styles.rank1_label = prefix .. "rank1-label"
Styles.rank2_label = prefix .. "rank2-label"
Styles.rank3_label = prefix .. "rank3-label"

Styles.name_label = prefix .. "name-label"
Styles.name_rank1_label = prefix .. "name-rank1-label"
Styles.name_rank2_label = prefix .. "name-rank2-label"
Styles.name_rank3_label = prefix .. "name-rank3-label"
--Names
Styles.turret_preview = prefix .. "turret-preview"

Styles.column_widths = {}
Styles.column_widths.rank = 50
Styles.column_widths.type = 50
Styles.column_widths.name = 300
Styles.column_widths.damage_dealt = 100
Styles.column_widths.damage_taken = 100


return Styles