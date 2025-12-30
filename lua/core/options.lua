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

-- Indentation settings
vim.opt.tabstop = 2        -- Number of spaces a tab counts for
vim.opt.shiftwidth = 2     -- Number of spaces for each indent step
vim.opt.softtabstop = 2    -- Number of spaces when editing
vim.opt.expandtab = true   -- Convert tabs to spaces
vim.opt.smartindent = true -- Smart autoindenting on new lines

-- Disable Ctrl+Z motion
vim.opt.backup = false -- Prevents creating a backup file
vim.keymap.set("n", "<C-z>", "<Nop>", { desc = "Disable Ctrl+Z" }) -- Disable Ctrl+Z

-- Swap file handling to prevent warnings when multiple instances are open
vim.opt.swapfile = true -- Keep swap files for crash recovery
vim.opt.shortmess:append("A") -- Ignore swapfile warnings when opening files

-- save file on leader leader
vim.keymap.set("n", "<leader><leader>", ":w<CR>", { desc = "Save file" })

-- Auto-create parent directories when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
	group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
	callback = function(event)
		local file = vim.loop.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
})

-- Windows-specific: Exclude problematic directories from file watching
local IS_WINDOWS = vim.fn.has("win32") == 1
if IS_WINDOWS then
	vim.opt.fsync = false
	-- Disable file watching for Windows system directories that cause EPERM errors
	vim.g.loaded_netrwPlugin = 1
	vim.g.loaded_netrw = 1
end

-- LSP Performance optimizations
vim.opt.updatetime = 250  -- Reduce update time for better LSP experience
vim.opt.timeoutlen = 300  -- Faster which-key popup
vim.opt.completeopt = { "menu", "menuone", "noselect" }  -- Better completion experience

-- Center screen after half-page movements
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up and center" })

-- Global Copilot toggle keybinding (works whether plugin is loaded or not)
vim.keymap.set("n", "<F8>", function()
	local state = require("core.state")
	state.toggle_copilot()
end, { noremap = true, silent = true, desc = "Toggle Copilot" })