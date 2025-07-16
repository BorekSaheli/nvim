return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_format", "ruff_organize_imports" },
		},
		formatters = {
			ruff_format = {
				command = "ruff",
				args = { "format", "--stdin-filename", "$FILENAME" },
				stdin = true,
			},
			ruff_organize_imports = {
				command = "ruff",
				args = { "check", "--select", "I", "--fix", "--stdin-filename", "$FILENAME", "--force-exclude" },
				stdin = true,
			},
		},
	},
	keys = {
		{
			"<leader>bf",
			function()
				require("conform").format({ async = true })
			end,
			mode = { "n", "v" },
			desc = "Format Buffer",
		},
	},
}