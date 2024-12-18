return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        -- Create custom highlight group for the Python icon
        vim.api.nvim_set_hl(0, 'LualinePythonIcon', { fg = '#FFD700' })  -- Using a golden yellow color

        -- Function to get virtual env
        local function get_venv()
            local venv = vim.env.VIRTUAL_ENV
            if venv then
                return string.match(venv, "([^/]+)$")
            end
            return nil
        end

        -- Function to combine filetype and venv
        local function filetype_with_venv()
            local ft = vim.bo.filetype
            local venv = get_venv()
            if venv and ft == "python" then
                return "%#LualinePythonIcon# %* venv: " .. venv .. ''
            end
            return ft
        end

        -- Function to get Copilot status
        local function copilot_status()
            local file = io.open(vim.fn.stdpath('data') .. '/copilot_state', 'r')
            if file then
                local state = file:read('*a')
                file:close()
                return state == '1' and '' or ''
            end
            return '' -- Default to enabled
        end

        local function diagnostic_status()
            local file = io.open(vim.fn.stdpath('data') .. '/diagnostic_state', 'r')
            if file then
                local state = file:read('*a')
                file:close()
                return state == '1' and 'Diag: ' or 'Diag: '  -- Diagnostic icon
            end
            return 'Diag: '  -- Default to disabled icon
        end

        require("lualine").setup({
            options = {
                theme = "auto"
            },
            sections = {
                lualine_x = {
                    'encoding',
                    'fileformat',
                    copilot_status,
                    diagnostic_status,  -- Add diagnostic status
                    filetype_with_venv
                }
            }
        })
    end
}