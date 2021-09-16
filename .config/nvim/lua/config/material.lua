local colors = require("material.colors")
local search_color_settings = {bg = colors.accent, fg = colors.bg}

require("material").setup(
  {
    custom_highlights = {
      Search = search_color_settings,
      IncSearch = search_color_settings,
    },
  }
)

vim.g.material_style = "palenight"
vim.cmd("colorscheme material")
