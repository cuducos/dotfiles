-- bootstrap Packer
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	vim.fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

vim.cmd("packadd packer.nvim")

-- add plugins
local startup = function(use)
	use({ "wbthomason/packer.nvim" })

	-- colorscheme
	use({
		"catppuccin/nvim",
		as = "catppuccin",
		config = function()
			require("config.catppuccin")
		end,
	})

	-- fuzzy finder
	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-file-browser.nvim",
		},
		config = function()
			require("config.telescope")
		end,
	})
	use({
		"gelguy/wilder.nvim",
		run = ":UpdateRemotePlugins",
		config = function()
			require("config.wilder")
		end,
	})

	-- lsp & treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = "TSUpdate",
		config = function()
			require("config.treesitter")
		end,
	})
	use({
		"williamboman/mason.nvim",
		requires = { "neovim/nvim-lspconfig", "williamboman/mason-lspconfig.nvim", "simrat39/rust-tools.nvim" },
		config = function()
			require("config.mason")
			require("config.ruby_lsp")
			require("config.rust_tools")
		end,
	})
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-emoji",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-path",
			"onsails/lspkind.nvim",
			"ray-x/cmp-treesitter",
			"hrsh7th/cmp-copilot",
			{
				"saadparwaiz1/cmp_luasnip",
				requires = {
					"L3MON4D3/LuaSnip",
					tag = "v1.*",
					requires = { "rafamadriz/friendly-snippets" },
					config = function()
						require("config.luasnip")
					end,
				},
			},
		},
		config = function()
			require("config.cmp")
		end,
	})
	use({
		"jose-elias-alvarez/null-ls.nvim",
		config = function()
			require("config.null_ls")
		end,
	})
	use({
		"folke/trouble.nvim",
		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("config.trouble")
		end,
	})
	use({
		"haringsrob/nvim_context_vt",
		config = function()
			require("config.nvim_context_vt")
		end,
		cond = function()
			local skip = { "python", "yaml" }
			for _, ft in pairs(skip) do
				if ft == vim.bo.filetype then
					return false
				end
			end
			return true
		end,
	})
	use({
		"mizlan/iswap.nvim",
		config = function()
			require("config.iswap")
		end,
	})

	-- language specific
	use({
		"cuducos/yaml.nvim",
		ft = { "yaml" },
		requires = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("config.yaml")
		end,
	})
	use({ "fladson/vim-kitty" })
	use({ "RRethy/nvim-treesitter-endwise", ft = { "lua", "ruby" } })

	-- code comments
	use({
		"b3nj5m1n/kommentary",
		config = function()
			require("config.kommentary")
		end,
	})

	-- git
	use({
		"TimUntersberger/neogit",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("config.neogit")
		end,
	})
	use({
		"lewis6991/gitsigns.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("config.gitsigns")
		end,
	})

	-- status & tab lines
	use({
		"hoob3rt/lualine.nvim",
		requires = {
			{ "kyazdani42/nvim-web-devicons", opt = true },
			"WhoIsSethDaniel/lualine-lsp-progress.nvim",
		},
		config = function()
			require("config.lualine")
		end,
	})

	-- visual hints
	use({ "markonm/traces.vim" })
	use({
		"winston0410/range-highlight.nvim",
		requires = { "winston0410/cmd-parser.nvim" },
		config = function()
			require("config.traces")
		end,
	})
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("config.indent")
		end,
	})
	use({
		"ntpeters/vim-better-whitespace",
		config = function()
			require("config.better_whitespace")
		end,
	})
	use({ "andymass/vim-matchup" })

	-- navigation & selection
	use({
		"rlane/pounce.nvim",
		config = function()
			require("config.pounce")
		end,
	})

	-- general tools
	use({ "tpope/vim-abolish" })
	use({ "sQVe/sort.nvim" })
	use({
		"rizzatti/dash.vim",
		cond = function()
			return vim.loop.fs_stat("/Users/cuducos/") ~= nil
		end,
	})
	use({
		"akinsho/toggleterm.nvim",
		config = function()
			require("config.toggleterm")
		end,
	})
	use({
		"rcarriga/nvim-notify",
		config = function()
			require("config.notify")
		end,
	})
	use({
		"rgroli/other.nvim",
		ft = { "ruby", "go" },
		config = function()
			require("config.other")
		end,
	})
	use({
		"vim-test/vim-test",
		ft = { "elm", "go", "javascript", "python", "ruby", "rust" },
		config = function()
			require("config.test")
		end,
	})
	use({
		"rest-nvim/rest.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("config.rest")
		end,
	})
	use({ "stevearc/dressing.nvim" })
	use({
		"ellisonleao/carbon-now.nvim",
		config = function()
			require("config.carbon")
		end,
	})
	use({
		"goolord/alpha-nvim",
		requires = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("config.alpha")
		end,
	})
	use({
		"michaelb/sniprun",
		run = "bash install.sh",
		cmd = { "SnipRun", "SnipInfo" },
		cond = function()
			return vim.fn.executable("cargo") == 1
		end,
	})

	-- ai
	use({
		"github/copilot.vim",
		config = function()
			require("config.copilot")
		end,
	})
	use({
		"jackMort/ChatGPT.nvim",
		config = function()
			require("config.chatgpt")
		end,
		cond = function()
			return os.getenv("OPENAI_API_KEY") ~= nil
		end,
		requires = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	})
end

-- load plugins
return require("packer").startup({ startup, config = { autoremove = true } })
