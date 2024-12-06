return {
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup()

    -- Comment/uncomment current line or selected text
    vim.keymap.set('n', '<leader>c', '<Plug>(comment_toggle_linewise_current)', { desc = "Comment/uncomment current line" })
    vim.keymap.set('x', '<leader>c', '<Plug>(comment_toggle_linewise_visual)', { desc = "Comment/uncomment selected text" })
  end
}
