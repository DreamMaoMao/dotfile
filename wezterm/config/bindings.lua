local wezterm = require('wezterm')
local platform = require('utils.platform')()
local act = wezterm.action

local mod = {}

if platform.is_mac then
   mod.SUPER = 'SUPER'
   mod.SUPER_REV = 'SUPER|CTRL'
elseif platform.is_win then
   mod.SUPER = 'ALT' -- to not conflict with Windows key shortcuts
   mod.SUPER_REV = 'ALT|CTRL'
end

local keys = {
   { key = 'c',      mods = 'CTRL|SHIFT',        action = act.CopyTo('Clipboard') },
   { key = 'v',      mods = 'CTRL|SHIFT',        action = act.PasteFrom('Clipboard') },
   { key = 'o',      mods = 'CTRL',              action = "QuickSelect"},
   { key = 'Space',      mods = 'CTRL|SHIFT',    action = "ActivateCopyMode"},
}

local key_tables = {
   -- copy_mode = {
   --    {
   --      key = 'v',
   --      mods = 'NONE',
   --      action = act.CopyMode { SetSelectionMode = 'Cell' },
   --    },
   --  },
--    resize_font = {
--       -- { key = 'k',      action = act.IncreaseFontSize },
--       -- { key = 'j',      action = act.DecreaseFontSize },
--       -- { key = 'r',      action = act.ResetFontSize },
--       -- { key = 'Escape', action = 'PopKeyTable' },
--       -- { key = 'q',      action = 'PopKeyTable' },
--    },
--    resize_pane = {
--       -- { key = 'k',      action = act.AdjustPaneSize({ 'Up', 1 }) },
--       -- { key = 'j',      action = act.AdjustPaneSize({ 'Down', 1 }) },
--       -- { key = 'h',      action = act.AdjustPaneSize({ 'Left', 1 }) },
--       -- { key = 'l',      action = act.AdjustPaneSize({ 'Right', 1 }) },
--       -- { key = 'Escape', action = 'PopKeyTable' },
--       -- { key = 'q',      action = 'PopKeyTable' },
--    },
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
      event={Up={streak=1, button="Right"}},
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
   -- leader = { key = 'Space', mods = 'CTRL|SHIFT' },
   keys = keys,
   -- key_tables = key_tables,
   mouse_bindings = mouse_bindings,
}
