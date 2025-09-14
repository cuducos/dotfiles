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
			".DS_Store",
			".coverage",
			".git/",
			".ropeproject",
			"__pycache__",
			"cover/",
			[[\.pyc$]],
		},
	},
})
vim.keymap.set("n", "<Leader>nt", "<Cmd>NvimTreeToggle<CR>")

require("lsp-file-operations").setup()
