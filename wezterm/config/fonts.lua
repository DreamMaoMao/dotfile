local wezterm = require('wezterm')

local font = 'Maple Mono NF CN' -- JetBrains Mono
local font_size = 20

return {
   font = wezterm.font(font),
   font_size = font_size,
   warn_about_missing_glyphs = false,
}
