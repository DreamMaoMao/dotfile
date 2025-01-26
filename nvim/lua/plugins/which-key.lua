return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  config = function()
    local wk = require("which-key")
    wk.add({
      {
        mode = { "n", "v" },
        { "<leader><tab>", desc = "tabs" },
        { "<leader>b", desc = "buffer" },
        { "<leader>i", desc = "lspsaga",icon = "󱪗" },
        { "<leader>c", desc = "code" },
        { "<leader>d", desc = "diffview",icon = "" },
        { "<leader>f", desc = "file/find" },
        { "<leader>g", desc = "goto",icon = "" },
        { "<leader>j", desc = "flash jump",icon = "" },
        { "<leader>gh", desc = "hunks" },
        { "<leader>m", desc = "bookmarks",icon = "" },
        { "<leader>q", desc = "quit/session" },
        { "<leader>r", desc = "string replace & search" },
        { "<leader>s", desc = "everything search" },
        { "<leader>t", desc = "term",icon = "" },
        { "<leader>K", desc = "keywordPrg",icon = "" },
        { "<leader>u", desc = "ui" },
        { "<leader>w", desc = "windows" },
        { "<leader>x", desc = "diagnostics/quickfix" },
        { "[", desc = "prev" },
        { "]", desc = "next" },
        { "g", desc = "goto" },
        { "gs", desc = "surround" },
      },
    })
  end,
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}

