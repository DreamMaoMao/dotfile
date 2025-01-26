return {
  "sindrets/diffview.nvim",
  keys = {
    { "<leader>dm", "<cmd>DiffviewOpen origin/main<CR>", desc = "diffview from main branch" },
    { "<leader>dc", "<cmd>DiffviewClose<CR>", desc = "close diffview" },
    { "<leader>df", "<cmd>DiffviewFileHistory<CR>", desc = "diffview file history" },
    { "<leader>dr", "<cmd>DiffviewRefresh<CR>", desc = "diffview refresh" },
    { "<leader>de", "<cmd>DiffviewFileHistory %<CR>", desc = "diffview current file history" },
  },
}
