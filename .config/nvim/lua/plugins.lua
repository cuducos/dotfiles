-- install packer
local path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local repo = "https://github.com/wbthomason/packer.nvim"

if vim.fn.empty(vim.fn.glob(path)) > 0 then
  print("Installing packer.nvim…")
  vim.fn.system({"git", "clone", repo, path})
  vim.cmd("packadd packer.nvim")
  vim.cmd("PackerSync")
  print("packer.nvim installed!")
end

vim.cmd([[autocmd BufWritePost plugins.lua PackerCompile ]])

-- load plugins
local startup = function(use)
  use {"wbthomason/packer.nvim"}

  -- colorscheme
  use {
    "marko-cerovac/material.nvim",
    config = function()
      require("lua.config.material")
    end,
  }

  -- fuzzy finder
  use {
    "nvim-telescope/telescope.nvim",
    requires = {"nvim-lua/plenary.nvim", "nvim-lua/popup.nvim"},
    config = function()
      require("lua.config.telescope")
    end,
  }

  -- lsp
  use {
    "nvim-treesitter/nvim-treesitter",
    run = "TSUpdate",
    config = function()
      require("lua.config.treesitter")
    end,
  }
  use {
    "neovim/nvim-lspconfig",
    requires = {{"kabouzeid/nvim-lspinstall"}, {"glepnir/lspsaga.nvim"}},
    config = function()
      require("lua.config.lsp")
    end,
  }
  use {
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-path",
    },
    config = function()
      require("lua.config.cmp")
    end,
  }
  use {
    "mhartington/formatter.nvim",
    config = function()
      require("lua.config.formatter")
    end,
  }
  use {
    "simrat39/symbols-outline.nvim",
    config = function()
      require("lua.config.symbols_outline")
    end,
  }

  -- language specific
  use {
    "cuducos/yaml.nvim",
    ft = {"yaml"},
    requires = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("lua.config.yaml")
    end,
  }
  use {"npxbr/go.nvim", requires = {"nvim-lua/plenary.nvim"}, ft = {"go"}}
  use {"folke/lua-dev.nvim", ft = {"lua"}}
  use {
    "vinibispo/ruby.nvim",
    ft = {"ruby"},
    requires = {"nvim-lua/plenary.nvim"},
    config = function()
      require("lua.config.ruby")
    end,
  }

  -- code comments
  use {
    "b3nj5m1n/kommentary",
    config = function()
      require("lua.config.kommentary")
    end,
  }

  -- file tree
  use {
    "kyazdani42/nvim-tree.lua",
    requires = {"kyazdani42/nvim-web-devicons"},
    config = function()
      require("lua.config.tree")
    end,
  }

  -- status & tab lines
  use {
    "hoob3rt/lualine.nvim",
    requires = {"kyazdani42/nvim-web-devicons", opt = true},
    config = function()
      require("lua.config.lualine")
    end,
  }
  use {
    "jose-elias-alvarez/buftabline.nvim",
    requires = {"kyazdani42/nvim-web-devicons"},
    config = function()
      require("lua.config.buftabline")
    end,
  }

  -- visual hints
  use {"markonm/traces.vim"}
  use {
    "winston0410/range-highlight.nvim",
    requires = {"winston0410/cmd-parser.nvim"},
    config = function()
      require("lua.config.traces")
    end,
  }
  use {"lukas-reineke/indent-blankline.nvim"}
  use {
    "ntpeters/vim-better-whitespace",
    config = function()
      require("lua.config.better_whitespace")
    end,
  }
  use {
    "lewis6991/gitsigns.nvim",
    requires = {"nvim-lua/plenary.nvim"},
    config = function()
      require("lua.config.gitsigns")
    end,
  }
  use {"tversteeg/registers.nvim"}

  -- navigation & selection
  use {
    "phaazon/hop.nvim",
    as = "hop",
    config = function()
      require("lua.config.hop")
    end,
  }
  use {
    "terryma/vim-expand-region",
    config = function()
      require("lua.config.expand_region")
    end,
  }

  -- general tools
  use {"tpope/vim-abolish"}
  use {"tpope/vim-fugitive"}
  use {"vim-scripts/greplace.vim", cmd = "Gsearch"}
  use {
    "f-person/git-blame.nvim",
    config = function()
      require("lua.config.git_blame")
    end,
  }
end

return require("packer").startup(startup)
