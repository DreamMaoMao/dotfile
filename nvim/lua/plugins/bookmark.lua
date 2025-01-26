return {
  'crusj/bookmarks.nvim',
  -- "DreamMaoMao/bookmarks.nvim",
  keys = {
    { "<tab><tab>", mode = { "n" } },
  },
  branch = "main",
  dependencies = { "nvim-web-devicons" },
  config = function()
    require("bookmarks").setup()
    require("telescope").load_extension("bookmarks")
  end,
}
