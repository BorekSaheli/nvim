return {
	"lukas-reineke/indent-blankline.nvim",
	event = "VeryLazy",
	opts = {
		exclude = {
			filetypes = {
				"lspinfo",
				"dashboard",
				"checkhealth",
				"help",
				"man",
				"gitcommit",
				"TelescopePrompt",
				"TelescopeResults",
				"",
			},
		},
	},
	main = "ibl",
	keys = {
		{ "<leader>ii", "<cmd>IndentBlanklineToggle<cr>", desc = "[i]ndent toggle" },
		{ "<leader>is", "<cmd>IndentBlanklineScopeToggle<cr>", desc = "[s]cope toggle" },
	},
}
