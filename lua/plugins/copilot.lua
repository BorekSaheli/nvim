return {
	{
		"github/copilot.vim",
		config = function()
			local state = require("core.state")

			-- Key mapping to toggle Copilot suggestions  
			vim.keymap.set("n", "<F8>", function()
				local is_enabled = state.toggle_copilot()
			end, { noremap = true, silent = true, desc = "Toggle Copilot" })
		end,
	},
}