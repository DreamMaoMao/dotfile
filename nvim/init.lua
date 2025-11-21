-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
require("config.lazyvim")

-- tty环境把东西拷贝到tmux
if os.getenv("XDG_SESSION_TYPE") == "tty" then
  vim.g.clipboard = {
    name = "tmuxClipboard",
    copy = {
      ["+"] = { "tmux", "load-buffer", "-" },
      ["*"] = { "tmux", "load-buffer", "-" },
    },
    paste = {
      ["+"] = { "tmux", "save-buffer", "-" },
      ["*"] = { "tmux", "save-buffer", "-" },
    },
    cache_enabled = true,
  }
elseif os.getenv("HOME") ~= "/root" and (not os.getenv("XDG_SESSION_TYPE") or os.getenv("XDG_SESSION_TYPE") == "") then
  vim.g.clipboard = {
    name = "universal clipboard",
    copy = {
      ["+"] = { "cb", "copy" },
      ["*"] = { "cb", "copy" },
    },
    paste = {
      ["+"] = { "cb", "paste" },
      ["*"] = { "cb", "paste" },
    },
    cache_enabled = true,
  }
end

vim.opt.hidden = false
-- vim.opt.autochdir = true

vim.opt.number = true
vim.opt.relativenumber = false

-- ccc picker
vim.opt.termguicolors = true

-- vim.opt.clipboard = "unnamedplus"
vim.opt.clipboard = "unnamedplus"

vim.g.autoformat = false

vim.g.snacks_animate = false

vim.cmd("colorscheme gruvbox")
vim.cmd([[highlight Cursorline guibg=#3c3836]])
