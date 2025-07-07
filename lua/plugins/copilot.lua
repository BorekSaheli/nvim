return {
	{
		"github/copilot.vim",
		config = function()
			local state = require("core.state")

			-- Set the initial state for Copilot
			state.copilot.set_initial_state("Copilot enable", "Copilot disable")

			-- Key mapping to toggle Copilot suggestions
			vim.keymap.set("n", "<F9>", function()
				local is_enabled = state.copilot.toggle()
				if is_enabled then
					vim.cmd("Copilot enable")
				else
					vim.cmd("Copilot disable")
				end
			end, { noremap = true, silent = true, desc = "Toggle Copilot" })
		end,
	},
}