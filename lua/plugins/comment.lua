return {
	"numToStr/Comment.nvim",
	config = function()
		require("Comment").setup()

		-- Add keymaps with descriptions
		vim.keymap.set("n", "<leader>c", "<Plug>(comment_toggle_linewise_current)", { desc = "Toggle comment" })
		vim.keymap.set("x", "<leader>c", "<Plug>(comment_toggle_linewise_visual)", { desc = "Toggle comment" })
	end,
}