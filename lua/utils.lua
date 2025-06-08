local M = {}

---@param cmd string
---@param prefix? string
---@return string
M.cmd = function(cmd, prefix)
  return (prefix or "<cmd>") .. cmd .. "<cr>"
end

return M
