return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	config = function()
		require("nvim-autopairs").setup({
			check_ts = true,
			ts_config = {
				lua = { "string" },
				javascript = { "template_string" },
			},
		})

		-- Integration with nvim-cmp
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp_status, cmp = pcall(require, "cmp")
		if cmp_status then
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end
	end,
}
