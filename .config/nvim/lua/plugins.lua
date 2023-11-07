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
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("config.telescope")
		end,
	},
	{
		"gelguy/wilder.nvim",
		build = ":UpdateRemotePlugins",
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
				dependencies = {
					"L3MON4D3/LuaSnip",
					version = "v1.*",
					dependencies = { "rafamadriz/friendly-snippets" },
					config = function()
						require("config.luasnip")
					end,
				},
			},
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
		"hinell/lsp-timeout.nvim",
		dependencies = { "neovim/nvim-lspconfig" },
		config = function()
			require("config.lsp_timeout")
		end,
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
	{ "fladson/vim-kitty" },
	{ "RRethy/nvim-treesitter-endwise", ft = { "lua", "ruby" } },

	-- code comments
	{
		"b3nj5m1n/kommentary",
		config = function()
			require("config.kommentary")
		end,
	},

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

	-- navigation & selection
	{
		"ggandor/leap.nvim",
		config = function()
			require("config.leap")
		end,
	},
	{
		"karb94/neoscroll.nvim",
		config = function()
			require("config.neoscroll")
		end,
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
		ft = { "ruby", "go", "typescriptreact" },
		config = function()
			require("config.other")
		end,
	},
	{
		"vim-test/vim-test",
		cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast" },
		ft = { "elm", "go", "javascript", "python", "ruby", "rust" },
		config = function()
			require("config.test")
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
	{
		"michaelb/sniprun",
		build = "bash install.sh",
		cmd = { "SnipRun", "SnipInfo" },
		cond = function()
			return vim.fn.executable("cargo") == 1
		end,
	},
	{ "lewis6991/fileline.nvim" },
	{
		"m4xshen/hardtime.nvim",
		config = function()
			require("config.hardtime")
		end,
	},

	-- ai
	{
		"github/copilot.vim",
		config = function()
			require("config.copilot")
		end,
	},
	{
		"jackMort/ChatGPT.nvim",
		cmd = "ChatGPT",
		config = function()
			require("config.chatgpt")
		end,
		cond = function()
			return os.getenv("OPENAI_API_KEY") ~= nil
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
}

if os.getenv("SPIN") ~= nil then
	table.insert(plugins, { "Shopify/spin-hud" })
	table.insert(plugins, {
		"ojroques/vim-oscyank",
		config = function()
			require("config.oscyank")
		end,
	})
end

require("lazy").setup(plugins)
