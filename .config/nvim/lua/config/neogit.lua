require("neogit").setup({ disable_commit_confirmation = true })
vim.keymap.set("n", "<Leader>g", require("neogit").open)
