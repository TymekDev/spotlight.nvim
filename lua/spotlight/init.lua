local command = require("spotlight.command")
local config = require("spotlight.config")
local M = {}
local ns = vim.api.nvim_create_namespace("spotlight.nvim")
---@type table<integer, integer> Maps a bufnr to its counter.
local buffers_counts = vim.defaulttable(function()
  return 0
end)

---@param bufnr integer
---@param line_start integer 1-indexed
---@param line_end integer 1-indexed
---@param cfg spotlight.Config
local spotlight_lines = function(bufnr, line_start, line_end, cfg)
  ---@type string?
  local sign_text
  local count = buffers_counts[bufnr]
  if cfg.count then
    count = count + 1
    sign_text = string.format(math.min(count, 99)) -- only 2 characters allowed
  end
  buffers_counts[bufnr] = count -- even with the count disabled we need an entry in buffers_counts

  vim.api.nvim_buf_set_extmark(bufnr, ns, line_start - 1, 0, {
    end_row = line_end - 1,
    line_hl_group = cfg.hl_group,
    sign_text = sign_text,
    invalidate = true,
  })
end

---@param bufnr integer
---@param line_start integer 1-indexed
---@param line_end integer 1-indexed
local spotlight_clear = function(bufnr, line_start, line_end)
  local extmarks = vim.api.nvim_buf_get_extmarks(
    bufnr,
    ns,
    { line_start - 1, 0 },
    { line_end - 1, 0 },
    { overlap = true }
  )

  for extmark in vim.iter(extmarks) do
    vim.api.nvim_buf_del_extmark(bufnr, ns, extmark[1])
  end

  if #vim.api.nvim_buf_get_extmarks(bufnr, ns, 0, -1, { limit = 1 }) == 0 then
    buffers_counts[bufnr] = nil
  end
end

---@param bufnr integer
local spotlight_clear_buffer = function(bufnr)
  spotlight_clear(bufnr, 1, vim.api.nvim_buf_line_count(bufnr))
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
        if word == "count=" then
          return { "false", "true" }
        end

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
        for bufnr, _ in pairs(buffers_counts) do
          spotlight_clear_buffer(bufnr)
        end
        return
      end

      if tbl.args == "buffer" then
        spotlight_clear_buffer(vim.api.nvim_get_current_buf())
        return
      end

      spotlight_clear(vim.api.nvim_get_current_buf(), tbl.line1, tbl.line2)
    end,
    {
      desc = "Remove a range of lines, a buffer, or everything from the spotlight (via spotlight.nvim)",
      range = true,
      nargs = "?",
      complete = function()
        return { "global", "buffer" }
      end,
    }
  )
end

return M
