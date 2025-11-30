return {
	{
		"github/copilot.vim",
		-- Lazy load - only load when explicitly requested
		lazy = true,

		-- Initialize plugin based on saved state
		init = function()
			-- Check if copilot should be loaded at startup
			local state_file = vim.fn.stdpath("data") .. "/copilot_enabled"
			local file = io.open(state_file, "r")
			local should_load = true -- Default: enabled

			if file then
				local content = file:read("*a")
				file:close()
				should_load = content:match("1") ~= nil
			end

			if should_load then
				-- Load copilot on VeryLazy event if enabled
				vim.api.nvim_create_autocmd("User", {
					pattern = "VeryLazy",
					once = true,
					callback = function()
						require("lazy").load({ plugins = { "copilot.vim" } })
					end,
				})
			end
		end,

		config = function()
			-- Copilot works out of the box, no configuration needed
		end,
	},
}