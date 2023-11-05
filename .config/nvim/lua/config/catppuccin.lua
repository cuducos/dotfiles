vim.g.catppuccin_flavour = os.getenv("CATPPUCCIN_THEME") or "latte"

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

-- set float window background color to the same as the normal window
vim.cmd("highlight NormalFloat guifg=#4c4f69 guibg=#eff1f5")
