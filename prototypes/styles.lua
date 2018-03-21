local colors = require "shared_colors"
local style = data.raw["gui-style"]["default"]

--Defaults
style["exile-leaderboard-default-label"] =
{
    type = "label_style",
    font = "default",
}

--Header Buttons
style["exile-leaderboard-header-button"] =
{
    type = "button_style",
    font = "default",
    padding = 2,
}


--Rank
style["exile-leaderboard-rank-label"] =
{
    parent = "exile-leaderboard-default-label",
    type = "label_style",
}
style["exile-leaderboard-rank1-label"] =
{
    parent = "exile-leaderboard-rank-label",
    type = "label_style",
    font = "default-bold",
    font_color = colors.first_place
}
style["exile-leaderboard-rank2-label"] =
{
    parent = "exile-leaderboard-rank-label",
    type = "label_style",
    font = "default-bold",
    font_color = colors.second_place
}

style["exile-leaderboard-rank3-label"] =
{
    parent = "exile-leaderboard-rank-label",
    type = "label_style",
    font = "default-bold",
    font_color = colors.third_place
}

--Names
style["exile-leaderboard-name-label"] =
{
    parent = "exile-leaderboard-default-label",
    type = "label_style",
}
style["exile-leaderboard-name-rank1-label"] =
{
    parent = "exile-leaderboard-name-label",
    type = "label_style",
    font = "default-bold",
    font_color = colors.first_place
}
style["exile-leaderboard-name-rank2-label"] =
{
    parent = "exile-leaderboard-name-label",
    type = "label_style",
    font = "default-bold",
    font_color = colors.second_place
}
style["exile-leaderboard-name-rank3-label"] =
{
    parent = "exile-leaderboard-name-label",
    type = "label_style",
    font = "default-bold",
    font_color = colors.third_place
}

--Picture
style["exile-leaderboard-turret-preview"] =
{
    type = "entity_button_style",
    height = 50,
    width = 50,
    background_color = {},
    default_background = {}
}

--Tables
style["exile-leaderboard-table"] =
{
  type = "table_style",
  hovered_row_color = {
    a = 0.7,
    b = 0.22000000000000002,
    g = 0.66000000000000005,
    r = 0.98000000000000007
  },
  selected_row_color = {
    b = 0.22000000000000002,
    g = 0.66000000000000005,
    r = 0.98000000000000007
  },
  --cell_spacing = 0,
  --horizontal_spacing = 0,
  --vertical_spacing = 0
}

--Scrollpane
style["exile-leaderboard-scrollpane"] =
{
    type = "scroll_pane_style",
    height = 1024
}