---@module "lazy"
---@type LazySpec
return {
  "TymekDev/spotlight.nvim",
  cmd = { "Spotlight", "SpotlightClear" },
  keys = {
    { mode = { "n", "v" }, "<Leader>sl", ":Spotlight<CR>" },
    { mode = { "n", "v" }, "<Leader>sc", ":SpotlightClear<CR>" },
    { mode = { "n", "v" }, "<Leader>sC", "<Cmd>%SpotlightClear<CR>" },
  },
  ---@module "spotlight"
  ---@type spotlight.ConfigPartial
  opts = {},
}
