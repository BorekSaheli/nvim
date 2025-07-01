return {
	name = "Golden Haze",
	colors = {
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
	},
	highlights = function(C)
		return {
			-- Existing overrides
			TabLineSel = { bg = C.pink },
			CmpBorder = { fg = C.surface2 },
			Pmenu = { bg = C.none },
			TelescopeBorder = { link = "FloatBorder" },

			-- Override for 'def' keyword
			["@keyword.function.python"] = { fg = C.def_color, bold = true, italic = true },

			-- Apply new color to numbers, floats, and booleans
			["@number"] = { fg = C.light_mauve, bold = true },
			["@float"] = { fg = C.light_mauve, bold = true },
			["@number.float.python"] = { fg = C.light_mauve, bold = true },
			["@boolean"] = { fg = C.light_mauve, bold = true },

			-- Apply new color to constants
			["@constant.builtin"] = { fg = C.light_mauve, bold = true },

			-- Make built-in functions bold and peach-colored
			["@function.builtin"] = { fg = C.peach, bold = true },

			-- Make function definitions bold and peach-colored
			["@function.python"] = { fg = C.peach, bold = true },
			["@function.method.python"] = { fg = C.peach, bold = true },

			-- Make 'class' keyword bold and peach-colored
			["@keyword.type"] = { fg = C.peach, bold = true },

			-- Apply new color to operators
			["@operator"] = { fg = C.operator_color },

			["@keyword.operator.python"] = { fg = C.mauve },

			["@punctuation.delimiter.python"] = { fg = C.text },

			-- Highlight for `#` symbol in comments
			CommentHash = { fg = C.dark_blue },
		}
	end,
}