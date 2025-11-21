local wezterm = require 'wezterm'
local io = require 'io'
local os = require 'os'
local act = wezterm.action

local M = {} 


M.setup = function() 
    wezterm.on('trigger-vim-with-scrollback', function(window, pane)
      -- Retrieve the text from the pane
      local text = pane:get_lines_as_text(pane:get_dimensions().scrollback_rows)

      -- Create a temporary file to pass to vim
      local name = os.tmpname()
      local f = io.open(name, 'w+')
      f:write(text)
      f:flush()
      f:close()

      -- Open a new window running vim and tell it to open the file
      window:perform_action(
        act.SpawnCommandInNewTab {
          args = { 'nvim', name , '+$'},
        },
        pane
      )

      -- Wait "enough" time for vim to read the file before we remove it.
      -- The window creation and process spawn are asynchronous wrt. running
      -- this script and are not awaitable, so we just pick a number.
      --
      -- Note: We don't strictly need to remove this file, but it is nice
      -- to avoid cluttering up the temporary directory.
      wezterm.sleep_ms(1000)
      os.remove(name)
    end)
end

return M