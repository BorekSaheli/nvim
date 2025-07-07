return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- This configuration is now handled by mason.lua
			-- The Mason configuration will automatically set up LSP servers
			-- and provide the necessary keymaps when LSP attaches to a buffer
		end,
	},
}