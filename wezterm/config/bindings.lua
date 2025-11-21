local wezterm = require('wezterm')
local act = wezterm.action

local keys = {
   {
      key = 'i',
      mods = 'CTRL',
      action = act.EmitEvent 'trigger-vim-with-scrollback',
    },
   { key = 'c',      mods = 'CTRL|SHIFT',        action = act.CopyTo('Clipboard') },
   { key = 'v',      mods = 'CTRL|SHIFT',        action = act.PasteFrom('Clipboard') },
   { key = 'o',      mods = 'CTRL',              action = "QuickSelect"},
   { key = 'Space',      mods = 'CTRL|SHIFT',    action = "ActivateCopyMode"},
}

local mouse_bindings = {
   -- alt + left button drag window
   {
      event = { Drag = { streak = 1, button = 'Left' } },
      mods = 'ALT',
      action = wezterm.action.StartWindowDrag,
   },
   -- Ctrl-click will open the link under the mouse cursor
   {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'CTRL',
      action = act.OpenLinkAtMouseCursor,
   },
  -- enable drag to select 
   {
      event = { Drag = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = act.ExtendSelectionToMouseCursor('Cell'),
   },
   {
      event = { Down = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = act.SelectTextAtMouseCursor('Cell'),
   },
   {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = act.ExtendSelectionToMouseCursor('Cell'),
   },
  
  -- copy the select to clipboard
   {
      event={Up={streak=1, button="Left"}},
      mods="NONE",
      action=wezterm.action{CopyTo="Clipboard"}
   },
  -- right button paste from clipboard
   {
      event={Down={streak=1, button="Right"}},
      mods="NONE",
      action=wezterm.action{PasteFrom="Clipboard"}
   },
   -- Triple Left click will select a line
   {
      event = { Down = { streak = 3, button = 'Left' } },
      mods = 'NONE',
      action = act.SelectTextAtMouseCursor('Line'),
   },
   {
      event = { Up = { streak = 3, button = 'Left' } },
      mods = 'NONE',
      action = act.SelectTextAtMouseCursor('Line'),
   },
   {
      event = { Up = { streak = 3, button = 'Left' } },
      mods = 'NONE',
      action=wezterm.action{CopyTo="Clipboard"},
   },
   -- Double Left click will select a word
   {
      event = { Down = { streak = 2, button = 'Left' } },
      mods = 'NONE',
      action = act.SelectTextAtMouseCursor('Word'),
   },
   {
      event = { Up = { streak = 2, button = 'Left' } },
      mods = 'NONE',
      action = act.SelectTextAtMouseCursor('Word'),
   },
   {
      event = { Up = { streak = 2, button = 'Left' } },
      mods = 'NONE',
      action=wezterm.action{CopyTo="Clipboard"},
   },
   -- Turn on the mouse wheel to scroll the screen
   {
      event = { Down = { streak = 1, button = { WheelUp = 1 } } },
      mods = 'NONE',
      action = act.ScrollByCurrentEventWheelDelta,
   },
   {
      event = { Down = { streak = 1, button = { WheelDown = 1 } } },
      mods = 'NONE',
      action = act.ScrollByCurrentEventWheelDelta,
   },
}

return {
   disable_default_key_bindings = true,
   disable_default_mouse_bindings = true,
   keys = keys,
   mouse_bindings = mouse_bindings,
}
