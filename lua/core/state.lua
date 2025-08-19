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

-- Diagnostics ---------------------------------------------------------------
local diagnostics = M.create_toggle("diagnostics", true)
_G.DIAGNOSTICS_ENABLED = diagnostics.is_enabled()

local function enable_diagnostics()
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
  vim.diagnostic.show()
end

local function disable_diagnostics()
  vim.diagnostic.config({
    virtual_text = false,
    signs = false,
    underline = false,
    update_in_insert = false,
  })
  vim.diagnostic.hide()
end

function M.toggle_diagnostics()
  local enabled = diagnostics.toggle()
  _G.DIAGNOSTICS_ENABLED = enabled
  if enabled then
    enable_diagnostics()
  else
    disable_diagnostics()
  end
  return enabled
end

M.enable_diagnostics = enable_diagnostics
M.disable_diagnostics = disable_diagnostics

diagnostics.set_initial_state(
  "lua require('core.state').enable_diagnostics()",
  "lua require('core.state').disable_diagnostics()"
)

-- Completion ---------------------------------------------------------------
local completion = M.create_toggle("completion", true)
_G.COMPLETION_ENABLED = completion.is_enabled()

function M.toggle_completion()
  local enabled = completion.toggle()
  _G.COMPLETION_ENABLED = enabled
  if not enabled then
    local ok, cmp = pcall(require, "cmp")
    if ok and cmp.visible() then
      cmp.close()
    end
  end
  return enabled
end

-- Copilot ------------------------------------------------------------------
local copilot = M.create_toggle("copilot", true)
_G.COPILOT_ENABLED = copilot.is_enabled()

local function enable_copilot()
  vim.cmd("Copilot enable")
end

local function disable_copilot()
  vim.cmd("Copilot disable")
end

function M.toggle_copilot()
  local enabled = copilot.toggle()
  _G.COPILOT_ENABLED = enabled
  if enabled then
    enable_copilot()
  else
    disable_copilot()
  end
  return enabled
end

copilot.set_initial_state("Copilot enable", "Copilot disable")

return M

