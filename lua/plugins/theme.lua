return {
	"catppuccin/nvim",
	name = "catppuccin",
	config = function()
		vim.o.termguicolors = true
		local golden_haze = require("theme.golden-haze-2")

		require("catppuccin").setup({
			flavour = "mocha",
			term_colors = true,
			transparent_background = true,
			no_italic = false,
			no_bold = false,
			styles = {
				comments = {},
				conditionals = {},
				loops = {},
				functions = { "bold" },
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
			},
			color_overrides = { all = golden_haze.colors },
			highlight_overrides = { mocha = golden_haze.highlights },
		})

		vim.opt.guifont = "JetBrainsMono Nerd Font Mono:h12"
		vim.cmd.colorscheme("catppuccin")

		-- Simulate darker background for line numbers and diagnostic column
		vim.api.nvim_set_hl(0, "LineNr", { fg = "#7f849c", bg = "NONE" })
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#f9e2af", bg = "NONE", bold = true })
		vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "VertSplit", { bg = "NONE", fg = "#45475a" })
	end,
}