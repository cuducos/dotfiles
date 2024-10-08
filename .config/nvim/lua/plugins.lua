local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugins = {

	-- colorscheme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require("config.catppuccin")
		end,
	},

	-- fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-live-grep-args.nvim", version = "^1.0.0" },
		},
		config = function()
			require("config.telescope")
		end,
	},
	{
		"wookayin/wilder.nvim", -- go back to gelguy/wilder.nvim once https://github.com/gelguy/wilder.nvim/issues/187 is fixed
		dependencies = { "romgrk/fzy-lua-native" },
		config = function()
			require("config.wilder")
		end,
	},

	-- lsp & treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("config.treesitter")
		end,
	},
	{
		"williamboman/mason.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"williamboman/mason-lspconfig.nvim",
			"simrat39/rust-tools.nvim",
		},
		config = function()
			require("config.mason")
			require("config.rust_tools")
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			{
				"Exafunction/codeium.nvim",
				dependencies = {
					"nvim-lua/plenary.nvim",
				},
				config = function()
					require("config.codeium")
				end,
			},
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-document-symbol",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-path",
			"onsails/lspkind.nvim",
			"ray-x/cmp-treesitter",
		},
		config = function()
			require("config.cmp")
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		config = function()
			require("config.none_ls")
		end,
	},
	{
		"folke/trouble.nvim",
		keys = "<Leader>t",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("config.trouble")
		end,
	},
	{
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
	},
	{
		"ckolkey/ts-node-action",
		dependencies = { "nvim-treesitter" },
	},

	-- language specific
	{
		"cuducos/yaml.nvim",
		ft = { "yaml" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("config.yaml")
		end,
	},
	{
		"alexpasmantier/pymple.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		build = ":PympleBuild",
		config = function()
			require("config.pymple")
		end,
	},
	{ "fladson/vim-kitty", ft = { "kitty" } },
	{ "RRethy/nvim-treesitter-endwise", ft = { "lua" } },

	-- git
	{
		"NeogitOrg/neogit",
		keys = "<Leader>g",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("config.neogit")
		end,
	},
	{
		"lewis6991/gitsigns.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("config.gitsigns")
		end,
	},

	-- file tree
	{
		"nvim-tree/nvim-tree.lua",
		keys = "<Leader>nt",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"antosha417/nvim-lsp-file-operations",
		},
		config = function()
			require("config.tree")
		end,
	},

	-- status & tab lines
	{
		"hoob3rt/lualine.nvim",
		dependencies = {
			{ "nvim-tree/nvim-web-devicons", opt = true },
			"linrongbin16/lsp-progress.nvim",
		},
		config = function()
			require("config.lualine")
		end,
	},

	-- visual hints
	{ "Bekaboo/deadcolumn.nvim" },
	{ "markonm/traces.vim" },
	{
		"winston0410/range-highlight.nvim",
		dependencies = { "winston0410/cmd-parser.nvim" },
		config = function()
			require("config.range_highlight")
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			require("config.indent")
		end,
	},
	{
		"ntpeters/vim-better-whitespace",
		config = function()
			require("config.better_whitespace")
		end,
	},
	{ "andymass/vim-matchup" },
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		dependencies = { "rafamadriz/friendly-snippets" },
		config = function()
			require("config.luasnip")
		end,
	},
	{
		"OXY2DEV/markview.nvim",
		ft = "markdown",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
	{
		"folke/todo-comments.nvim",
		config = function()
			require("config.todo")
		end,
	},

	-- navigation & selection
	{
		"folke/flash.nvim",
		keys = {
			{
				"<Tab>",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
			},
		},
	},
	{
		"drybalka/tree-climber.nvim",
		config = function()
			require("config.climber")
		end,
	},

	-- general tools
	{ "tpope/vim-abolish" },
	{ "sQVe/sort.nvim", cmd = "Sort" },
	{
		"rcarriga/nvim-notify",
		config = function()
			require("config.notify")
		end,
	},
	{
		"rgroli/other.nvim",
		cmd = "Other",
		ft = { "go", "typescriptreact" },
		config = function()
			require("config.other")
		end,
	},
	{ "stevearc/dressing.nvim" },
	{
		"ellisonleao/carbon-now.nvim",
		cmd = "CarbonNow",
		config = function()
			require("config.carbon")
		end,
	},
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("config.alpha")
		end,
	},
	{ "lewis6991/fileline.nvim" },
	{
		"MagicDuck/grug-far.nvim",
		config = function()
			require("config.grug_far")
		end,
	},
	{
		"m4xshen/hardtime.nvim",
		config = function()
			require("config.hardtime")
		end,
	},

	-- ai
	{
		"yetone/avante.nvim",
		version = false,
		event = "VeryLazy",
		build = "make BUILD_FROM_SOURCE=true",
		lazy = false,
		opts = { provider = "claude" },
		dependencies = {
			"stevearc/dressing.nvim",
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
}

require("lazy").setup(plugins)
