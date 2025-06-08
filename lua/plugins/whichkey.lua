-- Define diagnostic state functions and variable outside config for accessibility
local diagnostic_enabled = true

local function save_diagnostic_state(state)
	local file = io.open(vim.fn.stdpath("data") .. "/diagnostic_state", "w")
	if file then
		file:write(state and "1" or "0")
		file:close()
	end
end

local function load_diagnostic_state()
	local file = io.open(vim.fn.stdpath("data") .. "/diagnostic_state", "r")
	if file then
		local state = file:read("*a")
		file:close()
		return state == "1"
	end
	return true -- Default to enabled if no saved state
end

return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	enabled = true,
	opts = {
		-- Add configuration options here if needed
	},
	keys = {
		{
			"<F10>",
			function()
				diagnostic_enabled = not diagnostic_enabled
				if diagnostic_enabled then
					vim.diagnostic.show() -- Changed from enable()
				else
					vim.diagnostic.hide() -- Changed from disable()
				end
				save_diagnostic_state(diagnostic_enabled)
			end,
			desc = "[d]iagnostic toggle",
		},
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
	config = function()
		local wk = require("which-key")

		-- Initialize diagnostics based on saved state
		diagnostic_enabled = load_diagnostic_state()

		-- Apply the saved state when Neovim starts
		vim.defer_fn(function()
			if diagnostic_enabled then
				vim.diagnostic.show() -- Changed from enable()
			else
				vim.diagnostic.hide() -- Changed from disable()
			end
		end, 100)
	end,
}
