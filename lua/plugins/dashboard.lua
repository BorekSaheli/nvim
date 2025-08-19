return {
	"nvimdev/dashboard-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "nvim-telescope/telescope.nvim" },
	event = "VimEnter",
	opts = {
		theme = "hyper",
		config = {
-- 			header = {
--   "⣿⡟⠙⠛⠋⠩⠭⣉⡛⢛⠫⠭⠄⠒⠄⠄⠄⠈⠉⠛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿",
--   "⣿⡇⠄⠄⠄⠄⣠⠖⠋⣀⡤⠄⠒⠄⠄⠄⠄⠄⠄⠄⠄⠄⣈⡭⠭⠄⠄⠄⠉⠙",
--   "⣿⡇⠄⠄⢀⣞⣡⠴⠚⠁⠄⠄⢀⠠⠄⠄⠄⠄⠄⠄⠄⠉⠄⠄⠄⠄⠄⠄⠄⠄",
--   "⣿⡇⠄⡴⠁⡜⣵⢗⢀⠄⢠⡔⠁⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄",
--   "⣿⡇⡜⠄⡜⠄⠄⠄⠉⣠⠋⠠⠄⢀⡄⠄⠄⣠⣆⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⢸",
--   "⣿⠸⠄⡼⠄⠄⠄⠄⢰⠁⠄⠄⠄⠈⣀⣠⣬⣭⣛⠄⠁⠄⡄⠄⠄⠄⠄⠄⢀⣿",
--   "⣏⠄⢀⠁⠄⠄⠄⠄⠇⢀⣠⣴⣶⣿⣿⣿⣿⣿⣿⡇⠄⠄⡇⠄⠄⠄⠄⢀⣾⣿",
--   "⣿⣸⠈⠄⠄⠰⠾⠴⢾⣻⣿⣿⣿⣿⣿⣿⣿⣿⣿⢁⣾⢀⠁⠄⠄⠄⢠⢸⣿⣿",
--   "⣿⣿⣆⠄⠆⠄⣦⣶⣦⣌⣿⣿⣿⣿⣷⣋⣀⣈⠙⠛⡛⠌⠄⠄⠄⠄⢸⢸⣿⣿",
--   "⣿⣿⣿⠄⠄⠄⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠈⠄⠄⠄⠄⠄⠈⢸⣿⣿",
--   "⣿⣿⣿⠄⠄⠄⠘⣿⣿⣿⡆⢀⣈⣉⢉⣿⣿⣯⣄⡄⠄⠄⠄⠄⠄⠄⠄⠈⣿⣿",
--   "⣿⣿⡟⡜⠄⠄⠄⠄⠙⠿⣿⣧⣽⣍⣾⣿⠿⠛⠁⠄⠄⠄⠄⠄⠄⠄⠄⠃⢿⣿",
--   "⣿⡿⠰⠄⠄⠄⠄⠄⠄⠄⠄⠈⠉⠩⠔⠒⠉⠄⠄⠄⠄⠄⠄⠄⠄⠄⠄⠐⠘⣿",
--   "⣿⠃⠃⠄⠄⠄⠄⠄⠄⣀⢀⠄⠄⡀⡀⢀⣤⣴⣤⣤⣀⣀⠄⠄⠄⠄⠄⠄⠁⢹",
--   "",
-- },
header = {
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
}
,

			-- week_header = {
			-- 	enable = true,
			-- },
			shortcut = {
				{ desc = "Lazy", group = "@property", action = "Lazy", key = "l" },
				{ desc = "Files", group = "Label", action = "Telescope find_files", key = "f", icon = " " },
				{ desc = "Grep", group = "Label", action = "Telescope live_grep", key = "g", icon = " " },
				-- add colse nvim with q
				{ desc = "Quit", group = "Label", action = "q", key = "q", icon = " " },
				-- { desc = "Settings", group = "Label", action = "e ~/.config/nvim/lua/plugins/dashboard.lua", key = "s", icon = "⚙️" },
			},

                        footer = {
                                "",
                                vim.fs.normalize(vim.fn.getcwd()),
                                "",
                        },
	},
}}
