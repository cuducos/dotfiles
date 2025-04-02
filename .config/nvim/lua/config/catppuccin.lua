local theme = os.getenv("CATPPUCCIN_THEME") or "latte"
vim.g.catppuccin_flavour = theme

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

if theme == "frappe" then
	vim.cmd("highlight NormalFloat guifg=#b9bcee guibg=#303445")
else
	vim.cmd("highlight NormalFloat guifg=#4c4f69 guibg=#eff1f5")
end
