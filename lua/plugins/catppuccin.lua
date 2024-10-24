return {
  -- https://github.com/catppuccin/nvim/discussions/448#discussioncomment-5560230
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    opts = {
      transparent_background = true,
      custom_highlights = function(colors)
        local u = require("catppuccin.utils.colors")
        return {
          CursorLine = {
            bg = u.vary_color(
              { latte = u.lighten(colors.mantle, 0.70, colors.base) },
              u.darken(colors.surface0, 0.64, colors.base)
            ),
          },
        }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
