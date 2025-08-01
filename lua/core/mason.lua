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
				"pyright", -- Faster Python LSP Server
				"lua_ls", -- Lua Language Server
			},
			-- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed
			automatic_installation = true,
		},
		config = function(_, opts)
			require("mason-lspconfig").setup(opts)

			-- Disable default vim diagnostics immediately
			vim.diagnostic.config({
				virtual_text = false,
				signs = false,
				underline = false,
				update_in_insert = false,
			})

			-- Global diagnostic state
			local diagnostic_enabled = true
			
			-- Configure diagnostics for better performance and visibility
			local function setup_diagnostics()
				vim.diagnostic.config({
					virtual_text = diagnostic_enabled and {
						enabled = true,
						source = "always", -- Always show source (ruff, pyright, etc.)
						prefix = "●",
					} or false,
					signs = diagnostic_enabled,
					underline = diagnostic_enabled,
					update_in_insert = false, -- Don't update diagnostics in insert mode for performance
					severity_sort = true,
					float = {
						focusable = false,
						style = "minimal",
						border = "rounded",
						source = "always", -- Always show source in float
						header = "",
						prefix = "",
					},
				})
			end
			
			-- Function to toggle diagnostics
			local function toggle_diagnostics()
				diagnostic_enabled = not diagnostic_enabled
				setup_diagnostics()
				
				if diagnostic_enabled then
					vim.diagnostic.show()
					vim.notify("Diagnostics enabled", vim.log.levels.INFO)
				else
					vim.diagnostic.hide()
					vim.notify("Diagnostics disabled", vim.log.levels.INFO)
				end
			end
			
			-- Set up initial diagnostics
			setup_diagnostics()
			
			-- Global keymap to toggle diagnostics
			vim.keymap.set("n", "<leader>td", toggle_diagnostics, { desc = "Toggle Diagnostics" })

			-- Define signs
			local signs = {
				{ name = "DiagnosticSignError", text = "" },
				{ name = "DiagnosticSignWarn", text = "" },
				{ name = "DiagnosticSignHint", text = "󰌶" },
				{ name = "DiagnosticSignInfo", text = "" },
			}

			for _, sign in ipairs(signs) do
				vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
			end

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
									vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
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
										library = {
											vim.env.VIMRUNTIME,
											-- Add lazy.nvim to the library
											"${3rd}/luv/library",
											"${3rd}/busted/library",
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
							
							-- Only enable diagnostics when LSP servers attach (not default vim diagnostics)
							if diagnostic_enabled then
								setup_diagnostics() -- Re-enable with LSP sources
							else
								vim.diagnostic.hide(bufnr)
							end
							
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
