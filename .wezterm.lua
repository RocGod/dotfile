-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = {}

-- Use the config_builder for clearer error messages in newer versions
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Configuration settings
config.automatically_reload_config = true
config.color_scheme = "nord"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 14
config.enable_tab_bar = true
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.8
config.macos_window_background_blur = 10

-- Tab bar settings
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_and_split_indices_are_zero_based = true

-- tmux status
wezterm.on("update-right-status", function(window, _)
  local SOLID_LEFT_ARROW = ""
  local ARROW_FOREGROUND = { Foreground = { Color = "#c6a0f6" } }
  local prefix = ""

  if window:leader_is_active() then
    prefix = " " .. utf8.char(0x1f30a) -- ocean wave
    SOLID_LEFT_ARROW = utf8.char(0xe0b2)
  end

  if window:active_tab():tab_id() ~= 0 then
    ARROW_FOREGROUND = { Foreground = { Color = "#1e2030" } }
  end -- arrow color based on if tab is first pane

  window:set_left_status(wezterm.format {
    { Background = { Color = "#b7bdf8" } },
    { Text = prefix },
    ARROW_FOREGROUND,
    { Text = SOLID_LEFT_ARROW }
  })
end)

-- Return the configuration to wezterm
return config