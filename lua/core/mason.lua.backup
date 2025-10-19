-- Mason configuration for LSP server management
return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		-- keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				-- Formatters and Linters
				"stylua",
				"ruff", -- Python formatter and linter
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")

			-- Trigger FileType event when package installs (no delay needed)
			mr:on("package:install:success", function()
				-- Trigger FileType event to possibly load this newly installed LSP server
				require("lazy.core.handler.event").trigger({
					event = "FileType",
					buf = vim.api.nvim_get_current_buf(),
				})
			end)

			-- Auto-install servers on startup if they're not installed
			-- Use registry:on("ready") instead of defer_fn for better timing
			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end

			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			-- List of servers to automatically install if they're not already installed
			ensure_installed = {
				"lua_ls", -- Lua Language Server
			},
			-- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed
			automatic_installation = true,
		},
		config = function(_, opts)
			local mason_lspconfig = require("mason-lspconfig")
			mason_lspconfig.setup(opts)

			-- Note: Diagnostic configuration is handled in core/state.lua

			-- Setup handlers for automatic server configuration using new API
			-- Check if setup_handlers is available (newer versions of mason-lspconfig)
			if mason_lspconfig.setup_handlers then
				mason_lspconfig.setup_handlers({
					-- Default handler for all servers
					function(server_name)
						-- Skip pyright since we're using ty instead
						if server_name == "pyright" then
							return
						end

						local server_config = {}

						-- Server-specific configurations
						if server_name == "lua_ls" then
							server_config = {
								settings = {
									Lua = {
										runtime = { version = "LuaJIT" },
										workspace = {
											checkThirdParty = false,
											maxPreload = 100000,
											preloadFileSize = 10000,
											library = {
												vim.env.VIMRUNTIME,
												-- Add lazy.nvim to the library
												"${3rd}/luv/library",
												"${3rd}/busted/library",
											},
											-- Exclude directories that shouldn't be scanned
											ignoreDir = {
												".git",
												"node_modules",
												".vscode",
												".idea",
												"dist",
												"build",
												".next",
												".nuxt",
												".output",
												".venv",
												"venv",
												"env",
												"__pycache__",
												".pytest_cache",
												".mypy_cache",
												"AppData/Local/Temp",
												"AppData/Roaming",
												"AppData/LocalLow",
												"scoop",
												"tools",
												"Downloads",
												"Documents",
												"Desktop",
												"Pictures",
												"Music",
												"Videos",
											},
										},
										completion = {
											callSnippet = "Replace",
										},
										diagnostics = {
											globals = { "vim" },
										},
									},
								},
							}
						end

						-- Apply common settings to all servers
						local common_config = {
							capabilities = require("cmp_nvim_lsp").default_capabilities(),
						}

						-- Merge server-specific config with common config
						local final_config = vim.tbl_deep_extend("force", common_config, server_config)

						-- Use new vim.lsp.config API for Neovim 0.11+
						vim.lsp.config[server_name] = final_config

						-- Auto-enable the LSP when appropriate filetype is detected
						local filetypes = final_config.filetypes or vim.lsp.config[server_name].filetypes
						if filetypes then
							vim.api.nvim_create_autocmd("FileType", {
								pattern = filetypes,
								callback = function()
									vim.lsp.enable(server_name)
								end,
							})
						end
					end,
				})
			end
		end,
	},
}