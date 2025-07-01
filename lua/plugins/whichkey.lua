return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	enabled = false,
	config = function()
		local which_key = require("which-key")
		local state = require("core.state")

		-- Set the initial state for diagnostics
		state.diagnostics.set_initial_state("lua vim.diagnostic.show()", "lua vim.diagnostic.hide()")

		-- Register a keymap to toggle diagnostics
		which_key.register({
			["<F10>"] = {
				function()
					local is_enabled = state.diagnostics.toggle()
					if is_enabled then
						vim.diagnostic.show()
					else
						vim.diagnostic.hide()
					end
				end,
				"Toggle Diagnostics",
			},
			["<leader>?"] = {
				function()
					which_key.show({ global = false })
				end,
				"Buffer Local Keymaps",
			},
		})
	end,
}