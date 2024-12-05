return {
  "mfussenegger/nvim-lint",
  dependencies = { "williamboman/mason.nvim" },
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    local mason_registry = require("mason-registry")

    local function get_executable_path(pkg_name)
      local pkg = mason_registry.get_package(pkg_name)
      return pkg:get_install_path() .. "/venv/bin/" .. pkg_name
    end

    lint.linters.mypy.cmd = get_executable_path("mypy")
    lint.linters.ruff.cmd = get_executable_path("ruff")

    lint.linters_by_ft = {
      python = { "ruff", "mypy" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      group = vim.api.nvim_create_augroup("lint_on_save", { clear = true }),
      callback = function()
        lint.try_lint()
      end,
    })
  end,
  keys = {
    {
      "<leader>bl",
      function()
        require("lint").try_lint()
      end,
      desc = "[l]int",
    },
  },
}