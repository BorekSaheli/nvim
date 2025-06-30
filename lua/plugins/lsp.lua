return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "pyright" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "hrsh7th/cmp-nvim-lsp" },
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			-- Setup for pyright
			lspconfig.pyright.setup({
				capabilities = capabilities,
				on_init = function(client)
					-- This is to prevent a conflict with other plugins that might provide semantic tokens
					client.server_capabilities.semanticTokensProvider = nil
				end,
			})

			-- Setup for lua_ls
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})

			

			-- Keymaps for LSP actions
			vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show Hover Information" })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
		end,
	},
}