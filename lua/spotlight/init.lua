local command = require("spotlight.command")
local config = require("spotlight.config")
local M = {}
local ns = vim.api.nvim_create_namespace("spotlight.nvim")

---@param line_start integer 1-indexed
---@param line_end integer 1-indexed
---@param cfg spotlight.Config
local spotlight_lines = function(line_start, line_end, cfg)
  vim.api.nvim_buf_set_extmark(0, ns, line_start - 1, 0, {
    end_row = line_end - 1,
    line_hl_group = cfg.hl_group,
  })
end

---@param line_start integer 1-indexed
---@param line_end integer 1-indexed
local spotlight_clear = function(line_start, line_end)
  vim.api.nvim_buf_clear_namespace(0, ns, line_start - 1, line_end)
end

---@param cfg? spotlight.ConfigPartial
M.setup = function(cfg)
  config.set(cfg)

  vim.api.nvim_create_user_command(
    "Spotlight",
    ---@param tbl { line1: number, line2: number, fargs: string[] }
    function(tbl)
      local cfg = command.fargs_to_config(tbl.fargs) ---@diagnostic disable-line: redefined-local
      spotlight_lines(tbl.line1, tbl.line2, cfg)
    end,
    {
      desc = "Spotlight a range of lines (via spotlight.nvim)",
      range = true,
      nargs = "*",
      ---@param word string "the leading portion of the argument currently being completed on"
      complete = function(word)
        if word == "hl_group=" then
          return vim.tbl_keys(vim.api.nvim_get_hl(0, {}))
        end
        return vim.tbl_keys(config.default())
      end,
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
