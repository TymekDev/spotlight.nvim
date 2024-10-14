# spotlight.nvim

## Setup

### [lazy.nvim](https://github.com/folke/lazy.nvim)

spotlight.nvim has a default plugin spec—see [`lazy.lua`](./lazy.lua). This spec has a set default mappings and lazy loading enabled!

```lua
---@module "lazy"
---@type LazySpec
{
  "TymekDev/shiki.nvim"
}
```

> [!TIP]
> Annotations above are optional. Use [lazydev.nvim](https://github.com/folke/lazydev.nvim) to get completions based on them.

## Configuration

_Currently, there is nothing to configure._

## Known Issues

1. If you create a multi-line spotlight by providing a range to `Spotlight`, then
   running `SpotlightClear` on a different line than the first line of the range
   will remove the spotlight; however Neovim won't immediately update visually.

## Inspiration

I got [Highlight specific lines][] linked by [Damian][]. Then I [nerd sniped][]
myself into converting the snippet to Lua. Then into extending it. Then into
using extmarks. Then into turning the script into a plugin.

[Highlight specific lines]: https://vimtricks.com/p/highlight-specific-lines/
[Damian]: https://github.com/DSkrzypiec/
[nerd sniped]: https://xkcd.com/356/
