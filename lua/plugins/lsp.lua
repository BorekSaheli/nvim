return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		event = { "FileType" },
		config = function()
			-- Note: ty and ruff must be installed manually with: uv tool install ty ruff

			-- Cache capabilities once
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Platform detection
			local IS_WINDOWS = vim.fn.has("win32") == 1

			-- Determine ty path based on OS
			local ty_cmd = "ty"  -- Default: rely on PATH
			if IS_WINDOWS then
				local windows_path = vim.fn.expand("~\\AppData\\Roaming\\Python\\Scripts\\ty.exe")
				if vim.fn.executable(windows_path) == 1 then
					ty_cmd = windows_path
				end
			elseif vim.fn.has("unix") == 1 then
				local unix_path = vim.fn.expand("~/.local/bin/ty")
				if vim.fn.executable(unix_path) == 1 then
					ty_cmd = unix_path
				end
			end

			-- Determine ruff path based on OS
			local ruff_cmd = "ruff"  -- Default: rely on PATH
			if IS_WINDOWS then
				local windows_path = vim.fn.expand("~\\AppData\\Roaming\\Python\\Scripts\\ruff.exe")
				if vim.fn.executable(windows_path) == 1 then
					ruff_cmd = windows_path
				end
			elseif vim.fn.has("unix") == 1 then
				local unix_path = vim.fn.expand("~/.local/bin/ruff")
				if vim.fn.executable(unix_path) == 1 then
					ruff_cmd = unix_path
				end
			end

			-- Helper function to find root directory
			local function root_pattern(...)
				local patterns = { ... }
				return function(fname_or_bufnr)
					local fname = fname_or_bufnr
					if type(fname_or_bufnr) == "number" then
						fname = vim.api.nvim_buf_get_name(fname_or_bufnr)
					end

					local found = vim.fs.find(patterns, { path = fname, upward = true })[1]
					if found then
						return vim.fs.dirname(found)
					end
					return nil
				end
			end

			-- Start ty and ruff for Python files
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "python",
				callback = function(ev)
					local bufnr = ev.buf
					local fname = vim.api.nvim_buf_get_name(bufnr)
					local root = root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git")(fname) or vim.fn.getcwd()

					-- Start ty (type checking)
					vim.lsp.start({
						name = "ty",
						cmd = { ty_cmd, "server" },
						root_dir = root,
						capabilities = capabilities,
					}, { bufnr = bufnr })

					-- Start ruff (linting)
					vim.lsp.start({
						name = "ruff",
						cmd = { ruff_cmd, "server" },
						root_dir = root,
						capabilities = capabilities,
					}, { bufnr = bufnr })
				end,
			})

			-- Start lua_ls for Lua files
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "lua",
				callback = function(ev)
					local bufnr = ev.buf
					local fname = vim.api.nvim_buf_get_name(bufnr)
					local root = root_pattern(".luarc.json", ".stylua.toml", "stylua.toml", ".git")(fname) or vim.fn.getcwd()

					-- Find lua-language-server from Mason or PATH
					local lua_ls_cmd = vim.fn.expand("~/.local/share/nvim/mason/bin/lua-language-server")
					if vim.fn.executable(lua_ls_cmd) ~= 1 then
						lua_ls_cmd = "lua-language-server"  -- Fallback to PATH
					end

					vim.lsp.start({
						name = "lua_ls",
						cmd = { lua_ls_cmd },
						root_dir = root,
						capabilities = capabilities,
						settings = {
							Lua = {
								runtime = { version = "LuaJIT" },
								workspace = {
									checkThirdParty = false,
									library = {
										vim.env.VIMRUNTIME,
										"${3rd}/luv/library",
									},
								},
								completion = { callSnippet = "Replace" },
								diagnostics = { globals = { "vim" } },
							},
						},
					}, { bufnr = bufnr })
				end,
			})

			-- Start rust-analyzer for Rust files
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "rust",
				callback = function(ev)
					local bufnr = ev.buf
					local fname = vim.api.nvim_buf_get_name(bufnr)
					local root = root_pattern("Cargo.toml", ".git")(fname) or vim.fn.getcwd()

					-- Find rust-analyzer from Mason or PATH
					local rust_analyzer_cmd = vim.fn.expand("~/.local/share/nvim/mason/bin/rust-analyzer")
					if vim.fn.executable(rust_analyzer_cmd) ~= 1 then
						rust_analyzer_cmd = "rust-analyzer"  -- Fallback to PATH
					end

					vim.lsp.start({
						name = "rust_analyzer",
						cmd = { rust_analyzer_cmd },
						root_dir = root,
						capabilities = capabilities,
						settings = {
							["rust-analyzer"] = {
								cargo = {
									allFeatures = true,
								},
								checkOnSave = {
									command = "clippy",
								},
							},
						},
					}, { bufnr = bufnr })
				end,
			})

			-- Start clangd for C/C++ files
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "c", "cpp", "objc", "objcpp" },
				callback = function(ev)
					local bufnr = ev.buf
					local fname = vim.api.nvim_buf_get_name(bufnr)
					local root = root_pattern("compile_commands.json", "compile_flags.txt", ".git")(fname) or vim.fn.getcwd()

					-- Find clangd from Mason or PATH
					local clangd_cmd = vim.fn.expand("~/.local/share/nvim/mason/bin/clangd")
					if vim.fn.executable(clangd_cmd) ~= 1 then
						clangd_cmd = "clangd"  -- Fallback to PATH
					end

					vim.lsp.start({
						name = "clangd",
						cmd = { clangd_cmd },
						root_dir = root,
						capabilities = capabilities,
					}, { bufnr = bufnr })
				end,
			})

			-- Start gopls for Go files
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "go",
				callback = function(ev)
					local bufnr = ev.buf
					local fname = vim.api.nvim_buf_get_name(bufnr)
					local root = root_pattern("go.mod", ".git")(fname) or vim.fn.getcwd()

					-- Find gopls from Mason or PATH
					local gopls_cmd = vim.fn.expand("~/.local/share/nvim/mason/bin/gopls")
					if vim.fn.executable(gopls_cmd) ~= 1 then
						gopls_cmd = "gopls"  -- Fallback to PATH
					end

					vim.lsp.start({
						name = "gopls",
						cmd = { gopls_cmd },
						root_dir = root,
						capabilities = capabilities,
					}, { bufnr = bufnr })
				end,
			})

			-- Start ts_ls for JavaScript/TypeScript files
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
				callback = function(ev)
					local bufnr = ev.buf
					local fname = vim.api.nvim_buf_get_name(bufnr)
					local root = root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")(fname) or vim.fn.getcwd()

					-- Find typescript-language-server from Mason or PATH
					local ts_ls_cmd = vim.fn.expand("~/.local/share/nvim/mason/bin/typescript-language-server")
					if vim.fn.executable(ts_ls_cmd) ~= 1 then
						ts_ls_cmd = "typescript-language-server"  -- Fallback to PATH
					end

					vim.lsp.start({
						name = "ts_ls",
						cmd = { ts_ls_cmd, "--stdio" },
						root_dir = root,
						capabilities = capabilities,
					}, { bufnr = bufnr })
				end,
			})

			-- Disable ruff's hover (ty provides better type info)
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.name == "ruff" then
						client.server_capabilities.hoverProvider = false
					end
				end,
			})

			-- LSP keymaps
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local opts = { buffer = ev.buf, silent = true, noremap = true }

					vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", vim.tbl_extend("force", opts, { desc = "Go to Definition" }))
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to Declaration" }))
					vim.keymap.set("n", "K", function()
						vim.lsp.buf.hover({ focusable = true })
						vim.defer_fn(function()
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
