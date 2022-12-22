-- bootstrap Packer
local packer_path = "/site/pack/packer/start/packer.nvim"
local install_path = vim.fn.stdpath("data") .. packer_path
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
	local repo = "https://github.com/wbthomason/packer.nvim"
	local clone = { "git", "clone", "--depth", "1", repo, install_path }
	PackerBoostraped = vim.fn.system(clone)
end

vim.cmd("packadd packer.nvim")

if PackerBoostraped then
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
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-lua/popup.nvim",
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
		requires = { "neovim/nvim-lspconfig", "williamboman/mason-lspconfig.nvim" },
		config = function()
			require("config.mason")
			require("config.ruby_lsp")
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
			"saadparwaiz1/cmp_luasnip",
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
		"AckslD/nvim-trevJ.lua",
		ft = { "go", "html", "treesitter", "lua", "python", "ruby", "rust", "typescript" },
		config = function()
			require("config.trevj")
		end,
	})

	-- snippets
	use({
		"L3MON4D3/LuaSnip",
		tag = "v1.*",
		config = function()
			require("config.luasnip")
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
	use({ "sQVe/sort.nvim" })
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
		"folke/persistence.nvim",
		config = function()
			require("config.persistence")
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
		requires = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	})
	use({
		"rest-nvim/rest.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("config.rest")
		end,
	})
end

-- load plugins
return require("packer").startup(startup)
