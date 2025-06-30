local theme = {}

theme.name = "Golden Haze 2"

-- Using the same warm, retro color palette
theme.colors = {
	rosewater = "#f5e0dc",
	flamingo = "#f2cdcd",
	pink = "#515f1d",
	mauve = "#c6003c",
	red = "#93b7ab",
	maroon = "#b0cfc4",
	peach = "#deb259",
	yellow = "#a19588",
	green = "#9dba2a",
	teal = "#95ae3e",
	sky = "#89dceb",
	sapphire = "#74c7ec",
	blue = "#a19588",
	lavender = "#93b7ab",
	text = "#f9e2af",
	subtext1 = "#bac2de",
	subtext0 = "#a6adc8",
	overlay2 = "#4a4a57",
	overlay1 = "#7f849c",
	overlay0 = "#4a4a57",
	surface2 = "#585b70",
	surface1 = "#45475a",
	surface0 = "#313244",
	base = "#000000",
	mantle = "#000000",
	crust = "#11111b",
	def_color = "#5f9e25",
	light_mauve = "#af4b57",
	operator_color = "#2f8870",
}

-- Generalized highlight overrides for broad language support
theme.highlights = function(C)
	return {
		-- UI & Plugin Highlighting
		TabLineSel = { bg = C.pink },
		CmpBorder = { fg = C.surface2 },
		Pmenu = { bg = C.none },
		TelescopeBorder = { link = "FloatBorder" },

		-- General Syntax Highlighting (using generic Treesitter groups)
		["@keyword"] = { fg = C.mauve },
		["@keyword.function"] = { fg = C.def_color, bold = true, italic = true },
		["@keyword.operator"] = { fg = C.mauve },

		["@function"] = { fg = C.peach, bold = true },
		["@function.builtin"] = { fg = C.peach, bold = true, italic = true },
		["@function.macro"] = { fg = C.teal },

		["@method"] = { fg = C.peach, bold = true },
		["@constructor"] = { fg = C.yellow, bold = true },

		["@type"] = { fg = C.yellow },
		["@type.builtin"] = { fg = C.yellow, italic = true },

		["@variable"] = { fg = C.text },
		["@variable.builtin"] = { fg = C.red, italic = true }, -- e.g., 'self', 'this'

		["@constant"] = { fg = C.light_mauve },
		["@constant.builtin"] = { fg = C.light_mauve, bold = true },

		["@number"] = { fg = C.light_mauve, bold = true },
		["@float"] = { fg = C.light_mauve, bold = true },
		["@boolean"] = { fg = C.light_mauve, bold = true },

		["@string"] = { fg = C.green },
		["@string.escape"] = { fg = C.sky },

		["@operator"] = { fg = C.operator_color },

		["@punctuation.delimiter"] = { fg = C.overlay1 },
		["@punctuation.bracket"] = { fg = C.overlay1 },
		["@punctuation.special"] = { fg = C.teal },

		["@comment"] = { fg = C.surface2, italic = true },
		["@comment.error"] = { fg = C.mauve, bg = C.surface0 },
		["@comment.warning"] = { fg = C.peach, bg = C.surface0 },

		["@tag"] = { fg = C.red },
		["@tag.attribute"] = { fg = C.yellow },
		["@tag.delimiter"] = { fg = C.operator_color },
	}
end

return theme
