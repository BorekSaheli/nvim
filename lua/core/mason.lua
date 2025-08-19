-- Mason configuration for LSP server management
return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		-- keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				-- LSP servers
				"pyright", -- faster Python LSP
				"lua-language-server", -- lua_ls

				-- Formatters
                                "stylua",
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
                                mr.refresh(function()
                                        for _, tool in ipairs(opts.ensure_installed) do
                                                local pkg = mr.get_package(tool)
                                                if not pkg:is_installed() then
                                                        pkg:install()
                                                end
                                        end
                                end)
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
				"pyright", -- Faster Python LSP Server
				"lua_ls", -- Lua Language Server
			},
			-- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed
			automatic_installation = true,
		},
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)

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
			require("mason-lspconfig").setup_handlers({
				-- Default handler for all servers
				function(server_name)
					local server_config = {}

					-- Server-specific configurations
					if server_name == "pyright" then
						server_config = {
							settings = {
								python = {
									analysis = {
										autoSearchPaths = true,
										useLibraryCodeForTypes = true,
										diagnosticMode = "openFilesOnly", -- Much faster
										-- Disable overlapping diagnostics that ruff handles better
										autoImportCompletions = true,
										typeCheckingMode = "basic", -- Reduce noise, let ruff handle style
									},
								},
							},
							-- Filter pyright diagnostics to avoid overlap with ruff
							handlers = {
								["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
									if result and result.diagnostics then
										-- Filter out diagnostics that ruff handles better
										result.diagnostics = vim.tbl_filter(function(diagnostic)
											local message = diagnostic.message:lower()
											-- Skip import-related diagnostics that ruff handles
											if message:match("import") and message:match("unused") then
												return false
											end
											-- Skip line length diagnostics that ruff handles
											if message:match("line too long") then
												return false
											end
											return true
										end, result.diagnostics)
									end
									vim.lsp.handlers["textDocument/publishDiagnostics"](err, result, ctx, config)
								end,
							},
						}
					elseif server_name == "lua_ls" then
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
							
							
							-- LSP Keymaps (only apply to buffers with LSP)
							local opts = { buffer = bufnr, silent = true }
							vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Show Hover Information" }))
							vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to Definition" }))
							vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to Declaration" }))
							vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Go to References" }))
							vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to Implementation" }))
							vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))
							-- vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))
							vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show Diagnostic" }))
						end,
					}

					-- Merge server-specific config with common config
					local final_config = vim.tbl_deep_extend("force", common_config, server_config)

					require("lspconfig")[server_name].setup(final_config)
				end,
			})
		end,
	},
}