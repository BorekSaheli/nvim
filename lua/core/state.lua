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

-- Module-local state (not global)
local diagnostics_enabled = load_diagnostics_state()

-- Getter for external access (e.g., lualine)
function M.is_diagnostics_enabled()
	return diagnostics_enabled
end

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
	virtual_text = diagnostics_enabled and {
		source = "always",
		prefix = "●",
	} or false,
})

function M.toggle_diagnostics()
	diagnostics_enabled = not diagnostics_enabled
	save_diagnostics_state(diagnostics_enabled)

	vim.diagnostic.config({
		virtual_text = diagnostics_enabled and {
			source = "always",
			prefix = "●",
		} or false,
	})

	local status = diagnostics_enabled and "ON" or "OFF"
	vim.notify("Diagnostic virtual text: " .. status, vim.log.levels.INFO)

	-- Force lualine to refresh immediately
	pcall(require("lualine").refresh)

	return diagnostics_enabled
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

-- Module-local state (not global)
local semantic_tokens_enabled = load_semantic_tokens_state()

-- Getter for external access
function M.is_semantic_tokens_enabled()
	return semantic_tokens_enabled
end

function M.toggle_semantic_tokens()
	semantic_tokens_enabled = not semantic_tokens_enabled
	save_semantic_tokens_state(semantic_tokens_enabled)

	local current_buf = vim.api.nvim_get_current_buf()

	-- Toggle semantic tokens for all active LSP clients
	for _, client in ipairs(vim.lsp.get_clients({ bufnr = current_buf })) do
		if client.supports_method("textDocument/semanticTokens/full") then
			if semantic_tokens_enabled then
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

	local status = semantic_tokens_enabled and "ON" or "OFF"
	vim.notify("Semantic tokens: " .. status .. " (ty only)", vim.log.levels.INFO)

	-- Force lualine to refresh immediately
	pcall(require("lualine").refresh)

	return semantic_tokens_enabled
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

-- Module-local state (not global)
local completion_enabled = load_completion_state()

-- Getter for external access
function M.is_completion_enabled()
	return completion_enabled
end

function M.toggle_completion()
	completion_enabled = not completion_enabled
	save_completion_state(completion_enabled)

	-- Close any open completion menu if disabling
	if not completion_enabled then
		local ok, cmp = pcall(require, "cmp")
		if ok and cmp.visible() then
			cmp.close()
		end
	end

	local status = completion_enabled and "ON" or "OFF"
	vim.notify("Completion: " .. status, vim.log.levels.INFO)

	-- Force lualine to refresh immediately
	pcall(require("lualine").refresh)

	return completion_enabled
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

-- Module-local state (not global)
local copilot_enabled = load_copilot_state()

-- Getter for external access
function M.is_copilot_enabled()
	return copilot_enabled
end

local function apply_copilot_state(enabled)
	pcall(function()
		vim.cmd(enabled and "Copilot enable" or "Copilot disable")
	end)
end

function M.toggle_copilot()
	copilot_enabled = not copilot_enabled
	save_copilot_state(copilot_enabled)
	apply_copilot_state(copilot_enabled)

	local status = copilot_enabled and "ON" or "OFF"
	vim.notify("Copilot: " .. status, vim.log.levels.INFO)

	-- Force lualine to refresh immediately
	pcall(require("lualine").refresh)

	return copilot_enabled
end

-- Initialize copilot when it loads
vim.api.nvim_create_autocmd("User", {
	pattern = "CopilotReady",
	once = true,
	callback = function()
		apply_copilot_state(copilot_enabled)
	end,
})

return M