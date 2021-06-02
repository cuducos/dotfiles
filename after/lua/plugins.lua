local packer_exists = pcall(vim.cmd, [[ packadd packer.nvim ]])
if not packer_exists then
  local dest = string.format("%s/site/pack/packer/opt/", vim.fn.stdpath("data"))
  local repo_url = "https://github.com/wbthomason/packer.nvim"

  vim.fn.mkdir(dest, "p")

  print("Downloading packer")
  vim.fn.system(string.format("git clone %s %s", repo_url, dest .. "packer.nvim"))
  vim.cmd([[packadd packer.nvim]])
  vim.cmd("PackerSync")
  print("packer.nvim installed")
end

vim.cmd([[autocmd BufWritePost plugins.lua PackerCompile ]])

-- load plugins
return require("packer").startup(function(use)
  use {"wbthomason/packer.nvim"}

  -- colorscheme
  use {"npxbr/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}}

  -- golang
  use {
    "fatih/vim-go",
    ft = "go",
    run = "GoUpdateBinaries",
    config = function()
      vim.g.go_auto_type_info = 1
      vim.g.go_fmt_autosave = 1
      vim.g.go_fmt_command = "goimports"
      vim.g.go_highlight_extra_types = 1
      vim.g.go_highlight_fields = 1
      vim.g.go_highlight_function_calls = 1
      vim.g.go_highlight_functions = 1
      vim.g.go_highlight_operators = 1
      vim.g.go_jump_to_error = 0
    end,
  }

  -- code comments
  use {
    "b3nj5m1n/kommentary",
    config = function()
      require("kommentary.config").configure_language("default", {
        prefer_single_line_comments = true,
      })
    end,
  }

  -- search, grep
  use {
    "nvim-telescope/telescope.nvim",
    requires = {"nvim-lua/plenary.nvim", "nvim-lua/popup.nvim"},
    config = function()
      local opts = {noremap = true}
      local mappings = {
        {"n", "<leader>g", [[<Cmd>Telescope git_files<CR>]], opts},
        {"n", "<leader>G", [[<Cmd>Telescope git_status<CR>]], opts},
        {"n", "<leader>f", [[<Cmd>Telescope find_files<CR>]], opts},
        {"n", "<leader>b", [[<Cmd>Telescope buffers<CR>]], opts},
        {"n", "<leader>//", [[<Cmd>Telescope live_grep<CR>]], opts},
      }
      for _, val in pairs(mappings) do
        vim.api.nvim_set_keymap(unpack(val))
      end
    end,
  }

  -- language syntax highlight and small motions
  use {
    "nvim-treesitter/nvim-treesitter",
    run = "TSUpdate",
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = {
          "go",
          "python",
          "lua",
          "yaml",
          "json",
          "javascript",
          "bash",
          "typescript",
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
    end,
  }

  -- code formatter
  use {
    "mhartington/formatter.nvim",
    config = function()
      require("modules.formatter")
    end,
  }

  -- lsp, completion, linting and snippets
  use {"kabouzeid/nvim-lspinstall"}
  use {"rafamadriz/friendly-snippets"}
  use {
    "neovim/nvim-lspconfig",
    config = function()
      require("modules.lsp")
    end,
    requires = {
      "glepnir/lspsaga.nvim",
      "hrsh7th/nvim-compe",
      "hrsh7th/vim-vsnip",
      "hrsh7th/vim-vsnip-integ",
    },
  }

  -- bufferline tabs
  use {
    "akinsho/nvim-bufferline.lua",
    config = function()
      require("bufferline").setup({options = {numbers = "buffer_id"}})
    end,
  }
end)
