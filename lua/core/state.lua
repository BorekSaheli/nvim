local M = {}

-- Simple global diagnostics state with persistence
local diagnostics_file = vim.fn.stdpath("data") .. "/diagnostics_enabled"

-- Load saved state or default to true
local function load_diagnostics_state()
	local file = io.open(diagnostics_file, "r")
	if file then
		local content = file:read("*a")
		file:close()
		return content:match("1") ~= nil
	end
	return true -- Default enabled
end

-- Save diagnostics state
local function save_diagnostics_state(enabled)
	local file = io.open(diagnostics_file, "w")
	if file then
		file:write(enabled and "1" or "0")
		file:close()
	end
end

-- Global diagnostics state
_G.DIAGNOSTICS_ENABLED = load_diagnostics_state()

-- Simple diagnostics toggle function
function M.toggle_diagnostics()
	_G.DIAGNOSTICS_ENABLED = not _G.DIAGNOSTICS_ENABLED
	save_diagnostics_state(_G.DIAGNOSTICS_ENABLED)
	
	-- Apply the toggle immediately
	if _G.DIAGNOSTICS_ENABLED then
		vim.diagnostic.config({
			virtual_text = {
				enabled = true,
				source = "always",
				prefix = "●",
			},
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})
	else
		vim.diagnostic.config({
			virtual_text = false,
			signs = true,
			underline = false,
			update_in_insert = false,
		})
	end
	
	return _G.DIAGNOSTICS_ENABLED
end

-- Initialize diagnostics on startup
vim.defer_fn(function()
	if _G.DIAGNOSTICS_ENABLED then
		vim.diagnostic.config({
			virtual_text = {
				enabled = true,
				source = "always",
				prefix = "●",
			},
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})
	else
		vim.diagnostic.config({
			virtual_text = false,
			signs = true,
			underline = false,
			update_in_insert = false,
		})
	end
end, 100)

-- Function to create a toggleable state with persistence (for other toggles)
function M.create_toggle(name, default_state)
	local file_path = vim.fn.stdpath("data") .. "/" .. name .. "_state"

	local state = default_state

	-- Load the saved state
	local file = io.open(file_path, "r")
	if file then
		local content = file:read("*a")
		file:close()
		state = (content == "1")
	end

	-- Function to save the current state
	local function save()
		local f = io.open(file_path, "w")
		if f then
			f:write(state and "1" or "0")
			f:close()
		end
	end

	-- Return a table with the state and toggle function
	return {
		is_enabled = function() return state end,
		toggle = function()
			state = not state
			save()
			return state
		end,
		set_initial_state = function(enable_cmd, disable_cmd)
			vim.defer_fn(function()
				if state then
					vim.cmd(enable_cmd)
				else
					vim.cmd(disable_cmd)
				end
			end, 100)
		end,
	}
end

-- Simple global completion popup state with persistence
local completion_file = vim.fn.stdpath("data") .. "/completion_enabled"

-- Load saved state or default to true
local function load_completion_state()
	local file = io.open(completion_file, "r")
	if file then
		local content = file:read("*a")
		file:close()
		return content:match("1") ~= nil
	end
	return true -- Default enabled
end

-- Save completion state
local function save_completion_state(enabled)
	local file = io.open(completion_file, "w")
	if file then
		file:write(enabled and "1" or "0")
		file:close()
	end
end

-- Global completion state
_G.COMPLETION_ENABLED = load_completion_state()

-- Simple completion toggle function
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
	
	return _G.COMPLETION_ENABLED
end

-- Simple global copilot state with persistence
local copilot_file = vim.fn.stdpath("data") .. "/copilot_enabled"

-- Load saved state or default to true
local function load_copilot_state()
	local file = io.open(copilot_file, "r")
	if file then
		local content = file:read("*a")
		file:close()
		return content:match("1") ~= nil
	end
	return true -- Default enabled
end

-- Save copilot state
local function save_copilot_state(enabled)
	local file = io.open(copilot_file, "w")
	if file then
		file:write(enabled and "1" or "0")
		file:close()
	end
end

-- Global copilot state
_G.COPILOT_ENABLED = load_copilot_state()

-- Simple copilot toggle function
function M.toggle_copilot()
	_G.COPILOT_ENABLED = not _G.COPILOT_ENABLED
	save_copilot_state(_G.COPILOT_ENABLED)
	
	-- Apply the toggle immediately
	if _G.COPILOT_ENABLED then
		vim.cmd("Copilot enable")
	else
		vim.cmd("Copilot disable")
	end
	
	return _G.COPILOT_ENABLED
end

-- Initialize copilot on startup
vim.defer_fn(function()
	if _G.COPILOT_ENABLED then
		vim.cmd("Copilot enable")
	else
		vim.cmd("Copilot disable")
	end
end, 300)

return M