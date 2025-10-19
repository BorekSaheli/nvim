return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	enabled = true,
	config = function()
		local which_key = require("which-key")
		local state = require("core.state")
		
		-- Setup which-key with manual triggers only (disables auto mouse triggers)
		which_key.setup({
			triggers = {
				{ "<leader>", mode = { "n", "v" } },
				{ "g", mode = { "n", "v" } },
				{ "z", mode = { "n", "v" } },
				{ "]", mode = { "n", "v" } },
				{ "[", mode = { "n", "v" } },
				{ "<c-w>", mode = { "n" } },
				{ '"', mode = { "n", "v" } },
				{ "'", mode = { "n", "v" } },
				{ "`", mode = { "n", "v" } },
			},
		})

		-- Register keymaps for toggles
		which_key.add({
			{
				"<F9>",
				function()
					state.toggle_diagnostics()
				end,
				desc = "Toggle Diagnostics Virtual Text",
			},
			{
				"<F10>",
				function()
					state.toggle_completion()
				end,
				desc = "Toggle Completion Popup",
			},
			{
				"<leader>td",
				function()
					state.toggle_diagnostics()
				end,
				desc = "Toggle Diagnostics Virtual Text",
			},
			{
				"<leader>th",
				function()
					state.toggle_semantic_tokens()
				end,
				desc = "Toggle Semantic Highlighting",
			},
			{
				"<leader>ta",
				function()
					_G.toggle_dashboard_ascii()
				end,
				desc = "Toggle ASCII Art Style",
			},
			{
				"<leader>?",
				function()
					which_key.show({ global = false })
				end,
				desc = "Buffer Local Keymaps",
			},
		})
	end,
}