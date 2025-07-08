local cmd = require("utils").cmd

return {
	"folke/trouble.nvim",
	enabled = true,
	opts = {},
	cmd = "Trouble",
	keys = {
		{
			"<leader>xx",
			cmd("Trouble diagnostics toggle focus=true win.position=bottom filter.buf=0"),
			desc = "Toggle Diagnostics (Current Buffer)",
		},
		{
			"<leader>xs",
			cmd("Trouble symbols toggle focus=true"),
			desc = "Toggle Symbols",
		},
		{
			"<leader>xl",
			cmd("Trouble lsp toggle focus=false win.position=right"),
			desc = "Toggle LSP Trouble",
		},
		{
			"<leader>xn",
			vim.diagnostic.goto_next,
			desc = "Go to Next Diagnostic",
		},
		{
			"<leader>xp",
			vim.diagnostic.goto_prev,
			desc = "Go to Previous Diagnostic",
		},
		{
			"<leader>xq",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "Toggle Quickfix List",
		},
	},
}