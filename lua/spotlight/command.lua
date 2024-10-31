local config = require("spotlight.config")
local M = {}

---@param x string
---@return string|boolean
local parse_value = function(x)
  if x == "true" then
    return true
  end
  if x == "false" then
    return false
  end
  return x
end

---Override `config.current()` with values parsed from `fargs`.
---
--- - Assumes that `fargs` has a `key=value` format.
--- - If `value` is either "true" or "false", then converts it to a boolean.
---@param fargs string[]
---@return spotlight.Config
M.fargs_to_config = function(fargs)
  local result = config.current()

  for arg in vim.iter(fargs) do
    local iter = vim.iter(vim.gsplit(arg, "="))
    local key = iter()
    if result[key] ~= nil then
      local value = iter:join("=")
      result[key] = parse_value(value)
    end
  end

  return result
end

return M
