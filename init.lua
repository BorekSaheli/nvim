require("core.options")
require("core.lazy")

-- Windows file watching fix
if vim.fn.has("win32") == 1 then
	-- Disable problematic file watching on Windows
	vim.opt.backup = false
	vim.opt.writebackup = false
	vim.opt.swapfile = false
end

-- Neovide configuration
if vim.g.neovide then
	vim.g.neovide_refresh_rate = 120
	vim.g.neovide_refresh_rate_idle = 120
	vim.g.neovide_opacity = 0.8
	vim.g.neovide_normal_opacity = 0.8
	vim.g.neovide_window_floating_opacity = 0.8

	-- Allow clipboard copy paste in neovim
	vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true})
	vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true})
	vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true})
	vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true})
end
