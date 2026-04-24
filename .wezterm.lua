local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({
  options = {
    icons_enabled = true,
    tabs_enabled = true,
    --theme = "Grayscale Dark (base16)",
    theme_overrides = {},
    section_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
    component_separators = {
      left = wezterm.nerdfonts.pl_left_soft_divider,
      right = wezterm.nerdfonts.pl_right_soft_divider,
    },
    tab_separators = {
      left = wezterm.nerdfonts.pl_left_hard_divider,
      right = wezterm.nerdfonts.pl_right_hard_divider,
    },
  },
  sections = {
    --tabline_a = { 'mode' },
    --tabline_b = { 'workspace' },
    tabline_c = { ' ' },
    tab_active = {
      'index',
      { 'parent', padding = 0 },
      '/',
      { 'cwd', padding = { left = 0, right = 1 } },
      { 'zoomed', padding = 0 },
    },
    tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
    tabline_x = { 'ram', 'cpu' },
    tabline_y = { 'datetime', 'battery' },
    tabline_z = { 'domain' },
  },
  extensions = {},
})
tabline.get_config()
tabline.apply_to_config(config)

--config.color_scheme = 'GruvboxDarkHard'

config.font_size = 9.0
--config.font = wezterm.font("CommitMono")
config.automatically_reload_config = true
config.window_decorations = "NONE"
config.tab_bar_at_bottom = true
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.max_fps = 120
config.keys = {
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.CloseCurrentTab { confirm = true },
  },
}
config.keys = {
  { key = 'p', mods = 'ALT', action = wezterm.action.ShowTabNavigator },
}
return config
