-- ASCII art styles
local ascii_styles = {
	corporate = {
		"                        ...                ....                                                     ",
		"                          ,llcc            llll                                                     ",
		"               ..,,'...     ,l.            llll                                                     ",
		"                 .lllllll   l:             llll                                                     ",
		"      .';,..         lll'  :lc,'..         llll'.,;:;,.      ..',;::;;'      ,,,,..,;::;...',;::;'  ",
		" ..;clllllllllc;'    lll:',llllllll        llll.   llllc            clll.   .llll    ;llll.   ,llll ",
		"    'llllllllllll   'llllllllllll;         llll     ;lllc           'lll'   .llll     llll     llll.",
		"        .llllllll   llllllllllll           llll     .llll    .;:clllllll'   .llll     llll     llll.",
		"         ;lllllllc;,llllllllll;            llll     'lll:   clll    'lll'   .llll     llll     llll.",
		"         'lllllllllllllllllll              llll    .lll;    llll.   'lll'   .llll     llll     llll.",
		"         .lllllllllllllllll:               llllc:clll.       cllllcc:lll'   .llll     llll     llll.",
		"         .l.   .llllllllll.                                                                         ",
		"                   cllll:                                                                           ",
		"                      ..                                                                            ",
	},
	personal = {
		"⣿⡟⠙⠛⠋⠩⠭⣉⡛⢛⠫⠭⠄⠒⠄⠄⠄⠈⠉⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
		"⣿⡇⠄⠄⠄⠄⣠⠖⠋⣀⡤⠄⠒⠄⠄⠄⠄⠄⠄⠄⠄⠄⣈⡭⠭⠄⠄⠄⠉⠙",
		"⣿⡇⠄⠄⢀⣞⣡⠴⠚⠁⠄⠄⢀⠠⠄⠄⠄⠄⠄⠄⠄⠉⠄⠄⠄⠄⠄⠄⠄⠄",
		"⣿⡇⠄⡴⠁⡜⣵⢗⢀⠄⢠⡔⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄",
		"⣿⡇⡜⠄⡜⠄⠄⠄⠉⣠⠋⠠⠄⢀⡄⠄⠄⣠⣆⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢸",
		"⣿⠸⠄⡼⠄⠄⠄⠄⢰⠁⠄⠄⠄⠈⣀⣠⣬⣭⣛⠄⠁⠄⡄⠄⠄⠄⠄⠄⢀⣿",
		"⣏⠄⢀⠁⠄⠄⠄⠄⠇⢀⣠⣴⣶⣿⣿⣿⣿⣿⣿⡇⠄⠄⡇⠄⠄⠄⠄⢀⣾⣿",
		"⣿⣸⠈⠄⠄⠰⠾⠴⢾⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⢁⣾⢀⠁⠄⠄⠄⢠⢸⣿⣿",
		"⣿⣿⣆⠄⠆⠄⣦⣶⣦⣌⣿⣿⣿⣿⣷⣋⣀⣈⠙⠛⡛⠌⠄⠄⠄⠄⢸⢸⣿⣿",
		"⣿⣿⣿⠄⠄⠄⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠈⠄⠄⠄⠄⠄⠈⢸⣿⣿",
		"⣿⣿⣿⠄⠄⠄⠘⣿⣿⣿⡆⢀⣈⣉⢉⣿⣿⣯⣄⡄⠄⠄⠄⠄⠄⠄⠄⠈⣿⣿",
		"⣿⣿⡟⡜⠄⠄⠄⠄⠙⠿⣿⣧⣽⣍⣾⣿⠿⠛⠁⠄⠄⠄⠄⠄⠄⠄⠄⠃⢿⣿",
		"⣿⡿⠰⠄⠄⠄⠄⠄⠄⠄⠄⠈⠉⠩⠔⠒⠉⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠐⠘⣿",
		"⣿⠃⠃⠄⠄⠄⠄⠄⠄⣀⢀⠄⠄⡀⡀⢀⣤⣴⣤⣤⣀⣀⠄⠄⠄⠄⠄⠄⠁⢹",
		"",
	},
}

-- Load current style from file
local ascii_file = vim.fn.stdpath("data") .. "/dashboard_ascii_style"
local function load_ascii_style()
	local file = io.open(ascii_file, "r")
	if file then
		local content = file:read("*a")
		file:close()
		return content:match("personal") and "personal" or "corporate"
	end
	return "corporate" -- Default
end

local function save_ascii_style(style)
	local file = io.open(ascii_file, "w")
	if file then
		file:write(style)
		file:close()
	end
end

local current_style = load_ascii_style()

-- Function to toggle ASCII art style
local function toggle_ascii_style()
	current_style = (current_style == "corporate") and "personal" or "corporate"
	save_ascii_style(current_style)

	local db = require("dashboard")
	db.setup({
		theme = "hyper",
		config = {
			header = ascii_styles[current_style],
			shortcut = {
				{ desc = "Find File", group = "@property", action = "Telescope find_files", key = "f" },
				{ desc = "Grep", group = "Label", action = "Telescope live_grep", key = "g" },
				{ desc = "New File", group = "DiagnosticHint", action = "enew", key = "n" },
				{ desc = "Lazy", group = "String", action = "Lazy", key = "l" },
				{ desc = "Config", group = "Constant", action = "e ~/.config/nvim/init.lua", key = "c" },
				{ desc = "Quit", group = "Error", action = "qa", key = "q" },
			},
			footer = function()
				local os_icons = {
					Darwin = "\u{f179}  macOS",
					Linux = "\u{f17c}  Linux",
					Windows = "\u{f17a}  Windows",
				}
				local os_name = vim.loop.os_uname().sysname
				return { "", os_icons[os_name] or ("\u{f109}  " .. os_name) }
			end,
			disable_move = true,
		},
	})

	vim.notify("ASCII style: " .. current_style, vim.log.levels.INFO)
	vim.cmd("Dashboard")
end

-- Export toggle function
_G.toggle_dashboard_ascii = toggle_ascii_style

return {
	"nvimdev/dashboard-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "nvim-telescope/telescope.nvim" },
	event = "VimEnter",
	opts = {
		theme = "hyper",
		config = {
			header = ascii_styles[current_style],
			shortcut = {
				{ desc = "Find File", group = "@property", action = "Telescope find_files", key = "f" },
				{ desc = "Grep", group = "Label", action = "Telescope live_grep", key = "g" },
				{ desc = "New File", group = "DiagnosticHint", action = "enew", key = "n" },
				{ desc = "Lazy", group = "String", action = "Lazy", key = "l" },
				{ desc = "Config", group = "Constant", action = "e ~/.config/nvim/init.lua", key = "c" },
				{ desc = "Quit", group = "Error", action = "qa", key = "q" },
			},
			footer = function()
				local os_icons = {
					Darwin = "\u{f179}  macOS",
					Linux = "\u{f17c}  Linux",
					Windows = "\u{f17a}  Windows",
				}
				local os_name = vim.loop.os_uname().sysname
				return { "", os_icons[os_name] or ("\u{f109}  " .. os_name) }
			end,
			disable_move = true, -- This prevents scrolling
		},
	},
}
