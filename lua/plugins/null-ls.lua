return {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
        local null_ls = require('null-ls')

        null_ls.setup({
            sources = {
                -- Formatting sources
                null_ls.builtins.formatting.ruff,


                -- Optionally, keep Ruff for linting if needed
                null_ls.builtins.diagnostics.ruff,

                -- Diagnostics source for mypy
                null_ls.builtins.diagnostics.mypy.with({
                    -- extra_args = { "--ignore-missing-imports" },
                }),
            },
            -- Optional: Enable debug for troubleshooting
            -- debug = true,
        })

        -- Keymap for formatting code
        vim.keymap.set('n', '<leader>gf', function()
            vim.lsp.buf.format({ async = true })  -- Ensure formatting is asynchronous
        end, { desc = "Format Code" })
    end,
}
