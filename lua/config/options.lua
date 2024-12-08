vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- time between keypresses
-- vim.opt.timeoutlen = 300

-- use common clipboard
vim.opt.clipboard = "unnamedplus"

-- line numbering
vim.opt.number = true
vim.opt.relativenumber = true

-- -- Auto format on save for Python files
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     pattern = "*.py",
--     callback = function()
--         vim.lsp.buf.format({ async = false })
--     end,
--     desc = "Auto format Python files on save",
-- })
vim.keymap.set('n', '<F5>', ':w<CR>:aboveleft split term://python %<CR>:startinsert<CR>:normal! G<CR>', {
    desc = "Run current Python file in top horizontal split and auto-scroll to end"
})


-- column options
vim.opt.signcolumn = "yes"

-- Disable Ctrl+Z motion
vim.opt.backup = false  -- Prevents creating a backup file
vim.keymap.set('n', '<C-z>', '<Nop>', { desc = "Disable Ctrl+Z" })  -- Disable Ctrl+Z

-- save file on leader leader
vim.keymap.set('n', '<leader><leader>', ':w<CR>', { desc = "Save file" })

-- -- Comment/uncomment current line or selected text
-- vim.keymap.set('n', '<leader>c', '<Plug>(comment_toggle_linewise_current)', { desc = "Comment/uncomment current line" })
-- vim.keymap.set('x', '<leader>c', '<Plug>(comment_toggle_linewise_visual)', { desc = "Comment/uncomment selected text" })

