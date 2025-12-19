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
	end,
}
