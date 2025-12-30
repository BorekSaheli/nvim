return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim", -- Required dependency
		"rcarriga/nvim-notify", -- Optional: for notifications
	},
	config = function()
		require("noice").setup({
			-- Custom view positions
			cmdline = {
				view = "cmdline_popup", -- Use popup instead of bottom cmdline
				format = {
					cmdline = { icon = ":" },
				},
			},
			views = {
				cmdline_popup = {
					position = {
						row = "50%", -- Center vertically
						col = "50%", -- Center horizontally
					},
					size = {
						width = 80,
						height = "auto",
					},
					border = {
						style = "rounded",
					},
					win_options = {
						wrap = true,
						linebreak = true,
					},
				},
				popupmenu = {
					position = {
						row = "60%", -- Position below cmdline
						col = "50%",
					},
					size = {
						width = 60,
						height = 10,
					},
					border = {
						style = "rounded",
					},
				},
				notify = {
					position = {
						row = 1, -- Top of screen
						col = "100%", -- Right side
					},
					size = {
						width = "auto",
						height = "auto",
					},
					win_options = {
						wrap = true,
						linebreak = true,
					},
				},
			},
			lsp = {
				-- Override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			-- Recommended presets for better UX
			presets = {
				bottom_search = false, -- Use centered search (cmdline is now centered)
				command_palette = false, -- We're customizing cmdline position
				long_message_to_split = true, -- Long messages will be sent to a split
				inc_rename = false, -- Enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- Add a border to hover docs and signature help
			},
			-- Routes to customize message handling
			routes = {
				{
					filter = {
						event = "msg_show",
						kind = "",
						find = "written",
					},
					opts = { skip = true }, -- Skip "written" messages
				},
				{
					view = "notify",
					filter = { event = "msg_showmode" },
				},
			},
		})

		-- Custom highlight groups to make cmdline bold instead of italic
		vim.api.nvim_set_hl(0, "NoiceCmdlineIcon", { bold = true, italic = false })
		vim.api.nvim_set_hl(0, "NoiceCmdlinePrompt", { bold = true, italic = false })
		vim.api.nvim_set_hl(0, "NoiceCmdline", { bold = true, italic = false })

		-- Setup nvim-notify with Catppuccin integration
		local notify = require("notify")
		notify.setup({
			background_colour = "#000000", -- Transparent background
			fps = 60,
			render = "compact",
			timeout = 3000,
			top_down = true, -- Show notifications from top down
			stages = "fade", -- Animation style
			max_width = 50,
			max_height = 10,
		})
		vim.notify = notify
	end,
}
