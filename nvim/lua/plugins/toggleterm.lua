return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      open_mapping = [[<c-\>]],
    })
  end,
  keys = {
    { "<leader>tt", "<cmd>ToggleTerm<CR>", desc = "Toggle Term" },
    { "<leader>ts", "<cmd>TermSelect <CR>", desc = "Select Term" },
  },
}
