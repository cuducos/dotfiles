-- bootstrap Packer
local packer_path = "/site/pack/packer/start/packer.nvim"
local install_path = vim.fn.stdpath("data") .. packer_path
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	local repo = "https://github.com/wbthomason/packer.nvim"
	local clone = { "git", "clone", "--depth", "1", repo, install_path }
	PackerBboostraped = vim.fn.system(clone)
end

vim.cmd([[packadd packer.nvim]])

if PackerBboostraped then
	require("packer").sync()
end

local packer_user_config = vim.api.nvim_create_augroup("PackerUserConfig", {})
vim.api.nvim_create_autocmd(
	"BufWritePost",
	{ group = packer_user_config, pattern = "plugins.lua", command = "source <afile> | PackerCompile" }
)

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
		requires = { "nvim-lua/plenary.nvim", "nvim-lua/popup.nvim" },
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

	-- lsp
	use({
		"nvim-treesitter/nvim-treesitter",
		run = "TSUpdate",
		config = function()
			require("config.treesitter")
		end,
	})
	use({
		"neovim/nvim-lspconfig",
		requires = { { "williamboman/nvim-lsp-installer" } },
		config = function()
			require("config.lsp")
		end,
	})
	use({
		"hrsh7th/nvim-cmp",
		requires = {
			"f3fora/cmp-spell",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-calc",
			"hrsh7th/cmp-emoji",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-path",
			"quangnguyen30192/cmp-nvim-tags",
			"ray-x/cmp-treesitter",
			"lukas-reineke/cmp-rg",
			"petertriho/cmp-git",
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
		"simrat39/symbols-outline.nvim",
		config = function()
			require("config.symbols_outline")
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
		"Maan2003/lsp_lines.nvim",
		config = function()
			require("config.lsp_lines")
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
	use({
		"vinibispo/ruby.nvim",
		ft = { "ruby" },
		requires = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
	})
	use({ "fladson/vim-kitty" })
	use({ "RRethy/nvim-treesitter-endwise", ft = { "lua", "ruby" } })
	use({ "jose-elias-alvarez/nvim-lsp-ts-utils", ft = { "typescript" } })
	use({ "ellisonleao/glow.nvim", ft = { "markdown" } })

	-- debug
	use({
		"mfussenegger/nvim-dap",
		config = function()
			require("config.dap")
		end,
	})
	use({
		"suketa/nvim-dap-ruby",
		ft = { "ruby" },
		config = function()
			require("config.dap_ruby")
		end,
	})

	-- copilot
	use({
		"github/copilot.vim",
		config = function()
			require("config.copilot")
		end,
	})

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

	-- file tree
	use({
		"kyazdani42/nvim-tree.lua",
		requires = { "kyazdani42/nvim-web-devicons" },
		config = function()
			require("config.tree")
		end,
	})

	-- status & tab lines
	use({
		"hoob3rt/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = function()
			require("config.lualine")
		end,
	})
	use({
		"jose-elias-alvarez/buftabline.nvim",
		requires = { "kyazdani42/nvim-web-devicons" },
		config = function()
			require("config.buftabline")
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
	use({ "tversteeg/registers.nvim" })
	use({ "andymass/vim-matchup" })

	-- navigation & selection
	use({
		"rlane/pounce.nvim",
		config = function()
			require("config.pounce")
		end,
	})
	use({
		"terryma/vim-expand-region",
		config = function()
			require("config.expand_region")
		end,
	})

	-- general tools
	use({ "tpope/vim-abolish" })
	use({ "vim-scripts/greplace.vim", cmd = "Gsearch" })
	if vim.loop.fs_stat("/Users/cuducos/") ~= nil then
		use({ "rizzatti/dash.vim" })
	end
	if os.getenv("SPIN") ~= nil then
		use({
			"ojroques/vim-oscyank",
			config = function()
				require("config.oscyank")
			end,
		})
	end
	use({
		"rcarriga/nvim-notify",
		config = function()
			require("config.notify")
		end,
	})
end

-- load plugins
return require("packer").startup(startup)
