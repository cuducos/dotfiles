require("neogit").setup({
	use_telescope = true,
	disable_commit_confirmation = true,
})

vim.keymap.set("n", "<Leader>g", require("neogit").open)
