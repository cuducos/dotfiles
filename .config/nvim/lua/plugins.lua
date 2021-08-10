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
      vim.g.material_style = "palenight"
      require("material").set()

    end,
  }

  -- code comments
  use {
    "b3nj5m1n/kommentary",
    config = function()
      require("kommentary.config").configure_language(
        "default", {prefer_single_line_comments = true}
      )
    end,
  }

  -- search, grep
  use {
    "nvim-telescope/telescope.nvim",
    requires = {"nvim-lua/plenary.nvim", "nvim-lua/popup.nvim"},
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup(
        {defaults = {mappings = {i = {["<Esc>"] = actions.close}}}}
      )

      _G.find_dotfiles = function()
        require("telescope.builtin").find_files(
          {
            search_dirs = {"~/Dropbox/Projects/dotfiles"},
            hidden = true,
            follow = true,
          }
        )
      end

      local opts = {noremap = true}
      local mappings = {
        {"n", "<Leader>g", [[<Cmd>Telescope git_files<CR>]], opts},
        {"n", "<Leader>G", [[<Cmd>Telescope git_status<CR>]], opts},
        {"n", "<Leader>f", [[<Cmd>Telescope find_files<CR>]], opts},
        {"n", "<Leader>b", [[<Cmd>Telescope buffers<CR>]], opts},
        {"n", "<Leader>o", [[<Cmd>Telescope oldfiles<CR>]], opts},
        {"n", "<Leader>/", [[<Cmd>Telescope live_grep<CR>]], opts},
        {"n", "<Leader>df", [[<Cmd>lua find_dotfiles()<CR>]], opts},
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
      require"nvim-treesitter.configs".setup {
        ensure_installed = {
          "bash",
          "css",
          "dockerfile",
          "elm",
          "fish",
          "go",
          "gomod",
          "graphql",
          "html",
          "javascript",
          "json",
          "lua",
          "python",
          "regex",
          "rst",
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
    end,
  }
  use {"npxbr/go.nvim", requires = {"nvim-lua/plenary.nvim"}, ft = {"go"}}
  use {"folke/lua-dev.nvim", ft = {"lua"}}
  use {
    "vinibispo/ruby.nvim",
    ft = {"ruby"},
    requires = {"nvim-lua/plenary.nvim"},
    config = function()
      local rb = require("ruby_nvim")
      require("ruby_nvim").setup({test_cmd = "cat"})
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
    "simrat39/symbols-outline.nvim",
    config = function()
      vim.api.nvim_set_keymap(
        "n", "<Leader>tt", "<Cmd>SymbolsOutline<CR>", {noremap = true}
      )
    end,
  }
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

  -- file tree
  use {
    "kyazdani42/nvim-tree.lua",
    requires = {"kyazdani42/nvim-web-devicons"},
    config = function()
      vim.g.nvim_tree_add_trailing = 1
      vim.g.nvim_tree_highlight_opened_files = 1
      vim.g.nvim_tree_ignore = {
        [[\.pyc$]],
        "__pycache__",
        ".git",
        ".DS_Store",
        ".ropeproject",
        ".coverage",
        "cover/",
      }
      vim.g.nvim_tree_width = 36
      vim.g.nvim_tree_width_allow_resize = 1

      vim.api.nvim_set_keymap(
        "n", "<Leader>nt", "<Cmd>NvimTreeToggle<CR>", {noremap = true}
      )
    end,
  }

  -- status & tab lines
  use {
    "hoob3rt/lualine.nvim",
    requires = {"kyazdani42/nvim-web-devicons", opt = true},
    config = function()
      require("lualine").setup {
        options = {
          section_separators = {"", ""},
          component_separators = {"", ""},
          theme = "material-nvim",
        },
        sections = {
          lualine_a = {"mode"},
          lualine_b = {"branch", "diff"},
          lualine_c = {
            function()
              return "%f"
            end,
          },
          lualine_x = {"encoding", "fileformat", "filetype"},
          lualine_y = {
            function()
              return "%p%%"
            end,
          },
          lualine_z = {"location"},
        },
      }
    end,
  }
  use {
    "jose-elias-alvarez/buftabline.nvim",
    requires = {"kyazdani42/nvim-web-devicons"},
    config = function()
      require("buftabline").setup {
        index_format = "%d ",
        icons = true,
        buffer_id_index = true,
        hlgroup_normal = "TabLine",
      }
    end,
  }

  -- line command tools
  use {"markonm/traces.vim"}
  use {
    "winston0410/range-highlight.nvim",
    requires = {"winston0410/cmd-parser.nvim"},
    config = function()
      require"range-highlight".setup {}
    end,
  }

  -- cursor
  use {
    "phaazon/hop.nvim",
    as = "hop",
    config = function()
      require("hop").setup({keys = "etovxqpdygfblzhckisuran"})
      vim.api.nvim_set_keymap(
        "n", ";", "<Cmd>lua require('hop').hint_char2()<CR>", {}
      )
    end,
  }
  use {
    "terryma/vim-expand-region",
    config = function()
      vim.api.nvim_set_keymap("v", "v", "<Plug>(expand_region_expand)", {})
      vim.api.nvim_set_keymap("v", "<C-v>", "<Plug>(expand_region_shrink)", {})
    end,
  }

  -- ui
  use {"lukas-reineke/indent-blankline.nvim"}
  use {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup()
    end,
  }
  use {
    "ntpeters/vim-better-whitespace",
    config = function()
      vim.api.nvim_set_keymap(
        "n", "<Leader>fw", "<Cmd>StripWhitespace<CR>", {noremap = true}
      )
    end,
  }

  -- general tools
  use {"tpope/vim-abolish"}
  use {"tpope/vim-fugitive"}
  use {"vim-scripts/greplace.vim", cmd = "Gsearch"}
  use {
    "lewis6991/gitsigns.nvim",
    requires = {"nvim-lua/plenary.nvim"},
    config = function()
      require"gitsigns".setup({numhl = true})
    end,
  }
  use {
    "f-person/git-blame.nvim",
    config = function()
      vim.g.gitblame_enabled = 0
    end,
  }
  use {"tversteeg/registers.nvim"}
  use {
    "cuducos/yaml.nvim",
    ft = {"yaml"},
    requires = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("yaml_nvim").init()
      local mappings = {
        {"n", "<Leader>y", "<Cmd>YAMLTelescope<CR>"},
        {"n", "<Leader>yy", "<Cmd>YAMLView<CR>"},
        {"n", "<Leader>Y", "<Cmd>YAMLYank<CR>"},
        {"n", "<Leader>Yk", "<Cmd>YAMLYankKey<CR>"},
      }
      for _, args in pairs(mappings) do
        vim.api.nvim_set_keymap(unpack(args), {noremap = true, silent = true})
      end
    end,
  }

end

return require("packer").startup(startup)
