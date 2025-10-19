local M = {}

-- ============================================================================
-- DIAGNOSTICS TOGGLE (virtual text only - signs always visible)
-- ============================================================================
local diagnostics_file = vim.fn.stdpath("data") .. "/diagnostics_enabled"

local function load_diagnostics_state()
	local file = io.open(diagnostics_file, "r")
	if file then
		local content = file:read("*a")
		file:close()
		return content:match("1") ~= nil
	end
	return true -- Default: virtual text enabled
end

local function save_diagnostics_state(enabled)
	local file = io.open(diagnostics_file, "w")
	if file then
		file:write(enabled and "1" or "0")
		file:close()
	end
end

_G.DIAGNOSTICS_ENABLED = load_diagnostics_state()

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
	virtual_text = _G.DIAGNOSTICS_ENABLED and {
		source = "always",
		prefix = "●",
	} or false,
})

function M.toggle_diagnostics()
	_G.DIAGNOSTICS_ENABLED = not _G.DIAGNOSTICS_ENABLED
	save_diagnostics_state(_G.DIAGNOSTICS_ENABLED)

	vim.diagnostic.config({
		virtual_text = _G.DIAGNOSTICS_ENABLED and {
			source = "always",
			prefix = "●",
		} or false,
	})

	local status = _G.DIAGNOSTICS_ENABLED and "ON" or "OFF"
	vim.notify("Diagnostic virtual text: " .. status, vim.log.levels.INFO)

	-- Force lualine to refresh immediately
	pcall(require("lualine").refresh)

	return _G.DIAGNOSTICS_ENABLED
end

-- ============================================================================
-- SEMANTIC TOKENS TOGGLE
-- ============================================================================
local semantic_tokens_file = vim.fn.stdpath("data") .. "/semantic_tokens_enabled"

local function load_semantic_tokens_state()
	local file = io.open(semantic_tokens_file, "r")
	if file then
		local content = file:read("*a")
		file:close()
		return content:match("1") ~= nil
	end
	return true -- Default: semantic tokens enabled
end

local function save_semantic_tokens_state(enabled)
	local file = io.open(semantic_tokens_file, "w")
	if file then
		file:write(enabled and "1" or "0")
		file:close()
	end
end

_G.SEMANTIC_TOKENS_ENABLED = load_semantic_tokens_state()

function M.toggle_semantic_tokens()
	_G.SEMANTIC_TOKENS_ENABLED = not _G.SEMANTIC_TOKENS_ENABLED
	save_semantic_tokens_state(_G.SEMANTIC_TOKENS_ENABLED)

	local current_buf = vim.api.nvim_get_current_buf()

	-- Toggle semantic tokens for all active LSP clients
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = current_buf })) do
		if client.supports_method("textDocument/semanticTokens/full") then
			if _G.SEMANTIC_TOKENS_ENABLED then
				-- Enable: force a refresh
				pcall(vim.lsp.semantic_tokens.start, current_buf, client.id)
			else
				-- Disable: stop semantic tokens for this buffer
				pcall(vim.lsp.semantic_tokens.stop, current_buf, client.id)
			end
		end
	end

	-- Clear and redraw to show changes immediately
	vim.cmd("nohlsearch")
	vim.cmd("redraw!")

	local status = _G.SEMANTIC_TOKENS_ENABLED and "ON" or "OFF"
	vim.notify("Semantic tokens: " .. status .. " (ty only)", vim.log.levels.INFO)

	-- Force lualine to refresh immediately
	pcall(require("lualine").refresh)

	return _G.SEMANTIC_TOKENS_ENABLED
end

-- ============================================================================
-- COMPLETION TOGGLE
-- ============================================================================
local completion_file = vim.fn.stdpath("data") .. "/completion_enabled"

local function load_completion_state()
	local file = io.open(completion_file, "r")
	if file then
		local content = file:read("*a")
		file:close()
		return content:match("1") ~= nil
	end
	return true -- Default: completion enabled
end

local function save_completion_state(enabled)
	local file = io.open(completion_file, "w")
	if file then
		file:write(enabled and "1" or "0")
		file:close()
	end
end

_G.COMPLETION_ENABLED = load_completion_state()

function M.toggle_completion()
	_G.COMPLETION_ENABLED = not _G.COMPLETION_ENABLED
	save_completion_state(_G.COMPLETION_ENABLED)

	-- Close any open completion menu if disabling
	if not _G.COMPLETION_ENABLED then
		local ok, cmp = pcall(require, "cmp")
		if ok and cmp.visible() then
			cmp.close()
		end
	end

	local status = _G.COMPLETION_ENABLED and "ON" or "OFF"
	vim.notify("Completion: " .. status, vim.log.levels.INFO)

	-- Force lualine to refresh immediately
	pcall(require("lualine").refresh)

	return _G.COMPLETION_ENABLED
end

-- ============================================================================
-- COPILOT TOGGLE
-- ============================================================================
local copilot_file = vim.fn.stdpath("data") .. "/copilot_enabled"

local function load_copilot_state()
	local file = io.open(copilot_file, "r")
	if file then
		local content = file:read("*a")
		file:close()
		return content:match("1") ~= nil
	end
	return true -- Default: copilot enabled
end

local function save_copilot_state(enabled)
	local file = io.open(copilot_file, "w")
	if file then
		file:write(enabled and "1" or "0")
		file:close()
	end
end

_G.COPILOT_ENABLED = load_copilot_state()

local function apply_copilot_state(enabled)
	pcall(function()
		vim.cmd(enabled and "Copilot enable" or "Copilot disable")
	end)
end

function M.toggle_copilot()
	_G.COPILOT_ENABLED = not _G.COPILOT_ENABLED
	save_copilot_state(_G.COPILOT_ENABLED)
	apply_copilot_state(_G.COPILOT_ENABLED)

	local status = _G.COPILOT_ENABLED and "ON" or "OFF"
	vim.notify("Copilot: " .. status, vim.log.levels.INFO)

	-- Force lualine to refresh immediately
	pcall(require("lualine").refresh)

	return _G.COPILOT_ENABLED
end

-- Initialize copilot when it loads
vim.api.nvim_create_autocmd("User", {
	pattern = "CopilotReady",
	once = true,
	callback = function()
		apply_copilot_state(_G.COPILOT_ENABLED)
	end,
})

return M