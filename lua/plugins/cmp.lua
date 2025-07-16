return {
	{
		"hrsh7th/nvim-cmp",
		enabled = true,
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		event = "InsertEnter",
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local state = require("core.state")

			-- Track LSP status
			local lsp_ready = false
			
			-- Function to check if any LSP clients are attached
			local function check_lsp_status()
				local clients = vim.lsp.get_active_clients({ bufnr = 0 })
				local has_lsp = #clients > 0
				
				if has_lsp and not lsp_ready then
					lsp_ready = true
					vim.notify("LSP completions ready!", vim.log.levels.INFO)
				elseif not has_lsp and lsp_ready then
					lsp_ready = false
					vim.notify("LSP disconnected", vim.log.levels.WARN)
				end
				
				return has_lsp
			end

			-- Setup completion
			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ 
						name = "nvim_lsp",
						priority = 1000,
					},
				}),
				performance = {
					debounce = 60,
					throttle = 30,
					fetching_timeout = 500,
				},
				completion = {
					completeopt = "menu,menuone,noselect",
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				formatting = {
					format = function(entry, vim_item)
						-- Kind icons
						local icons = {
							Text = "󰉿",
							Method = "󰆧",
							Function = "󰊕",
							Constructor = "",
							Field = "󰜢",
							Variable = "󰀫",
							Class = "󰠱",
							Interface = "",
							Module = "",
							Property = "󰜢",
							Unit = "󰑭",
							Value = "󰎠",
							Enum = "",
							Keyword = "󰌋",
							Snippet = "",
							Color = "󰏘",
							File = "󰈙",
							Reference = "󰈇",
							Folder = "󰉋",
							EnumMember = "",
							Constant = "󰏿",
							Struct = "󰙅",
							Event = "",
							Operator = "󰆕",
							TypeParameter = "",
						}

						vim_item.kind = string.format("%s %s", icons[vim_item.kind] or "", vim_item.kind)
						
						-- More distinctive source labels
						local source_names = {
							nvim_lsp = "󰒋 LSP",
						}
						
						vim_item.menu = source_names[entry.source.name] or "[" .. entry.source.name .. "]"
						
						-- Limit text width for better display
						if string.len(vim_item.abbr) > 40 then
							vim_item.abbr = string.sub(vim_item.abbr, 1, 37) .. "..."
						end

						return vim_item
					end,
				},
			})

			-- LSP event handlers for debugging
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client then
						vim.notify(string.format("LSP attached: %s", client.name), vim.log.levels.INFO)
						lsp_ready = true
					end
				end,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client then
						vim.notify(string.format("LSP detached: %s", client.name), vim.log.levels.WARN)
						-- Check if any other LSP clients are still attached
						vim.defer_fn(function()
							check_lsp_status()
						end, 100)
					end
				end,
			})

			-- Function to toggle completion borders without affecting core functionality
			local function toggle_completion_borders()
				local is_enabled = state.completion_borders.is_enabled()
				
				if is_enabled then
					-- Show borders
					cmp.setup.buffer({
						window = {
							completion = cmp.config.window.bordered(),
							documentation = cmp.config.window.bordered(),
						},
					})
				else
					-- Hide borders
					cmp.setup.buffer({
						window = {
							completion = cmp.config.window.bordered({
								border = "none",
								winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
							}),
							documentation = cmp.config.window.bordered({
								border = "none",
								winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
							}),
						},
					})
				end
			end

			-- F8 keymap to toggle completion borders only
			vim.keymap.set("n", "<F8>", function()
				state.completion_borders.toggle()
				toggle_completion_borders()
				local status = state.completion_borders.is_enabled() and "enabled" or "disabled"
				vim.notify("Completion borders " .. status, vim.log.levels.INFO)
			end, { desc = "Toggle Completion Borders" })
		end,
	},
}
