return {
	"catppuccin/nvim",
	name = "catppuccin",
	config = function()
		require("catppuccin").setup {
			flavour = "mocha", -- latte, frappe, macchiato, mocha
			term_colors = true,
			transparent_background = false,
			no_italic = false,
			no_bold = false,
			styles = {
				comments = {},
				conditionals = {},
				loops = {},
				functions = {},
				keywords = {},
				strings = {},
				variables = {},
				numbers = {},
				booleans = {},
				properties = {},
				types = {},
			},
			color_overrides = {
				all = {
				  rosewater = "#f5e0dc",
				  flamingo = "#f2cdcd",
				  pink = "#515f1d",
				  mauve = "#a1193e",
				  red = "#7ca195",
				  maroon = "#7ca195",
				  peach = "#deb259",
				  yellow = "#f9e2af",
				  green = "#95ae3e",
				  teal = "#95ae3e",
				  sky = "#89dceb",
				  sapphire = "#74c7ec",
				  blue = "#a19588",
				  lavender = "#b4befe",
				  text = "#a19588",
				  subtext1 = "#bac2de",
				  subtext0 = "#a6adc8",
				  overlay2 = "#9399b2",
				  overlay1 = "#7f849c",
				  overlay0 = "#4a4a57",
				  surface2 = "#585b70",
				  surface1 = "#45475a",
				  surface0 = "#313244",
				  base = "#000000",
				  mantle = "#181825",
				  crust = "#11111b",
				},
			  },
			highlight_overrides = {
				mocha = function(C)
					return {
						TabLineSel = { bg = C.pink },
						CmpBorder = { fg = C.surface2 },
						Pmenu = { bg = C.none },
						TelescopeBorder = { link = "FloatBorder" },
					}
				end,
			},
		}

		vim.cmd.colorscheme "catppuccin"
	end,
}