return {
	-- Mason: Package manager for LSP servers, formatters, linters
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)

			-- Auto-install tools
			local ensure_installed = {
				"stylua", -- Lua formatter
				"lua-language-server", -- Lua LSP
				-- Note: ruff and ty are installed manually with: uv tool install ruff ty
			}

			local mr = require("mason-registry")
			local function install_tools()
				for _, tool in ipairs(ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						vim.notify("Installing " .. tool, vim.log.levels.INFO)
						p:install()
					end
				end
			end

			-- Install tools when registry is ready
			if mr.refresh then
				mr.refresh(install_tools)
			else
				install_tools()
			end
		end,
	},

}
