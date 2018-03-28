local colors = require("lib.Colors")
local styles = require("lib.Styles")

local style = data.raw["gui-style"]["default"]

--Defaults
style[styles.label] =
{
    type = "label_style",
    font = "default",
}
style[styles.frame] =
{
    type = "frame_style",
}

--Header Buttons
style[styles.header_button] =
{
    type = "button_style",
    font = "default",
    padding = 2,
}


--Rank
style[styles.rank_label] =
{
    parent = styles.label,
    type = "label_style",
}
style[styles.rank1_label] =
{
    parent = styles.rank_label,
    type = "label_style",
    font = "default-bold",
    font_color = colors.first_place
}
style[styles.rank2_label] =
{
    parent = styles.rank_label,
    type = "label_style",
    font = "default-bold",
    font_color = colors.second_place
}

style[styles.rank3_label] =
{
    parent = styles.rank_label,
    type = "label_style",
    font = "default-bold",
    font_color = colors.third_place
}

--Names
style[styles.name_label] =
{
    parent = styles.label,
    type = "label_style",
}
style[styles.name_rank1_label] =
{
    parent = styles.name_label,
    type = "label_style",
    font = "default-bold",
    font_color = colors.first_place
}
style[styles.name_rank2_label] =
{
    parent = styles.name_label,
    type = "label_style",
    font = "default-bold",
    font_color = colors.second_place
}
style[styles.name_rank3_label] =
{
    parent = styles.name_label,
    type = "label_style",
    font = "default-bold",
    font_color = colors.third_place
}

--Picture
style[styles.turret_preview] =
{
    type = "entity_button_style",
    height = 50,
    width = 50,
    background_color = {},
    default_background = {}
}

--Tables
style[styles.table] =
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
style[styles.scrollpane] =
{
    type = "scroll_pane_style",
}