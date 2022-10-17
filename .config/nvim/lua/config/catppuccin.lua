vim.g.catppuccin_flavour = "latte"
local colors = require("catppuccin.palettes").get_palette()
require("catppuccin").setup({
	integrations = {
		cmp = true,
		gitsigns = true,
		lsp_trouble = true,
		mason = true,
		neogit = true,
		notify = true,
		nvimtree = true,
		pounce = true,
		telescope = true,
		treesitter = true,
		treesitter_context = true,
		indent_blankline = {
			enabled = true,
			colored_indent_levels = true,
		},
	},
	custom_highlights = {
		NotifyINFOTitle = { fg = colors.sky, style = {} },
	},
})
vim.cmd("colorscheme catppuccin")
