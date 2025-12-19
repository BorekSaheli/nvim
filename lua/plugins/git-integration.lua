return {
	{
		"lewis6991/gitsigns.nvim",
		version = "v1.0.0",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signcolumn = true,
			numhl = false,
			linehl = false,
			word_diff = false,
			current_line_blame = false,
		},
		config = function(_, opts)
			require("gitsigns").setup(opts)
			-- Set the delete sign to red
			vim.cmd([[highlight GitSignsDelete guifg=#c6003c]])
			vim.keymap.set("n", "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", { desc = "Preview Git Hunk" })
		end,
	},
	{
		"kdheepak/lazygit.nvim",
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<CR>", desc = "Toggle Lazygit" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
}