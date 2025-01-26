return {
	"ellisonleao/gruvbox.nvim",
	version = "*",
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
				dark1 = "#282828",
				bright_red = "#ea6962",
				bright_green = "#73ac3a",
				bright_yellow = "#c1ae1e",
				bright_blue = "#99ada5",
				bright_purple = "#d3869b",
				bright_aqua = "#89b482",
				bright_orange = "#c06325",
				light1 = "#cfb689",
				dark0_hard = "#201b14",
			},
			overrides = {
				-- Normal = {bg = "None"}, -- transparent background
				SignColumn = {bg = "#282828"},
				Pmenu = {bg = "#282828"},
				FlashCurrent = { bg = "#cfc251", fg = "#1b1d2b" },
				FlashLabel = { bg = "#ba603d", bold = true, fg = "#eadfc8" },
				FlashMatch = { bg = "#73ac3a", fg = "#1b1d2b" },				
			}
		})
	end,
  }
  


