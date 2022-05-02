vim.g.nvim_tree_add_trailing = 1
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_width = 36
vim.g.nvim_tree_width_allow_resize = 1

require("nvim-tree").setup({
	filters = {
		custom = {
			[[\.pyc$]],
			"__pycache__",
			".git",
			".DS_Store",
			".ropeproject",
			".coverage",
			"cover/",
		},
	},
})

vim.keymap.set("n", "<Leader>nt", "<Cmd>NvimTreeToggle<CR>")
