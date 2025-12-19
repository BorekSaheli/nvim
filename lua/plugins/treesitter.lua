return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = "VeryLazy",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		opts = {
			-- Parsers that should always be installed
			ensure_installed = { "python", "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
			-- Auto install missing parsers when entering a buffer
			auto_install = true,

			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = false,
					node_incremental = ";",
					node_decremental = ",",
				},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		main = "nvim-treesitter.configs",
		opts = {
			textobjects = {
				move = {
					enable = true,
					goto_next_start = {
						["]a"] = { query = "@parameter.outer", desc = "Next Argument Start" },
						["]c"] = { query = "@class.outer", desc = "Next Class Start" },
						["]f"] = { query = "@function.outer", desc = "Next Function Start" },
						["]i"] = { query = "@conditional.outer", desc = "Next If Start" },
						["]l"] = { query = "@loop.outer", desc = "Next Loop Start" },
						["]o"] = { query = "@comment.outer", desc = "Next Comment Start" },
						["]r"] = { query = "@return.outer", desc = "Next Return Start" },
					},
					goto_next_end = {
						["]A"] = { query = "@parameter.outer", desc = "Next Argument End" },
						["]C"] = { query = "@class.outer", desc = "Next Class End" },
						["]F"] = { query = "@function.outer", desc = "Next Function End" },
						["]I"] = { query = "@conditional.outer", desc = "Next If End" },
						["]L"] = { query = "@loop.outer", desc = "Next Loop End" },
						["]O"] = { query = "@comment.outer", desc = "Next Comment End" },
						["]R"] = { query = "@return.outer", desc = "Next Return End" },
					},
					goto_previous_start = {
						["[a"] = { query = "@parameter.outer", desc = "Previous Argument Start" },
						["[c"] = { query = "@class.outer", desc = "Previous Class Start" },
						["[f"] = { query = "@function.outer", desc = "Previous Function Start" },
						["[i"] = { query = "@conditional.outer", desc = "Previous If Start" },
						["[l"] = { query = "@loop.outer", desc = "Previous Loop Start" },
						["[o"] = { query = "@comment.outer", desc = "Previous Comment Start" },
						["[r"] = { query = "@return.outer", desc = "Previous Return Start" },
					},
					goto_previous_end = {
						["[A"] = { query = "@parameter.outer", desc = "Previous Argument End" },
						["[C"] = { query = "@class.outer", desc = "Previous Class End" },
						["[F"] = { query = "@function.outer", desc = "Previous Function End" },
						["[I"] = { query = "@conditional.outer", desc = "Previous If End" },
						["[L"] = { query = "@loop.outer", desc = "Previous Loop End" },
						["[O"] = { query = "@comment.outer", desc = "Previous Comment End" },
						["[R"] = { query = "@return.outer", desc = "Previous Return End" },
					},
				},
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["aa"] = { query = "@parameter.outer", desc = "Select Argument" },
						["ia"] = { query = "@parameter.inner", desc = "Select Inner Argument" },

						["ac"] = { query = "@class.outer", desc = "Select Class" },
						["ic"] = { query = "@class.inner", desc = "Select Inner Class" },

						["af"] = { query = "@function.outer", desc = "Select Function" },
						["if"] = { query = "@function.inner", desc = "Select Inner Function" },

						["ai"] = { query = "@conditional.outer", desc = "Select If" },
						["ii"] = { query = "@conditional.inner", desc = "Select Inner If" },

						["al"] = { query = "@loop.outer", desc = "Select Loop" },
						["il"] = { query = "@loop.inner", desc = "Select Inner Loop" },

						["ao"] = { query = "@comment.outer", desc = "Select Comment" },
						["io"] = { query = "@comment.inner", desc = "Select Inner Comment" },

						["ar"] = { query = "@return.outer", desc = "Select Return" },
						["ir"] = { query = "@return.inner", desc = "Select Inner Return" },
					},
				},
				swap = {
					enable = true,
					swap_next = {
						["<leader>wa"] = { query = "@parameter.inner", desc = "Swap Next Argument" },
						["<leader>wc"] = { query = "@class.outer", desc = "Swap Next Class" },
						["<leader>wf"] = { query = "@function.outer", desc = "Swap Next Function" },
						["<leader>wi"] = { query = "@conditional.outer", desc = "Swap Next If" },
						["<leader>wl"] = { query = "@loop.outer", desc = "Swap Next Loop" },
					},
					swap_previous = {
						["<leader>wA"] = { query = "@parameter.inner", desc = "Swap Previous Argument" },
						["<leader>wC"] = { query = "@class.outer", desc = "Swap Previous Class" },
						["<leader>wF"] = { query = "@function.outer", desc = "Swap Previous Function" },
						["<leader>wI"] = { query = "@conditional.outer", desc = "Swap Previous If" },
						["<leader>wL"] = { query = "@loop.outer", desc = "Swap Previous Loop" },
					},
				},
			},
		},
	},
}