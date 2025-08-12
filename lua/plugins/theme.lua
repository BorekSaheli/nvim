return {
	"catppuccin/nvim",
	name = "catppuccin",
	config = function()
		vim.o.termguicolors = true
		
		-- Toggle this to enable/disable custom theme
		local use_custom_theme = false
		local golden_haze = use_custom_theme and require("theme.custom-pop-n-lock") or nil
		
		-- Background options: "stock", "black", "gray"
		local background_mode = "stock"

		require("catppuccin").setup({
			flavour = "mocha",
			term_colors = true,
			-- transparent_background = background_mode == "stock",
			transparent_background = true,
			no_italic = false,
			no_bold = false,
			styles = {
				comments = {},
				conditionals = {},
				loops = {},
				functions = { "bold" },
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
			},
			color_overrides = use_custom_theme and { all = golden_haze.colors } or 
				(background_mode ~= "stock" and {
					all = {
						base = background_mode == "black" and "#000000" or "#1e1e2e",
					}
				} or {}),
			highlight_overrides = use_custom_theme and {
				mocha = function(colors)
					local highlights = golden_haze and golden_haze.highlights and golden_haze.highlights(colors) or {}
					return highlights
				end,
			} or (background_mode ~= "stock" and {
				mocha = function(colors)
					local bg_color = background_mode == "black" and "#000000" or "#1e1e2e"
					return {
						Normal = { bg = bg_color },
						NormalFloat = { bg = bg_color },
					}
				end,
			} or {}),
		})

		vim.opt.guifont = "JetBrainsMonoNL Nerd Font:h12"
		vim.cmd.colorscheme("catppuccin")

		-- Only apply custom highlight overrides when not using stock background
		if background_mode ~= "stock" then
			-- Simulate darker background for line numbers and diagnostic column
			vim.api.nvim_set_hl(0, "LineNr", { fg = "#7f849c", bg = "NONE" })
			vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#f9e2af", bg = "NONE", bold = true })
			vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "VertSplit", { bg = "NONE", fg = "#45475a" })
		end
	end,
}