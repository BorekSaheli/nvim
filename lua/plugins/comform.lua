local function ensure_installed(packages)
	local mason_registry = require("mason-registry")
	for _, package in ipairs(packages) do
		local p = mason_registry.get_package(package)
		if not p:is_installed() then
			p:install()
		end
	end
end

return {
	"stevearc/conform.nvim",
	dependencies = { "williamboman/mason.nvim" },
	event = { "BufWritePre" },

	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { --[[ "ruff_fix", ]]
				"ruff_format",
				"ruff_organize_imports",
			},
		},
	},
	config = function(_, opts)
		ensure_installed({ "stylua", "ruff" })
		require("conform").setup(opts)
	end,
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>bf",
			function()
				require("conform").format({ async = true })
			end,
			mode = { "n", "v" },
			desc = "[f]ormat",
		},
	},
}
