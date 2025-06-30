return {
	"stevearc/conform.nvim",
	dependencies = { "williamboman/mason.nvim" },
	event = { "BufWritePre" },
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_format", "ruff_organize_imports" },
		},
	},
	config = function(_, opts)
		local mason_registry = require("mason-registry")
		-- Ensure formatters are installed
		vim.defer_fn(function()
			for _, tool in ipairs({ "stylua", "ruff" }) do
				if not mason_registry.is_installed(tool) then
					vim.cmd("MasonInstall " .. tool)
				end
			end
		end, 0)
		require("conform").setup(opts)
	end,
	keys = {
		{
			"<leader>bf",
			function()
				require("conform").format({ async = true })
			end,
			mode = { "n", "v" },
			desc = "Format Buffer",
		},
	},
}