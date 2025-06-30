return {
	"mfussenegger/nvim-lint",
	dependencies = { "williamboman/mason.nvim" },
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		local mason_registry = require("mason-registry")

		-- Ensure linters are installed
		vim.defer_fn(function()
			for _, tool in ipairs({ "mypy", "ruff" }) do
				if not mason_registry.is_installed(tool) then
					vim.cmd("MasonInstall " .. tool)
				end
			end
		end, 0)

		lint.linters_by_ft = {
			python = { "ruff", "mypy" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("lint_on_events", { clear = true }),
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
			desc = "Trigger Linter",
		},
	},
}