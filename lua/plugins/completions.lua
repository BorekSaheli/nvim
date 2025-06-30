return {
	-- Completion engine
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local state = require("core.state")

			-- Set the initial state for Copilot
			state.copilot.set_initial_state("Copilot enable", "Copilot disable")

			-- Key mapping to toggle Copilot suggestions
			vim.keymap.set("n", "<F9>", function()
				local is_enabled = state.copilot.toggle()
				if is_enabled then
					vim.cmd("Copilot enable")
				else
					vim.cmd("Copilot disable")
				end
			end, { noremap = true, silent = true, desc = "Toggle Copilot" })

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				-- Set up completion sources
				sources = cmp.config.sources({
					{ name = "nvim_lsp" }, -- LSP suggestions
					{ name = "luasnip" }, -- Snippets from LSP
				}),
			})
		end,
	},

	-- Snippet engine
	{
		"L3MON4D3/LuaSnip",
		-- friendly-snippets is removed to avoid generic snippets
		dependencies = { "saadparwaiz1/cmp_luasnip" },
	},

	-- Copilot for ghost text suggestions
	{
		"github/copilot.vim",
	},
}