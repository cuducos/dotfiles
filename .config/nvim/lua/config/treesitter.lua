require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"css",
		"dockerfile",
		"elm",
		"fish",
		"gitcommit",
		"go",
		"gomod",
		"graphql",
		"html",
		"http",
		"javascript",
		"json",
		"lua",
		"python",
		"regex",
		"rust",
		"scss",
		"toml",
		"vim",
		"yaml",
	},
	highlight = { enable = true, disable = {} },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<Leader>is",
			node_incremental = "+",
			scope_incremental = "w",
			node_decremental = "-",
		},
	},
	indent = { enable = true },
	endwise = { enable = true },
})
