require("core.options")
require("core.state")  -- Load state management early for diagnostics/toggles
require("core.wezterm")  -- WezTerm terminal integration
require("core.lazy")

require("core.state")    -- Load first (used by options.lua)
require("core.options")  -- Then options (uses state)
require("core.lazy")     -- Finally plugins

-- Neovide configuration
if vim.g.neovide then
	vim.g.neovide_refresh_rate = 120
	vim.g.neovide_refresh_rate_idle = 120
	vim.g.neovide_opacity = 0.8
	vim.g.neovide_normal_opacity = 0.8
	vim.g.neovide_window_floating_opacity = 0.8

	-- Allow clipboard copy paste in neovim
	vim.keymap.set('', '<D-v>', '+p<CR>', { noremap = true, silent = true})
	vim.keymap.set('!', '<D-v>', '<C-R>+', { noremap = true, silent = true})
	vim.keymap.set('t', '<D-v>', '<C-R>+', { noremap = true, silent = true})
	vim.keymap.set('v', '<D-v>', '<C-R>+', { noremap = true, silent = true})
end
