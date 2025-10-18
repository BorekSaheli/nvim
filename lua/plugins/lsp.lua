return {
	{
		"neovim/nvim-lspconfig",
		enabled = true,
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- Set up ty LSP (Astral's Python LSP) and ruff_lsp
			-- Note: ty must be installed manually with: uv tool install ty
			-- Note: ruff must be installed manually with: uv tool install ruff
			local lspconfig = require("lspconfig")
			local configs = require("lspconfig.configs")
			local util = require("lspconfig.util")

			-- Determine ty path based on OS
			local ty_cmd = "ty"  -- Default: rely on PATH
			if vim.fn.has("win32") == 1 then
				-- On Windows, check common locations or use PATH
				local windows_path = vim.fn.expand("~\\AppData\\Roaming\\Python\\Scripts\\ty.exe")
				if vim.fn.executable(windows_path) == 1 then
					ty_cmd = windows_path
				end
			elseif vim.fn.has("unix") == 1 then
				-- On Unix/Mac, check common locations
				local unix_path = vim.fn.expand("~/.local/bin/ty")
				if vim.fn.executable(unix_path) == 1 then
					ty_cmd = unix_path
				end
			end

			-- Add ty to lspconfig if not already present
			if not configs.ty then
				configs.ty = {
					default_config = {
						cmd = { ty_cmd, "server" },
						filetypes = { "python" },
						root_dir = util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git"),
						single_file_support = true,
						settings = {},
					},
				}
			end

			-- Determine ruff path based on OS
			local ruff_cmd = "ruff"  -- Default: rely on PATH
			if vim.fn.has("win32") == 1 then
				-- On Windows, check common locations or use PATH
				local windows_path = vim.fn.expand("~\\AppData\\Roaming\\Python\\Scripts\\ruff.exe")
				if vim.fn.executable(windows_path) == 1 then
					ruff_cmd = windows_path
				end
			elseif vim.fn.has("unix") == 1 then
				-- On Unix/Mac, check common locations
				local unix_path = vim.fn.expand("~/.local/bin/ruff")
				if vim.fn.executable(unix_path) == 1 then
					ruff_cmd = unix_path
				end
			end

			-- Setup ty with capabilities (type checking)
			lspconfig.ty.setup({
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
				flags = {
					debounce_text_changes = 150,
				},
				on_attach = function(client, bufnr)
					-- Performance: disable semantic tokens for faster highlighting
					client.server_capabilities.semanticTokensProvider = nil
				end,
			})

			-- Setup ruff for linting diagnostics
			lspconfig.ruff.setup({
				cmd = { ruff_cmd, "server" },
				capabilities = require("cmp_nvim_lsp").default_capabilities(),
				flags = {
					debounce_text_changes = 150,
				},
				on_attach = function(client, bufnr)
					-- Disable ruff's hover in favor of ty
					client.server_capabilities.hoverProvider = false
					-- Performance: disable semantic tokens for faster highlighting
					client.server_capabilities.semanticTokensProvider = nil
				end,
			})

			-- Set up LSP keymaps globally for all buffers with LSP attached
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true, noremap = true }

					-- Use Telescope for definitions (better UI)
					vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", vim.tbl_extend("force", opts, { desc = "Go to Definition" }))

					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to Declaration" }))
					vim.keymap.set("n", "K", function()
						local hover_win = vim.lsp.buf.hover({ focusable = true })
						-- Move cursor to the hover window after a short delay
						vim.defer_fn(function()
							local win = vim.api.nvim_get_current_win()
							local wins = vim.api.nvim_list_wins()
							for _, w in ipairs(wins) do
								local buf = vim.api.nvim_win_get_buf(w)
								if vim.api.nvim_buf_get_option(buf, 'filetype') == 'markdown' then
									vim.api.nvim_set_current_win(w)
									break
								end
							end
						end, 50)
					end, vim.tbl_extend("force", opts, { desc = "Show Hover Information" }))
					vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Go to References" }))
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Go to Implementation" }))
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))
					vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show Diagnostic" }))
				end,
			})
		end,
	},
}