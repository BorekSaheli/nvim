vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- use common clipboard
vim.opt.clipboard = "unnamedplus"

-- line numbering
vim.opt.number = true
vim.opt.relativenumber = true

vim.keymap.set("n", "<F5>", ":w<CR>:aboveleft split term://python %<CR>:startinsert<CR>:normal! G<CR>", {
	desc = "Run current Python file in top horizontal split and auto-scroll to end",
})

-- column options
vim.opt.signcolumn = "yes"

-- Disable Ctrl+Z motion
vim.opt.backup = false -- Prevents creating a backup file
vim.keymap.set("n", "<C-z>", "<Nop>", { desc = "Disable Ctrl+Z" }) -- Disable Ctrl+Z

-- save file on leader leader
vim.keymap.set("n", "<leader><leader>", ":w<CR>", { desc = "Save file" })

-- Windows-specific: Exclude problematic directories from file watching
if vim.fn.has("win32") == 1 then
	vim.opt.fsync = false
	-- Disable file watching for Windows system directories that cause EPERM errors
	vim.g.loaded_netrwPlugin = 1
	vim.g.loaded_netrw = 1
	
	-- Additional Windows LSP performance optimizations
	vim.opt.updatetime = 250  -- Faster update time for better LSP experience
	vim.opt.timeoutlen = 300  -- Faster which-key popup
end

-- LSP Performance optimizations
vim.opt.updatetime = 250  -- Reduce update time for better LSP experience
vim.opt.completeopt = { "menu", "menuone", "noselect" }  -- Better completion experience

-- Center screen after half-page movements
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up and center" })