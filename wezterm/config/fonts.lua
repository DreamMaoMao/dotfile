local wezterm = require('wezterm')
local platform = require('utils.platform')

local function isx11()
  local display = os.getenv("WAYLAND_DISPLAY")
  if display then
    return false
  else
    return true
  end
end

local font = 'Maple Mono NF CN' -- JetBrains Mono
local font_size = platform().is_win and 16 or isx11() and 13 or 18



return {
   font = wezterm.font(font),
   font_size = font_size,
   warn_about_missing_glyphs = false,

   --ref: https://wezfurlong.org/wezterm/config/lua/config/freetype_pcf_long_family_names.html#why-doesnt-wezterm-use-the-distro-freetype-or-match-its-configuration
   freetype_load_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
   freetype_render_target = 'Normal', ---@type 'Normal'|'Light'|'Mono'|'HorizontalLcd'
}
