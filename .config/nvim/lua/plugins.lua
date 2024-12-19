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
			"mrcjkb/rustaceanvim",
		},
		config = function()
			require("config.mason")
		end,
	},
	{
		"saghen/blink.cmp",
		build = "cargo build --release && cargo clean",
		dependencies = {
			"rafamadriz/friendly-snippets",
			{
				"giuxtaposition/blink-cmp-copilot",
				dependencies = { "zbirenbaum/copilot.lua" },
				config = function()
					require("config.copilot")
				end,
			},
		},
		opts = {
			keymap = { preset = "default" },
			completion = {
				documentation = { auto_show = true, window = { border = "rounded" } },
				menu = { border = "rounded" },
			},
			appearance = {
				use_nvim_cmp_as_default = true,
				nerd_font_variant = "mono",
			},
			snippets = {
				expand = function(snippet)
					require("luasnip").lsp_expand(snippet)
				end,
				active = function(filter)
					if filter and filter.direction then
						return require("luasnip").jumpable(filter.direction)
					end
					return require("luasnip").in_snippet()
				end,
				jump = function(direction)
					require("luasnip").jump(direction)
				end,
			},
			sources = {
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						score_offset = 100,
						async = true,
					},
				},
				default = { "copilot", "lsp", "buffer", "path", "luasnip" },
			},
		},
		opts_extend = { "sources.default" },
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
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "codecompanion" },
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
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("config.codecompanion")
		end,
	},
}

require("lazy").setup(plugins)
