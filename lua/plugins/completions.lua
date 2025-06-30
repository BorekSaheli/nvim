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

			-- Function to save Copilot toggle state
			local function save_copilot_state(state)
				local file = io.open(vim.fn.stdpath("data") .. "/copilot_state", "w")
				if file then
					file:write(state and "1" or "0")
					file:close()
				end
			end

			-- Function to load Copilot toggle state
			local function load_copilot_state()
				local file = io.open(vim.fn.stdpath("data") .. "/copilot_state", "r")
				if file then
					local state = file:read("*a")
					file:close()
					return state == "1"
				end
				return true -- Default to enabled
			end

			local copilot_enabled = load_copilot_state()

			-- Apply the saved state when Neovim starts
			vim.defer_fn(function()
				if copilot_enabled then
					vim.cmd("Copilot enable")
				else
					vim.cmd("Copilot disable")
				end
			end, 100)

			local function toggle_copilot()
				if copilot_enabled then
					vim.cmd("Copilot disable")
				else
					vim.cmd("Copilot enable")
				end
				copilot_enabled = not copilot_enabled
				save_copilot_state(copilot_enabled)
			end

			-- Key mapping to toggle Copilot suggestions
			vim.keymap.set("n", "<F9>", toggle_copilot, { noremap = true, silent = true, desc = "Toggle Copilot" })

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