return {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
        local null_ls = require('null-ls')

        null_ls.setup({
            sources = {
                -- Formatting sources
                null_ls.builtins.formatting.ruff,
                -- Diagnostics source for mypy
                null_ls.builtins.diagnostics.mypy.with({
                    extra_args = {
                        "--ignore-missing-imports",
                        "--disallow-untyped-defs",
                        "--disallow-incomplete-defs"
                    },
                }),
            },
        })

        -- Keymap for formatting code
        vim.keymap.set('n', '<leader>gf', function() vim.lsp.buf.format() end, { desc = "Format Code" })
    end,
}