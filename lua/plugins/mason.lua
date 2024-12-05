return {{
    "williamboman/mason.nvim",
    config = function()
        require("mason").setup()
    end
}, {
    "williamboman/mason-lspconfig.nvim",
    config = function()
        require("mason-lspconfig").setup({
            ensure_installed = {"lua_ls", "pyright"}
        })
    end
}, {
    "neovim/nvim-lspconfig",
    config = function()
        local capabilities = require('cmp_nvim_lsp').default_capabilities()
        local lspconfig = require('lspconfig')

        -- Set verbose logging
        vim.lsp.set_log_level("debug")

        lspconfig.pyright.setup({
            capabilities = capabilities
        })

        -- lspconfig.ruff.setup({
        --     capabilities = capabilities
        -- })

        lspconfig.lua_ls.setup({
            capabilities = capabilities
        })

        vim.diagnostic.config({
            virtual_text = {
                prefix = '●', -- Could be '●', '▎', 'x'
            },
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
        })

        local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end

        vim.keymap.set('n', 'K', vim.lsp.buf.hover, {
            desc = "Show Hover"
        })
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {
            desc = "Go to Definition"
        })
        -- vim.keymap.set({'n', 'v'}, '<leader>ca', vim.lsp.buf.code_action, {
        --     desc = "Code Action"
        -- })
    end
}}
