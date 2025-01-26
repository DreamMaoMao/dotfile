return {
    'nvimdev/lspsaga.nvim',
    config = function()
        require('lspsaga').setup({})
    end,
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons',
    },
    keys = {
        { "<leader>is", "<cmd>Lspsaga peek_definition<CR>", desc = "show definition" },
        { "<leader>id", "<cmd>Lspsaga goto_definition<CR>", desc = "go to definition" },
        { "<leader>ih", "<cmd>Lspsaga hover_doc<CR>", desc = "show hover doc" },
        { "<leader>it", "<cmd>Lspsaga term_toggle<CR>", desc = "toggle a termianl session" },
        { "<leader>if", "<cmd>Lspsaga finder<CR>", desc = "show refer(o to open)" },
    },
}