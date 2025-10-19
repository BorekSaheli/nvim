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

			-- Helper function to find root directory
			local function root_pattern(...)
				local patterns = { ... }
				return function(fname_or_bufnr)
					-- Convert buffer number to file path if needed
					local fname = fname_or_bufnr
					if type(fname_or_bufnr) == "number" then
						fname = vim.api.nvim_buf_get_name(fname_or_bufnr)
					end

					-- Return the directory containing the pattern file
					local found = vim.fs.find(patterns, { path = fname, upward = true })[1]
					if found then
						return vim.fs.dirname(found)
					end
					return nil
				end
			end

			-- Start ty and ruff LSP for Python files using vim.lsp.start
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "python",
				callback = function(ev)
					local bufnr = ev.buf
					local fname = vim.api.nvim_buf_get_name(bufnr)

					-- Find root directory
					local root = root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git")(fname)

					-- Fallback to current directory if no root found
					if not root or root == "" then
						root = vim.fn.getcwd()
					end

					-- Start ty (type checking)
					local ty_client = vim.lsp.start({
						name = "ty",
						cmd = { ty_cmd, "server" },
						root_dir = root,
						capabilities = require("cmp_nvim_lsp").default_capabilities(),
					}, {
						bufnr = bufnr,
					})

					-- Start ruff (linting)
					local ruff_client = vim.lsp.start({
						name = "ruff",
						cmd = { ruff_cmd, "server" },
						root_dir = root,
						capabilities = require("cmp_nvim_lsp").default_capabilities(),
					}, {
						bufnr = bufnr,
					})
				end,
			})

			-- Custom on_attach behavior for ty (disable semantic tokens)
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.name == "ty" then
						-- Performance: disable semantic tokens for faster highlighting
						client.server_capabilities.semanticTokensProvider = nil
					end
				end,
			})

			-- Custom on_attach behavior for ruff (disable hover and semantic tokens)
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.name == "ruff" then
						-- Disable ruff's hover in favor of ty
						client.server_capabilities.hoverProvider = false
						-- Performance: disable semantic tokens for faster highlighting
						client.server_capabilities.semanticTokensProvider = nil
					end
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
