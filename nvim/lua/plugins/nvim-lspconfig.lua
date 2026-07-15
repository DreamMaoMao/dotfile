return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- 确保 servers 表存在
      opts.servers = opts.servers or {}
      
      -- 确保所有服务器都禁用 K 键
      opts.servers["*"] = {
        keys = {
          { "K", false }, -- 禁用 hover
        },
      }
    end,
  },
}