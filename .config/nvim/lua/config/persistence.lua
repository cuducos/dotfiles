require("persistence").setup({ dir = "/tmp/persistence.nvim/" })

vim.keymap.set("n", "<leader>LS", require("persistence").load)
vim.keymap.set("n", "<leader>ls", function()
	require("persistence").load({ last = true })
end)
