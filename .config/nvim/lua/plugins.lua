local packer_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(packer_path)) > 0 then
	vim.fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		packer_path,
	})
end
vim.cmd("packadd packer.nvim")

local startup = function(use)
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
		requires = { "nvim-lua/plenary.nvim" },
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
		run = ":TSUpdate",
		config = function()
			require("config.treesitter")
		end,
	})
	use({
		"williamboman/mason.nvim",
		requires = { "neovim/nvim-lspconfig", "williamboman/mason-lspconfig.nvim", "simrat39/rust-tools.nvim" },
		config = function()
			require("config.mason")
			require("config.rust_tools")
		end,
	})
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"hrsh7th/cmp-copilot",
			"hrsh7th/cmp-emoji",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-document-symbol",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-path",
			"onsails/lspkind.nvim",
			"ray-x/cmp-treesitter",
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
		keys = "<Leader>nt",
		requires = "nvim-tree/nvim-web-devicons",
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
		"NeogitOrg/neogit",
		keys = "<Leader>g",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
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

	-- file tree
	use({
		"nvim-tree/nvim-tree.lua",
		keys = "<Leader>nt",
		requires = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("config.tree")
		end,
	})

	-- status & tab lines
	use({
		"hoob3rt/lualine.nvim",
		requires = {
			{ "nvim-tree/nvim-web-devicons", opt = true },
			"WhoIsSethDaniel/lualine-lsp-progress.nvim",
		},
		config = function()
			require("config.lualine")
		end,
	})

	-- visual hints
	use({ "Bekaboo/deadcolumn.nvim" })
	use({ "markonm/traces.vim" })
	use({
		"winston0410/range-highlight.nvim",
		requires = { "winston0410/cmd-parser.nvim" },
		config = function()
			require("config.range_highlight")
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
	use({ "sQVe/sort.nvim", cmd = "Sort" })
	use({
		"rcarriga/nvim-notify",
		config = function()
			require("config.notify")
		end,
	})
	use({
		"rgroli/other.nvim",
		cmd = "Other",
		ft = { "ruby", "go", "typescriptreact" },
		config = function()
			require("config.other")
		end,
	})
	use({
		"vim-test/vim-test",
		cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast" },
		ft = { "elm", "go", "javascript", "python", "ruby", "rust" },
		config = function()
			require("config.test")
		end,
	})
	use({ "stevearc/dressing.nvim" })
	use({
		"ellisonleao/carbon-now.nvim",
		cmd = "CarbonNow",
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
	use({ "lewis6991/fileline.nvim" })
	use({
		"m4xshen/hardtime.nvim",
		config = function()
			require("config.hardtime")
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
		cmd = "ChatGPT",
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

	-- shopify
	if os.getenv("SPIN") ~= nil then
		use({
			"ojroques/vim-oscyank",
			config = function()
				require("config.oscyank")
			end,
		})
		use("Shopify/spin-hud")
	end
end

return require("packer").startup({ startup, config = { autoremove = true } })
