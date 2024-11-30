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
vim.keymap.set('n', '<leader><CR>', ':w<CR>:!python %<CR>', {
    desc = "Run current Python file"
})

