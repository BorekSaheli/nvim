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

			-- Configure diagnostics for better performance and visibility
			vim.diagnostic.config({
				virtual_text = {
					enabled = true,
					source = "if_many",
					prefix = "●",
				},
				signs = {
					active = {
						{ name = "DiagnosticSignError", text = "", texthl = "DiagnosticSignError" },
						{ name = "DiagnosticSignWarn", text = "", texthl = "DiagnosticSignWarn" },
						{ name = "DiagnosticSignHint", text = "󰌶", texthl = "DiagnosticSignHint" },
						{ name = "DiagnosticSignInfo", text = "", texthl = "DiagnosticSignInfo" },
					},
				},
				underline = true,
				update_in_insert = false, -- Don't update diagnostics in insert mode for performance
				severity_sort = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = "always",
					header = "",
					prefix = "",
				},
			})

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
									},
								},
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
