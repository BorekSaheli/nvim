return {
	"catppuccin/nvim",
	name = "catppuccin",
	config = function()
		vim.o.termguicolors = true

		require("catppuccin").setup({
			flavour = "mocha",
			transparent_background = true,
		})

		vim.opt.guifont = "JetBrainsMonoNL Nerd Font:h12"
		vim.cmd.colorscheme("catppuccin")

		-- Set solid blue-tinted background for Neovim (works with WezTerm transparency)
		vim.api.nvim_set_hl(0, "Normal", { bg = "#030712" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#0d1220" })
		vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#0d1220" })

		-- Simple overrides for background and line numbers
		-- vim.api.nvim_set_hl(0, "LineNr", { fg = "#7f849c", bg = "NONE" })
		-- vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#f9e2af", bg = "NONE", bold = true })
		-- vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
	end,
}
