return {
	"numToStr/Comment.nvim",
	keys = {
		{ "<leader>c", "<Plug>(comment_toggle_linewise_current)", desc = "Toggle comment", mode = "n" },
		{ "<leader>c", "<Plug>(comment_toggle_linewise_visual)", desc = "Toggle comment", mode = "x" },
	},
	config = function()
		require("Comment").setup()
	end,
}
