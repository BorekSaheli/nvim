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

--[[
Run the current file with an appropriate interpreter.

This uses `vim.fn.jobstart` to spawn a background job based on the buffer's
`filetype`. Output is echoed to the command line. Add more filetypes to the
`cmd_by_ft` table as needed.
--]]
local function run_current_file()
        local filetype = vim.bo.filetype
        local file = vim.fn.expand("%")

        local cmd_by_ft = {
                python = { "python", file },
                lua = { "lua", file },
                javascript = { "node", file },
                typescript = { "node", file },
                sh = { "bash", file },
        }

        local cmd = cmd_by_ft[filetype]
        if not cmd then
                vim.notify("No runner configured for filetype: " .. filetype, vim.log.levels.ERROR)
                return
        end

        vim.fn.jobstart(cmd, {
                stdout_buffered = true,
                on_stdout = function(_, data)
                        if data then
                                vim.api.nvim_echo({ { table.concat(data, "\n") } }, false, {})
                        end
                end,
                on_stderr = function(_, data)
                        if data then
                                vim.api.nvim_echo({ { table.concat(data, "\n"), "ErrorMsg" } }, false, {})
                        end
                end,
        })
end

-- Mapping to run the current file using `run_current_file()`
vim.keymap.set("n", "<leader>r", run_current_file, { desc = "Run current file" })

-- column options
vim.opt.signcolumn = "yes"

-- Disable Ctrl+Z motion
vim.opt.backup = false -- Prevents creating a backup file
vim.keymap.set("n", "<C-z>", "<Nop>", { desc = "Disable Ctrl+Z" }) -- Disable Ctrl+Z

-- save file on leader leader
vim.keymap.set("n", "<leader><leader>", ":w<CR>", { desc = "Save file" })

-- -- Comment/uncomment current line or selected text
-- vim.keymap.set('n', '<leader>c', '<Plug>(comment_toggle_linewise_current)', { desc = "Comment/uncomment current line" })
-- vim.keymap.set('x', '<leader>c', '<Plug>(comment_toggle_linewise_visual)', { desc = "Comment/uncomment selected text" })

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

