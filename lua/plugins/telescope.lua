return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			cond = function()
				return vim.fn.executable("cmake") == 1
			end,
		},
		"nvim-telescope/telescope-ui-select.nvim",
	},
	keys = {
		{ "<leader>fp", "<cmd>Telescope builtin<cr>", desc = "Builtin Pickers" },
		{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
		{ "<leader>fF", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find Hidden Files" },
		{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
		{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "List Buffers" },
		{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
	},
	config = function(_, opts)
		local telescope = require("telescope")
		local actions = require("telescope.actions")

		telescope.setup({
			defaults = {
				layout_strategy = "vertical",
				mappings = {
					i = {
						["<esc>"] = actions.close,
						["<C-j>"] = actions.select_horizontal,
						["<C-l>"] = actions.select_vertical,
					},
				},
			},
			pickers = {
				lsp_definitions = {
					jump_type = "tab",
					show_line = false,
					initial_mode = "normal",
					reuse_win = true,
					trim_text = true,
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown({}),
				},
			},
		})

		-- Safe loading of extensions
		pcall(telescope.load_extension, "fzf")
		pcall(telescope.load_extension, "ui-select")
	end,
}