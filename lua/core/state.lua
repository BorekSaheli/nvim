local M = {}

-- Function to create a toggleable state with persistence
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

-- Create toggles for Copilot, Diagnostics, and Completion Borders
M.copilot = M.create_toggle("copilot", true)
M.diagnostics = M.create_toggle("diagnostics", true)
M.completion_borders = M.create_toggle("completion_borders", true)

return M
