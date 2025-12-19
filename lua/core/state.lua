local M = {}

-- ============================================================================
-- GENERIC TOGGLE STATE FACTORY
-- ============================================================================

local function create_toggle_state(name, default_value, apply_fn)
	local state_file = vim.fn.stdpath("data") .. "/" .. name
	local enabled = default_value

	-- Load state from file
	local function load_state()
		local file = io.open(state_file, "r")
		if file then
			local content = file:read("*a")
			file:close()
			return content:match("1") ~= nil
		end
		return default_value
	end

	-- Save state to file
	local function save_state(value)
		local file = io.open(state_file, "w")
		if file then
			file:write(value and "1" or "0")
			file:close()
		end
	end

	-- Initialize
	enabled = load_state()

	-- Return state manager
	return {
		is_enabled = function()
			return enabled
		end,
		toggle = function()
			enabled = not enabled
			save_state(enabled)
			if apply_fn then
				apply_fn(enabled)
			end
			return enabled
		end,
		get_value = function()
			return enabled
		end,
	}
end

-- Helper to refresh lualine
local function refresh_lualine()
	pcall(require("lualine").refresh)
end

-- ============================================================================
-- DIAGNOSTICS TOGGLE
-- ============================================================================

local diagnostics_state = create_toggle_state("diagnostics_enabled", true, function(enabled)
	vim.diagnostic.config({
		virtual_text = enabled and {
			source = "always",
			prefix = "●",
		} or false,
	})
	vim.notify("Diagnostic virtual text: " .. (enabled and "ON" or "OFF"), vim.log.levels.INFO)
	refresh_lualine()
end)

-- Base diagnostic configuration
vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "E",
			[vim.diagnostic.severity.WARN] = "W",
			[vim.diagnostic.severity.HINT] = "H",
			[vim.diagnostic.severity.INFO] = "I",
		},
	},
	float = {
		focusable = false,
		style = "minimal",
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	virtual_text = diagnostics_state.is_enabled() and {
		source = "always",
		prefix = "●",
	} or false,
})

M.is_diagnostics_enabled = diagnostics_state.is_enabled
M.toggle_diagnostics = diagnostics_state.toggle

-- ============================================================================
-- SEMANTIC TOKENS TOGGLE
-- ============================================================================

local semantic_tokens_state = create_toggle_state("semantic_tokens_enabled", true, function(enabled)
	local current_buf = vim.api.nvim_get_current_buf()
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = current_buf })) do
		if client.supports_method("textDocument/semanticTokens/full") then
			if enabled then
				pcall(vim.lsp.semantic_tokens.start, current_buf, client.id)
			else
				pcall(vim.lsp.semantic_tokens.stop, current_buf, client.id)
			end
		end
	end
	vim.cmd("nohlsearch")
	vim.cmd("redraw!")
	vim.notify("Semantic tokens: " .. (enabled and "ON" or "OFF") .. " (ty only)", vim.log.levels.INFO)
	refresh_lualine()
end)

M.is_semantic_tokens_enabled = semantic_tokens_state.is_enabled
M.toggle_semantic_tokens = semantic_tokens_state.toggle

-- ============================================================================
-- COMPLETION TOGGLE
-- ============================================================================

local completion_state = create_toggle_state("completion_enabled", true, function(enabled)
	if not enabled then
		local ok, cmp = pcall(require, "cmp")
		if ok and cmp.visible() then
			cmp.close()
		end
	end
	vim.notify("Completion: " .. (enabled and "ON" or "OFF"), vim.log.levels.INFO)
	refresh_lualine()
end)

M.is_completion_enabled = completion_state.is_enabled
M.toggle_completion = completion_state.toggle

-- ============================================================================
-- COPILOT TOGGLE
-- ============================================================================

local function apply_copilot_state(enabled)
	pcall(function()
		vim.cmd(enabled and "Copilot enable" or "Copilot disable")
	end)
end

local copilot_state = create_toggle_state("copilot_enabled", true, function(enabled)
	if enabled then
		local lazy_ok, lazy = pcall(require, "lazy")
		if lazy_ok then
			local copilot_loaded = vim.fn.exists(":Copilot") == 2
			if not copilot_loaded then
				vim.notify("Loading Copilot...", vim.log.levels.INFO)
				local load_ok = pcall(lazy.load, { plugins = { "copilot.vim" } })
				if load_ok then
					vim.defer_fn(function()
						if vim.fn.exists(":Copilot") == 2 then
							apply_copilot_state(true)
							vim.notify("Copilot: ON", vim.log.levels.INFO)
						else
							vim.notify("Copilot failed to load - restart required", vim.log.levels.ERROR)
						end
						refresh_lualine()
					end, 1000)
					return -- Don't notify or refresh yet
				else
					vim.notify("Copilot: ON (restart required)", vim.log.levels.WARN)
				end
			else
				vim.defer_fn(function()
					apply_copilot_state(true)
					vim.notify("Copilot: ON", vim.log.levels.INFO)
					refresh_lualine()
				end, 100)
				return -- Don't notify or refresh yet
			end
		else
			vim.notify("Copilot: ON (restart required)", vim.log.levels.WARN)
		end
	else
		apply_copilot_state(false)
		vim.notify("Copilot: OFF", vim.log.levels.INFO)
	end
	refresh_lualine()
end)

M.is_copilot_enabled = copilot_state.is_enabled
M.toggle_copilot = copilot_state.toggle

return M
