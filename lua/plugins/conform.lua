return {
	"stevearc/conform.nvim",
	event = { "BufReadPost" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_format", "ruff_organize_imports" },
			rust = { "rustfmt" },
			c = { "clang_format" },
			cpp = { "clang_format" },
			go = { "goimports", "gofmt" },
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
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