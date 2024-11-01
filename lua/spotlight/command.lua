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

local completions = setmetatable({
  ---@return string[]
  count = function()
    return { "false", "true" }
  end,
  ---@return string[]
  hl_group = function()
    return vim.tbl_keys(vim.api.nvim_get_hl(0, {}))
  end,
}, {
  -- Default to table's keys
  __index = function(t, _)
    return function()
      return vim.tbl_keys(t)
    end
  end,
})

---@param word string "the leading portion of the argument currently being completed on"
---@return string[]
M.complete = function(word)
  word = string.sub(word, 1, -2) -- trim a potential trailing "="
  return completions[word]()
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
