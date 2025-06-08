return {
	"mfussenegger/nvim-lint",
	dependencies = { "williamboman/mason.nvim" },
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		local mason_registry = require("mason-registry")

		local function get_executable_path(pkg_name)
			-- First try direct executable
			local direct_exec = vim.fn.exepath(pkg_name)
			if direct_exec and direct_exec ~= "" then
				return direct_exec
			end

			-- Then try mason registry
			if mason_registry.has_package(pkg_name) then
				local pkg = mason_registry.get_package(pkg_name)
				if pkg:is_installed() then
					-- Check if it's a Python package (needs venv path)
					local is_python = vim.fn.filereadable(pkg:get_install_path() .. "/venv/bin/" .. pkg_name) == 1
					if is_python then
						return pkg:get_install_path() .. "/venv/bin/" .. pkg_name
					end
					-- Return regular binary path
					return pkg:get_install_path() .. "/bin/" .. pkg_name
				end
			end

			-- Fallback to just the name
			return pkg_name
		end

		-- Make sure mypy and ruff are installed
		vim.defer_fn(function()
			if not mason_registry.is_installed("mypy") then
				vim.cmd("MasonInstall mypy")
			end
			if not mason_registry.is_installed("ruff") then
				vim.cmd("MasonInstall ruff")
			end
		end, 0)

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
