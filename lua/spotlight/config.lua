local M = {}

---@type spotlight.Config
local default = {
  -- The highlight group applied to the spotlighted lines
  hl_group = "Visual",
}

---@type spotlight.Config
local current = vim.deepcopy(default)

---@return spotlight.Config
M.current = function()
  return vim.deepcopy(current)
end

---@return spotlight.Config
M.default = function()
  return vim.deepcopy(default)
end

---Update the spotlight.nvim's config. Fills missing fields with defaults.
---
---Use without the argument (`set()`) to reset the config to defaults.
---@param cfg? spotlight.ConfigPartial
M.set = function(cfg)
  current = vim.tbl_deep_extend("force", M.default(), cfg or {})
  return M.current()
end

return M
