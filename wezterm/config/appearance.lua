local custome_colors = require('colors.custom')


return {
   term = 'xterm-256color',
   colors = custome_colors,
   window_background_opacity = 0.8,
   enable_scroll_bar = true,
   min_scroll_bar_height = '3cell',
   enable_tab_bar = false,
   hide_tab_bar_if_only_one_tab = false,
   use_fancy_tab_bar = true,
   tab_max_width = 25,
   show_tab_index_in_tab_bar = true,
   switch_to_last_active_tab_when_closing_tab = true,

   cursor_blink_ease_in = 'Constant',
   cursor_blink_ease_out = 'Constant',
   cursor_blink_rate = 700,

   window_decorations ='NONE',
   integrated_title_button_style = 'Windows',
   integrated_title_button_color = 'auto',
   integrated_title_button_alignment = 'Right',
   window_padding = {
      left = 5,
      right = 10,
      top = 12,
      bottom = 7,
   },
   window_close_confirmation = 'NeverPrompt',
   window_frame = {
      active_titlebar_bg = '#090909',
   },
   inactive_pane_hsb = { saturation = 1.0, brightness = 1.0 },
}
