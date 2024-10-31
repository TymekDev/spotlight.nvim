local command = require("spotlight.command")
local config = require("spotlight.config")
local M = {}
local ns = vim.api.nvim_create_namespace("spotlight.nvim")
---@type table<integer, any>
local buffers = {}

---@param bufnr integer
---@param line_start integer 1-indexed
---@param line_end integer 1-indexed
---@param cfg spotlight.Config
local spotlight_lines = function(bufnr, line_start, line_end, cfg)
  vim.api.nvim_buf_set_extmark(bufnr, ns, line_start - 1, 0, {
    end_row = line_end - 1,
    line_hl_group = cfg.hl_group,
    invalidate = true,
  })
  buffers[bufnr] = true
end

---@param bufnr integer
---@param line_start integer 1-indexed
---@param line_end integer 1-indexed
local spotlight_clear = function(bufnr, line_start, line_end)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, line_start - 1, line_end)
end

---@param cfg? spotlight.ConfigPartial
M.setup = function(cfg)
  config.set(cfg)

  vim.api.nvim_create_user_command(
    "Spotlight",
    ---@param tbl { line1: number, line2: number, fargs: string[] }
    function(tbl)
      local bufnr = vim.api.nvim_get_current_buf()
      local cfg = command.fargs_to_config(tbl.fargs) ---@diagnostic disable-line: redefined-local
      spotlight_lines(bufnr, tbl.line1, tbl.line2, cfg)
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
    ---@param tbl { line1: number, line2: number, args: string }
    function(tbl)
      if tbl.args == "global" then
        for bufnr in vim.iter(buffers) do
          spotlight_clear(bufnr, 1, vim.api.nvim_buf_line_count(bufnr))
          buffers[bufnr] = nil
        end
        return
      end

      local bufnr = vim.api.nvim_get_current_buf()
      spotlight_clear(bufnr, tbl.line1, tbl.line2)
    end,
    {
      desc = "Remove a range of lines from the spotlight (via spotlight.nvim)",
      range = true,
      nargs = "?",
      complete = function()
        return { "global", "buffer" }
      end,
    }
  )
end

return M
