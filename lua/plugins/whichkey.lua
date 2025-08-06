return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	enabled = true,
	config = function()
		local which_key = require("which-key")
		local state = require("core.state")

		-- Register keymaps for toggles
		which_key.add({
			{
				"<F9>",
				function()
					local is_enabled = state.toggle_diagnostics()
					vim.notify(is_enabled and "Diagnostics enabled" or "Diagnostics disabled", vim.log.levels.INFO)
				end,
				desc = "Toggle Diagnostics",
			},
			{
				"<F10>",
				function()
					local is_enabled = state.toggle_completion()
					vim.notify(is_enabled and "Completion popup enabled" or "Completion popup disabled", vim.log.levels.INFO)
				end,
				desc = "Toggle Completion Popup",
			},
			{
				"<leader>td",
				function()
					local is_enabled = state.toggle_diagnostics()
					vim.notify(is_enabled and "Diagnostics enabled" or "Diagnostics disabled", vim.log.levels.INFO)
				end,
				desc = "Toggle Diagnostics",
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