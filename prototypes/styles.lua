local Colors = require("lib.Colors")
local Styles = require("lib.Styles")

local style = data.raw["gui-style"]["default"]

local default_cell_right_padding = 5
local default_cell_left_padding = 5

--Defaults
style[Styles.label] =
{
    type = "label_style",
    font = "default",
}
style[Styles.frame] =
{
    type = "frame_style",
}

--Header Buttons
style[Styles.header_button] =
{
    type = "button_style",
    font = "default",
    padding = 0,
    left_padding = default_cell_left_padding,
    right_padding = default_cell_right_padding,
    
    default_font_color = {r=1, g=1, b=1},
    hovered_font_color = {r=0, g=0, b=0},
    clicked_font_color = {r=1, g=1, b=1},
    disabled_font_color = {r=0.5, g=0.5, b=0.5},

    
    

    align = "left",

    --Override default button graphics and make these invisible
    default_graphical_set =
    {
      type = "composition",
      filename = "__core__/graphics/gui.png",
      priority = "extra-high-no-scale",
      load_in_minimal_mode = true,
      corner_size = {3, 3},
      position = {0, 0},
      opacity = 0,
    },
    
    hovered_graphical_set =
    {
      type = "composition",
      filename = "__core__/graphics/gui.png",
      priority = "extra-high-no-scale",
      load_in_minimal_mode = true,
      corner_size = {3, 3},
      position = {0, 8},
      opacity = 0,
    },
    
    clicked_graphical_set =
    {
      type = "composition",
      filename = "__core__/graphics/gui.png",
      priority = "extra-high-no-scale",
      load_in_minimal_mode = true,
      corner_size = {3, 3},
      position = {0, 40},
      opacity = 0,
    },
    
    disabled_graphical_set =
    {
      type = "composition",
      filename = "__core__/graphics/gui.png",
      priority = "extra-high-no-scale",
      load_in_minimal_mode = true,
      corner_size = {3, 3},
      position = {0, 16},
      opacity = 0,
    },
}


--Rank
style[Styles.rank_label] =
{
    parent = Styles.label,
    type = "label_style",
}
style[Styles.rank1_label] =
{
    parent = Styles.rank_label,
    type = "label_style",
    font = "default-bold",
    font_color = Colors.first_place
}
style[Styles.rank2_label] =
{
    parent = Styles.rank_label,
    type = "label_style",
    font = "default-bold",
    font_color = Colors.second_place
}

style[Styles.rank3_label] =
{
    parent = Styles.rank_label,
    type = "label_style",
    font = "default-bold",
    font_color = Colors.third_place
}

--Names
style[Styles.name_label] =
{
    parent = Styles.label,
    type = "label_style",
}
style[Styles.name_rank1_label] =
{
    parent = Styles.name_label,
    type = "label_style",
    font = "default-bold",
    font_color = Colors.first_place
}
style[Styles.name_rank2_label] =
{
    parent = Styles.name_label,
    type = "label_style",
    font = "default-bold",
    font_color = Colors.second_place
}
style[Styles.name_rank3_label] =
{
    parent = Styles.name_label,
    type = "label_style",
    font = "default-bold",
    font_color = Colors.third_place
}

--Picture
style[Styles.turret_preview] =
{
    type = "entity_button_style",
    height = Styles.column_widths.type,
    width = Styles.column_widths.type,
    background_color = {},
    default_background = {}
}

--Tables
style[Styles.table] =
{
    type = "table_style",
    parent = "table_with_selection",
    hovered_row_color = 
    {
        a = 0.7,
        b = 0.22000000000000002,
        g = 0.66000000000000005,
        r = 0.98000000000000007
    },
    selected_row_color = 
    {
        b = 0.22000000000000002,
        g = 0.66000000000000005,
        r = 0.98000000000000007
    },
    odd_row_graphical_set =
    {
        type = "composition",
        filename = "__core__/graphics/gui.png",
        priority = "extra-high-no-scale",
        corner_size = {0, 0},
        position = {78, 18},
        opacity = 0.35
    },
    column_widths =
    {
        { -- rank
            column = 1,
            width = Styles.column_widths.rank
        },        
        { -- type (picture)
            column = 2,
            width = Styles.column_widths.type
        },
        { -- name
            column = 3,
            width = Styles.column_widths.name
        },
    },
    top_padding = 0,
    cell_padding = 0,
    horizontal_spacing = 0,
    vertical_spacing = 0
}
style[Styles.table_cell_flow] =
{
    type = "horizontal_flow_style",
    right_padding = 5,
    left_padding = 5,
}

style[Styles.table_type_cell_flow] =
{
    type = "horizontal_flow_style",
    parent = Styles.table_cell_flow,
    right_padding = 0,
    left_padding = 0,
}

--Scrollpane
style[Styles.scrollpane] =
{
    type = "scroll_pane_style",
}