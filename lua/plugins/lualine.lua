return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local state = require("core.state")

		-- Borek colour palette (taken from borektheme.omp.json)
		local colors = {
			base = "#000000",
			text = "#f9e2af",
			surface0 = "#313244",
			crust = "#11111b",
			overlay1 = "#7f849c",

			peach = "#deb259", -- yellow-orange
			sapphire = "#74c7ec", -- cyan-blue
			lavender = "#93b7ab", -- soft teal
			mauve = "#c6003c", -- magenta-red
			teal = "#95ae3e", -- olive-green
		}

		-- Lualine theme table that mirrors Borek
		local borek_theme = {
			normal = {
				a = { fg = colors.base, bg = colors.peach, gui = "bold" },
				b = { fg = colors.text, bg = colors.surface0 },
				c = { fg = colors.text, bg = colors.crust },
			},
			insert = {
				a = { fg = colors.base, bg = colors.sapphire, gui = "bold" },
				b = { fg = colors.text, bg = colors.surface0 },
				c = { fg = colors.text, bg = colors.crust },
			},
			visual = {
				a = { fg = colors.base, bg = colors.lavender, gui = "bold" },
				b = { fg = colors.text, bg = colors.surface0 },
				c = { fg = colors.text, bg = colors.crust },
			},
			replace = {
				a = { fg = colors.base, bg = colors.mauve, gui = "bold" },
				b = { fg = colors.text, bg = colors.surface0 },
				c = { fg = colors.text, bg = colors.crust },
			},
			command = {
				a = { fg = colors.base, bg = colors.teal, gui = "bold" },
				b = { fg = colors.text, bg = colors.surface0 },
				c = { fg = colors.text, bg = colors.crust },
			},
			inactive = {
				a = { fg = colors.overlay1, bg = colors.surface0 },
				b = { fg = colors.overlay1, bg = colors.surface0 },
				c = { fg = colors.overlay1, bg = colors.crust },
			},
		}

		-- Custom highlight just for the Python logo
		vim.api.nvim_set_hl(0, "LualinePythonIcon", { fg = colors.peach })

		-- Helper callbacks
		local function get_venv()
			local venv = vim.env.VIRTUAL_ENV
			if not venv then
				return nil
			end
			
			-- Extract venv name (works for both Windows and Unix paths)
			local venv_name = venv:match("([^/\\]+)$")
			return venv_name
		end

		local function get_python_version()
			local handle = io.popen("python --version 2>&1")
			if handle then
				local result = handle:read("*a")
				handle:close()
				local version = result:match("Python (%d+%.%d+%.%d+)")
				return version
			end
			return nil
		end

		local function filetype_with_venv()
			local ft = vim.bo.filetype
			local venv = get_venv()
			if venv and ft == "python" then
				return "%#LualinePythonIcon# %* " .. venv .. " " .. (get_python_version() or "")
			end
			return ft
		end

		local function copilot_status()
			return _G.COPILOT_ENABLED and "" or ""
		end

		local function diagnostic_status()
			return _G.DIAGNOSTICS_ENABLED and "󱖫  on" or "󱖫 off"
		end

		local function completion_status()
			return _G.COMPLETION_ENABLED and "󰍉  on" or "󰍉 off"
		end

		-- Lualine setup
		require("lualine").setup({
			options = {
				theme = borek_theme,
				component_separators = "",
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_x = {
					"encoding",
					"fileformat",
					copilot_status,
					diagnostic_status,
					completion_status,
					filetype_with_venv,
				},
			},
		})
	end,
}