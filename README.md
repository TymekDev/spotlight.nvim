# spotlight.nvim

Don't lose the audience when screen sharing—make things stand out by putting them in _the spotlight_.

## ✨ Demo

https://github.com/user-attachments/assets/cadc20d1-17fd-4a4b-b6b3-a5e0edb5dd52

## 🛠️ Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

spotlight.nvim has a default plugin spec—see [`lazy.lua`](./lazy.lua). This spec
has a set default mappings and lazy loading enabled!

```lua
---@module "lazy"
---@type LazySpec
{
  "TymekDev/spotlight.nvim"
  ---@module "spotlight"
  ---@type spotlight.ConfigPartial
  opts = {},
}
```

> [!TIP]
> Annotations above are optional. Use [lazydev.nvim][] to get completions based
> on them.

[lazydev.nvim]: https://github.com/folke/lazydev.nvim

## ⚙️ Configuration

All configurable settings with their defaults:

```lua
require("spotlight").setup({
  -- Should the spotlights have their ordinal number displayed in the sign column?
  -- Every buffer has its own counter.
  count = true,

  -- The highlight group applied to the spotlighted lines
  hl_group = "Visual",
})
```

## 🚀 Usage

### `:Spotlight`

Put a range of lines in the spotlight! ✨

- `:Spotlight` - puts the current line
- `:<range>Spotlight` - puts the provided range as one
- `:Spotlight count=false hl_group=SpellBad` - overrides the config

### `:SpotlightClear`

Remove a range of lines, a buffer, or everything from the spotlight. ♻️

- `:SpotlightClear` - clears everything overlapping with the current line
- `:<range>SpotlightClear` - clears everything overlapping with the provided range
- `:Spotlight Clear buffer` - clears the entire buffer and resets the counter
- `:Spotlight Clear global` - clears every buffer and resets their counters

## 💡 Inspiration

I got [Highlight specific lines][] linked by [Damian][]. Then I [nerd sniped][]
myself into converting the snippet to Lua. Then into extending it. Then into
using extmarks. Then into turning the script into a plugin. Then...

[Highlight specific lines]: https://vimtricks.com/p/highlight-specific-lines/
[Damian]: https://github.com/DSkrzypiec/
[nerd sniped]: https://xkcd.com/356/
