return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	event = "VeryLazy",
	opts = {
		signs = true,
		colors = {
			error = { "DiagnosticError", "ErrorMsg", "#f38ba8" },
			warning = { "DiagnosticWarn", "WarningMsg", "#fab387" },
			info = { "DiagnosticInfo", "#89b4fa" },
			hint = { "DiagnosticHint", "#94e2d5" },
			default = { "Identifier", "#cdd6f4" },
			todo = { "#fab387" }, -- Catppuccin Peach (orange/yellow)
			done = { "#a6e3a1" }, -- Catppuccin Green
		},
		keywords = {
			FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" } },
			TODO = { icon = " ", color = "todo" },
			HACK = { icon = " ", color = "warning" },
			WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
			PERF = { icon = " ", color = "default", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
			NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
			TEST = { icon = "⏲ ", color = "default", alt = { "TESTING", "PASSED", "FAILED" } },
			DONE = { icon = " ", color = "done", alt = { "FINISH", "COMPLETED" } },
		},
		highlight = {
			multiline = true,
			before = "fg",
			keyword = "wide",
			after = "fg",
			pattern = [[.*<(KEYWORDS)\s*:]],
			comments_only = true,
		},
	},
	keys = {
		{
			"]t",
			function()
				require("todo-comments").jump_next()
			end,
			desc = "Next todo comment",
		},
		{
			"[t",
			function()
				require("todo-comments").jump_prev()
			end,
			desc = "Previous todo comment",
		},
		{
			"<leader>ft",
			"<cmd>TodoTelescope<cr>",
			desc = "Find todo comments",
		},
	},
}
