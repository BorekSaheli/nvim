return {
    'nvimtools/none-ls.nvim',
    config = function()
        local null_ls = require('null-ls')

        null_ls.setup({
            sources = {
                -- Formatting sources
                null_ls.builtins.formatting.black,
                null_ls.builtins.formatting.isort,

                -- Diagnostics source for mypy
                null_ls.builtins.diagnostics.mypy.with({
                    extra_args = { "--ignore-missing-imports" },
                }),
            },
            -- Optional: You can enable debug for troubleshooting
            -- debug = true,
        })

        -- Keymap for formatting code
        vim.keymap.set('n', '<leader>gf', function() vim.lsp.buf.format() end, { desc = "Format Code" })
    end,
}