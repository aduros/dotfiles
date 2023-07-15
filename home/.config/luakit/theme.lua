local dark1 = "#2E3440"
local dark2 = "#3B4252"
local dark3 = "#434C5E"
local dark4 = "#4C566A"
local light1 = "#D8DEE9"
local light2 = "#E5E9F0"
local light3 = "#ECEFF4"
local blue1 = "#8FBCBB"
local blue2 = "#88C0D0"
local blue3 = "#81A1C1"
local blue4 = "#5E81AC"
local red = "#BF616A"
local orange = "#D08770"
local yellow = "#EBCB8B"
local green = "#A3BE8C"
local purple = "#B48EAD"

local theme = {}

-- Default settings
theme.font = "14px DejaVu Sans Mono"
theme.fg   = light1
theme.bg   = dark1

-- Genaral colours
-- theme.success_fg = "#0f0"
theme.loaded_bg  = green
theme.error_fg = light1
theme.error_bg = red

-- Warning colours
theme.warning_fg = orange

-- Notification colours
theme.notif_bg = yellow
theme.notif_fg = dark1

-- Menu colours
theme.menu_fg                   = light1
theme.menu_bg                   = dark2
theme.menu_selected_fg          = dark1
theme.menu_selected_bg          = blue2
theme.menu_title_bg             = dark1
theme.menu_primary_title_fg     = blue3
theme.menu_secondary_title_fg   = blue3

theme.menu_disabled_fg = "#999"
theme.menu_disabled_bg = theme.menu_bg
theme.menu_enabled_fg = theme.menu_fg
theme.menu_enabled_bg = theme.menu_bg
theme.menu_active_fg = "#060"
theme.menu_active_bg = theme.menu_bg

-- Proxy manager
theme.proxy_active_menu_fg      = dark1
theme.proxy_active_menu_bg      = light1
theme.proxy_inactive_menu_fg    = light1
theme.proxy_inactive_menu_bg    = dark1

-- Statusbar specific
theme.sbar_fg         = light1
theme.sbar_bg         = dark1

-- Downloadbar specific
theme.dbar_fg         = light1
theme.dbar_bg         = dark1
theme.dbar_error_bg   = red

-- Input bar specific
-- theme.ibar_fg           = "#000"
theme.ibar_bg           = "rgba(0,0,0,0)"

-- Tab label
-- theme.tab_fg            = light1
-- theme.tab_bg            = dark1
-- theme.tab_hover_bg      = "#292929"
theme.tab_ntheme        = "#f00"
-- theme.selected_fg       = "#D8DEE9"
theme.selected_bg       = dark4
theme.selected_ntheme   = "#f00"
-- theme.loading_fg        = "#EBCB8B"
-- theme.loading_bg        = "#2E3440"
theme.tab_font          = "16px DejaVu Sans"

theme.selected_private_tab_bg = red
theme.private_tab_bg    = orange

-- Trusted/untrusted ssl colours
theme.trust_fg          = green
theme.notrust_fg        = red

-- Follow mode hints
theme.hint_font = "14px DejaVu Sans Mono"
theme.hint_fg = dark1
theme.hint_bg = yellow
theme.hint_border = "1px dashed #000"
theme.hint_opacity = "0.3"
theme.hint_overlay_bg = "rgba(255,255,153,0.3)"
theme.hint_overlay_border = "1px dotted #000"
theme.hint_overlay_selected_bg = "rgba(0,255,0,0.3)"
theme.hint_overlay_selected_border = theme.hint_overlay_border

-- General colour pairings
theme.ok = { fg = light1, bg = dark1 }
theme.warn = { fg = dark1, bg = yellow }
theme.error = { fg = light1, bg = red }

return theme
