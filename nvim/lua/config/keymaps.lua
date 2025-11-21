-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

--keymap
vim.keymap.set("n", "<C-q>", "<cmd>qa<cr>")
-- vim.keymap.set("i", "jj", "<ESC>", { silent = true })
vim.keymap.set("n", ";", ":")
-- vim.keymap.set("n", "<leader>v", "<C-v>", { desc = "toggle visual mode" })
vim.keymap.set({ "v" }, "<leader>k", "<ESC>", { desc = "Esc" })
vim.keymap.set({ "n" }, "<leader>a", ":w<cr>", { desc = "save change" })

-- page move
vim.keymap.set({ "n", "v" }, "<A-j>", "<C-f>", { silent = true })
vim.keymap.set({ "n", "v" }, "<A-k>", "<C-b>", { silent = true })

-- line move
vim.keymap.set({ "n", "v" }, "<S-j>", "5j", { silent = true })
vim.keymap.set({ "n", "v" }, "<S-k>", "5k", { silent = true })

-- word move
vim.keymap.set({ "n", "v" }, "<S-h>", "<A-b>", { silent = true })
vim.keymap.set({ "n", "v" }, "<S-l>", "<A-e>", { silent = true })

-- find setting
-- default is <leader>Space
vim.keymap.set("n", "<leader>ff", function()
  require("fzf-lua").files({ 
    winopts = { width = 1.0, height = 1.0,preview = { layout = "vertical" }},
    fzf_opts = { 
      ["--ansi"]           = true,
      ["--info"]           = "inline-right", -- fzf < v0.42 = "inline"
      ["--height"]         = "100%",
      ["--layout"]         = "reverse",
      ["--border"]         = "none",
      ["--highlight-line"] = true,    
    },
  })
end, { desc = "Search files" })

vim.keymap.set("n", "<leader>fs", function()
  require("fzf-lua").live_grep({ winopts = { width = 1.0, height = 1.0,preview = { layout = "vertical" }},
    fzf_opts = { 
      ["--ansi"]           = true,
      ["--info"]           = "inline-right", -- fzf < v0.42 = "inline"
      ["--height"]         = "100%",
      ["--layout"]         = "reverse",
      ["--border"]         = "none",
      ["--highlight-line"] = true,    
    },
})
end, { desc = "Search content" })

-- ccc color
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<C-c>", "<cmd>CccPick<cr>", opts)

-- show the effects of a search / replace in a live preview window
vim.o.inccommand = "split"

-- flash jump
vim.keymap.set("n", "<leader>j", "<cmd>lua require('flash').jump()<cr>", { desc = "flash jump" })

-- lsp hover
-- vim.keymap.set("n", "<c-x>", vim.lsp.buf.hover, { desc = "lsp hover" })

-- spectre

vim.keymap.set("n", "<leader>rt", '<cmd>lua require("spectre").toggle()<CR>', {
  desc = "Toggle search panel in global",
})

vim.keymap.set("n", "<leader>ro", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
  desc = "Search current word in global",
})
vim.keymap.set("v", "<leader>rl", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
  desc = "Search selected str in global",
})

vim.keymap.set("v", "<leader>rw", '<esc><cmd>lua require("spectre").open_file_search()<CR>', {
  desc = "Search selected str in current file",
})
vim.keymap.set("n", "<leader>rs", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
  desc = "Search current word in current file",
})

-- bookmark
vim.keymap.set("n", "<leader>mt", '<cmd>lua require("bookmarks").toggle_bookmarks()<CR>', {
  desc = "Toggle bookmarks view",
})
vim.keymap.set("n", "<leader>ma", '<cmd>lua require("bookmarks").add_bookmarks()<CR>', {
  desc = "add bookmark",
})
vim.keymap.set("n", "<leader>md", '<cmd>lua require("bookmarks.list").delete_on_virt()<CR>', {
  desc = "del bookmark",
})
vim.keymap.set("n", "<leader>ms", '<cmd>lua require("bookmarks.list").show_desc()<CR>', {
  desc = "show bookmark desc",
})


-- lspsaga
vim.keymap.set({ "n"}, "<leader>ig", "<C-t>", { desc = "go back from definition jump" })




