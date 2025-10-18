-- Mason configuration for LSP server management
return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		-- keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				-- Formatters
				"stylua",
				"ruff",

				-- Linters  
				"ruff", -- also used for linting
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- Trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)

			-- Auto-install servers on startup if they're not installed
			vim.defer_fn(function()
				for _, tool in ipairs(opts.ensure_installed) do
					if not mr.is_installed(tool) then
						vim.cmd("MasonInstall " .. tool)
					end
				end
			end, 100)
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

			-- Set up diagnostic configuration with signs and float
			vim.diagnostic.config({
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = "always", -- Always show source in float
					header = "",
					prefix = "",
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "",
						[vim.diagnostic.severity.WARN] = "⚠",
						[vim.diagnostic.severity.HINT] = "󰌶",
						[vim.diagnostic.severity.INFO] = "",
					},
				},
			})

			-- Setup handlers for automatic server configuration
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
						-- Performance optimizations
						flags = {
							debounce_text_changes = 150,
						},
						on_attach = function(client, bufnr)
							-- Performance: disable semantic tokens for faster highlighting
							client.server_capabilities.semanticTokensProvider = nil
						end,
					}

					-- Merge server-specific config with common config
					local final_config = vim.tbl_deep_extend("force", common_config, server_config)

					require("lspconfig")[server_name].setup(final_config)
				end,
			})
			end
		end,
	},
}