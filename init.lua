require("core.options")
require("core.lazy")

-- Windows file watching fix
if vim.fn.has("win32") == 1 then
	-- Disable problematic file watching on Windows
	vim.opt.backup = false
	vim.opt.writebackup = false
	vim.opt.swapfile = false
end
