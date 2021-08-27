require"nvim-treesitter.configs".setup(
  {
    ensure_installed = {
      "css",
      "dockerfile",
      "elm",
      "fish",
      "go",
      "gomod",
      "html",
      "javascript",
      "json",
      "lua",
      "python",
      "regex",
      "ruby",
      "rust",
      "scss",
      "toml",
      "tsx",
      "typescript",
      "yaml",
    },
    highlight = {enable = true, disable = {}},
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<leader>is",
        node_incremental = "+",
        scope_incremental = "w",
        node_decremental = "-",
      },
    },
    indent = {enable = true},
  }
)
