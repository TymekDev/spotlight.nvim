local M = {}
local ns = vim.api.nvim_create_namespace("spotlight.nvim")

---@type spotlight.Config
local config_default = {
  -- The highlight group applied to the spotlighted lines
  hl_group = "Visual",
}

---@param line_start integer 1-indexed
---@param line_end integer 1-indexed
---@param config spotlight.Config
local spotlight_lines = function(line_start, line_end, config)
  vim.api.nvim_buf_set_extmark(0, ns, line_start - 1, 0, {
    end_row = line_end - 1,
    line_hl_group = config.hl_group,
  })
end

---@param line_start integer 1-indexed
---@param line_end integer 1-indexed
local spotlight_clear = function(line_start, line_end)
  vim.api.nvim_buf_clear_namespace(0, ns, line_start - 1, line_end)
end

---@param config_partial? spotlight.ConfigPartial
M.setup = function(config_partial)
  local config = vim.tbl_deep_extend("force", config_default, config_partial or {})

  vim.api.nvim_create_user_command(
    "Spotlight",
    ---@param tbl { line1: number, line2: number }
    function(tbl)
      spotlight_lines(tbl.line1, tbl.line2, config)
    end,
    {
      desc = "Spotlight a range of lines (via spotlight.nvim)",
      range = true,
    }
  )

  vim.api.nvim_create_user_command(
    "SpotlightClear",
    ---@param tbl { line1: number, line2: number }
    function(tbl)
      spotlight_clear(tbl.line1, tbl.line2)
    end,
    {
      desc = "Remove a range of lines from the spotlight (via spotlight.nvim)",
      range = true,
    }
  )
end

return M
