return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "jedi_language_server",
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
	local lspconfig = require('lspconfig')

lspconfig.jedi_language_server.setup({capabilities = capabilities})
      lspconfig.lua_ls.setup({capabilities = capabilities})

vim.keymap.set(('n'),'K',vim.lsp.buf.hover,{desc="Show Hover"})
      vim.keymap.set(('n'),'gd',vim.lsp.buf.definition,{desc="Go to Definition"})
      vim.keymap.set({'n','v'},'<leader>ca',vim.lsp.buf.code_action,{desc="Code Action"})
       end,
  }
}
