require("nvim-tree").setup({
	disable_netrw = true,
	view = { width = "38%" },
	renderer = {
		highlight_opened_files = "all",
		add_trailing = true,
	},
	diagnostics = {
		enable = true,
		show_on_dirs = true,
	},
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
