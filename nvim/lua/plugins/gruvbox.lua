return {
	"ellisonleao/gruvbox.nvim",
  	branch = "main", -- 跟踪主分支的最新提交
  	-- version = "*", -- 使用发布版本呢
	config = function()
		require("gruvbox").setup({
			undercurl = true,
			underline = true,
			bold = true,
			italic = {
				strings = true,
				emphasis = true,
				comments = true,
				operators = false,
				folds = true,
			},
			strikethrough = true,
			invert_selection = false,
			invert_signs = false,
			invert_tabline = false,
			invert_intend_guides = false,
			inverse = true, -- invert background for search, diffs, statuslines and errors
			contrast = "hard", -- can be "hard", "soft" or empty string
		
		
			palette_overrides = {
				dark1 = "#221516",
				-- bright_red = "#ea6962",
				-- bright_green = "#93bb26",
				-- bright_yellow = "#c1ae1e",
				-- bright_blue = "#99ada5",
				-- bright_purple = "#d3869b",
				-- bright_aqua = "#89b482",
				-- bright_orange = "#c06325",
				-- light1 = "#decec1",
				dark0_hard = "#201b14",
			},
			overrides = {
				-- Normal = {bg = "None"}, -- transparent background
				SignColumn = {bg = "#221516"},
				Pmenu = {bg = "#221516"},
				-- flash.nvim
				FlashCurrent = { bg = "#cfc251", fg = "#1b1d2b" },
				FlashLabel = { bg = "#ba603d", bold = true, fg = "#eadfc8" },
				FlashMatch = { bg = "#73ac3a", fg = "#1b1d2b" },
    			-- nvim-neo-tree/neo-tree.nvim
			}
		})
	end,
  }
  


