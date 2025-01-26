local spec = {
  "akinsho/bufferline.nvim",
  event = "BufRead",
  keys = {
    { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
    { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
    { "<leader>ft", "<Cmd>BufferLinePick<CR>", desc = "Find Buffer" },
    -- {
    --   "<A-j>",
    --   mode = { "n", "i" },
    --
    --   "<Cmd>BufferLineMoveNext<CR>",
    --   desc = "move buffer to right",
    -- },
    -- {
    --   "<A-k>",
    --   mode = { "n", "i" },
    --
    --   "<Cmd>BufferLineMovePrev<CR>",
    --   desc = "move buffer to left",
    -- },
    {
      "<A-l>",
      mode = { "n", "i" },

      "<Cmd>BufferLineCycleNext<CR>",
      desc = "go to buffer right",
    },
    {
      "<A-h>",
      mode = { "n", "i" },

      "<Cmd>BufferLineCyclePrev<CR>",
      desc = "go to buffer left",
    },
    {
      "<A-1>",
      mode = { "n", "i" },

      "<Cmd>BufferLineGoToBuffer 1<CR>",
      desc = "go to buffer 1",
    },
    {
      "<A-2>",
      mode = { "n", "i" },
      "<Cmd>BufferLineGoToBuffer 2<CR>",
      desc = "go to buffer 2",
    },
    {
      "<A-3>",
      mode = { "n", "i" },
      "<Cmd>BufferLineGoToBuffer 3<CR>",
      desc = "go to buffer 3",
    },
    {
      "<A-4>",
      mode = { "n", "i" },
      "<Cmd>BufferLineGoToBuffer 4<CR>",
      desc = "go to buffer 4",
    },
    {
      "<A-5>",
      mode = { "n", "i" },
      "<Cmd>BufferLineGoToBuffer 5<CR>",
      desc = "go to buffer 5",
    },
  },
  config = function()
    local mocha = require("catppuccin.palettes").get_palette("mocha")
    local latte = require("catppuccin.palettes").get_palette("latte")
    require("bufferline").setup({
      highlights = require("catppuccin.groups.integrations.bufferline").get({
        custom = {
          mocha = {
            buffer_selected = { fg = mocha.pink, bg = mocha.base, bold = true },
            separator = { bg = mocha.base, fg = mocha.crust },
            indicator_selected = { fg = mocha.pink, bg = mocha.base },
            indicator_visible = { fg = mocha.pink, bg = mocha.base },
          },
          latte = {
            buffer_selected = { fg = latte.pink, bg = latte.base, bold = true },
            separator = { bg = latte.base, fg = latte.crust },
            indicator_selected = { fg = latte.pink, bg = latte.base },
            indicator_visible = { fg = latte.pink, bg = latte.base },
          },
        },
      }),
      options = {
        -- diagnostics = "nvim_lsp",
        diagnostics = nil,
        themable = true,
        always_show_bufferline = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explore",
            highlight = "BufferLineOffset",
            text_align = "left",
          },
        },
        buffer_close_icon = "󰅖",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        separator_style = { "", "" },
        extensions = { "lazy", "neo-tree", "nvim-dap-ui", "overseer", "symbols-outline", "toggleterm", "trouble" },
      },
    })
  end,
}

return spec
