local cmp = require("cmp")

cmp.setup(
  {
    sources = {
      {name = "nvim_lua"},
      {name = "nvim_lsp"},
      {name = "tags"},
      {name = "treesitter"},
      {name = "path"},
      {name = "buffer"},
      {name = "rg"},
      {name = "spell"},
      {name = "cmp_git"},
      {name = "emoji"},
      {name = "calc"},
    },
    experimental = {ghost_text = true},
  }
)
