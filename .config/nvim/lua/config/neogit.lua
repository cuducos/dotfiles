require("neogit").setup({
	use_telescope = true,
	disable_commit_confirmation = true,
})

vim.keymap.set("n", "<leader>g", require("neogit").open)
