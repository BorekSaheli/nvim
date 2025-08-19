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

                        -- User option to enable/disable LSP notifications
                        if vim.g.cmp_lsp_notify == nil then
                                vim.g.cmp_lsp_notify = true
                        end

                        -- Debounced notify helper
                        local last_lsp_notify = 0
                        local function notify_lsp(msg, level)
                                if not vim.g.cmp_lsp_notify then
                                        return
                                end
                                local now = vim.loop.now()
                                if now - last_lsp_notify > 1000 then
                                        vim.notify(msg, level)
                                        last_lsp_notify = now
                                end
                        end

			-- Track LSP status
			local lsp_ready = false
			
			-- Function to check if any LSP clients are attached
			local function check_lsp_status()
				local clients = vim.lsp.get_active_clients({ bufnr = 0 })
				local has_lsp = #clients > 0
				
                                if has_lsp and not lsp_ready then
                                        lsp_ready = true
                                        notify_lsp("LSP completions ready!", vim.log.levels.INFO)
                                elseif not has_lsp and lsp_ready then
                                        lsp_ready = false
                                        notify_lsp("LSP disconnected", vim.log.levels.WARN)
                                end
				
				return has_lsp
			end

			-- Setup completion
			cmp.setup({
				enabled = function()
					return _G.COMPLETION_ENABLED
				end,
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
                                                notify_lsp(string.format("LSP attached: %s", client.name), vim.log.levels.INFO)
                                                lsp_ready = true
                                        end
				end,
			})

			vim.api.nvim_create_autocmd("LspDetach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
                                        if client then
                                                notify_lsp(string.format("LSP detached: %s", client.name), vim.log.levels.WARN)
                                                -- Check if any other LSP clients are still attached
                                                vim.defer_fn(function()
                                                        check_lsp_status()
                                                end, 100)
                                        end
				end,
			})

		end,
	},
}
