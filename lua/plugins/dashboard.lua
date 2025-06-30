return {
	"nvimdev/dashboard-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", "nvim-telescope/telescope.nvim" },
	event = "VimEnter",
	opts = {
		theme = "hyper",
		config = {
			week_header = {
				enable = true,
			},
			shortcut = {
				{ desc = "Lazy", group = "@property", action = "Lazy", key = "l" },
				{ desc = "Files", group = "Label", action = "Telescope find_files", key = "f", icon = " " },
				{ desc = "Grep", group = "Label", action = "Telescope live_grep", key = "g", icon = " " },
			},
		},
	},
}